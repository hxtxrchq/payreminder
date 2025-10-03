import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../logic/providers/save_debt_controller.dart';
import '../../../domain/usecases/save_debt_usecase.dart';
import '../../../logic/providers/repository_providers.dart';
import '../../../data/db/app_database.dart' as db;
import '../../../logic/providers/category_providers.dart';
import '../../../logic/providers/occurrence_providers.dart';
import '../../../logic/providers/summary_providers.dart';
import '../../../logic/providers/month_counts_provider.dart';
import '../../../logic/providers/template_providers.dart';
import '../../../logic/providers/occurrence_providers.dart' as op2;

class TemplateFormScreen extends ConsumerStatefulWidget {
  final String? templateId;
  const TemplateFormScreen({super.key, this.templateId});

  @override
  ConsumerState<TemplateFormScreen> createState() => _TemplateFormScreenState();
}

class _TemplateFormScreenState extends ConsumerState<TemplateFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _customOffsetCtrl = TextEditingController();

  // Basic fields
  // Legacy categoría por nombre eliminada; unificamos con Categories.categoryId
  String? _cardId; // legacy
  String? _paymentMethodId;
  String? _categoryId;
  DebtType _type = DebtType.punctual;

  // Puntual
  DateTime? _dueDate;

  // Recurrente
  String _freq = 'MONTHLY_BY_DOM';
  int _diaMes = DateTime.now().day;
  int _dow = DateTime.now().weekday; // 1..7
  int _everyNDays = 1;
  DateTime _fechaInicio = DateTime.now();
  DateTime? _fechaFin;
  int? _totalCiclos;

  // Offsets
  final Set<int> _offsets = {-5, 0};

  // Intereses
  bool _hasInterest = false;
  String _interestType = 'FIXED_INSTALLMENTS';
  final _interestRateCtrl = TextEditingController();
  final _termMonthsCtrl = TextEditingController();
  final _graceMonthsCtrl = TextEditingController(text: '0');

  @override
  void initState() {
    super.initState();
    if (widget.templateId != null) {
      _loadForEdit(widget.templateId!);
    }
  }

  Future<void> _loadForEdit(String id) async {
    final tmpl = await ref.read(templateRepositoryProvider).getTemplate(id);
    if (tmpl != null) {
      _nameCtrl.text = tmpl.nombre;
      _amountCtrl.text = tmpl.monto.toStringAsFixed(2);
      // categoria (legacy) no se usa ya en el formulario unificado
      _cardId = tmpl.cardId;
      // Prefill paymentMethodId si existe en el esquema
      _paymentMethodId = tmpl.paymentMethodId;
      _notesCtrl.text = tmpl.notas ?? '';
      _categoryId = tmpl.categoryId;
      _hasInterest = tmpl.hasInterest;
      _interestType = tmpl.interestType ?? 'FIXED_INSTALLMENTS';
      if (tmpl.interestRateMonthly != null) {
        _interestRateCtrl.text = tmpl.interestRateMonthly!.toString();
      }
      if (tmpl.termMonths != null)
        _termMonthsCtrl.text = tmpl.termMonths.toString();
      if (tmpl.graceMonths != null)
        _graceMonthsCtrl.text = tmpl.graceMonths.toString();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final saveState = ref.watch(saveDebtControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.templateId == null
            ? 'Nuevo recordatorio de pago'
            : 'Editar deuda'),
        leading: BackButton(
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/debts'),
        ),
      ),
      body: AbsorbPointer(
        absorbing: saveState.loading,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _sectionDatosBasicos(),
                    const SizedBox(height: 12),
                    _sectionTipo(),
                    const SizedBox(height: 12),
                    _sectionRecordatorios(),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton(
                            onPressed: _onSave,
                            child: const Text('Guardar'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        TextButton(
                          onPressed: () => context.canPop()
                              ? context.pop()
                              : context.go('/debts'),
                          child: const Text('Cancelar'),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            if (saveState.loading)
              const Align(
                alignment: Alignment.topCenter,
                child: LinearProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  // Sección A — Datos básicos
  Widget _sectionDatosBasicos() {
    // Dropdown unificado con Categories + botón Gestionar…
    Widget _dropdownCategoriaUnificada() {
      final cats = ref.watch(categoriesStreamProvider);
      return cats.when(
        data: (list) {
          final items = <DropdownMenuItem<String?>>[
            const DropdownMenuItem(value: null, child: Text('Sin categoría')),
            ...list.map((c) => DropdownMenuItem<String?>(
                  value: c.id,
                  child: Text(c.name, overflow: TextOverflow.ellipsis),
                )),
          ];
          return Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String?>(
                  isExpanded: true,
                  value: _categoryId,
                  items: items,
                  onChanged: (v) => setState(() => _categoryId = v),
                  decoration: const InputDecoration(labelText: 'Categoría'),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () async {
                  await context.push('/categories');
                  if (mounted) ref.invalidate(categoriesStreamProvider);
                },
                icon: const Icon(Icons.category_outlined),
                label: const Text('Gestionar…'),
              )
            ],
          );
        },
        loading: () => const LinearProgressIndicator(minHeight: 2),
        error: (e, _) => Text('Error cargando categorías: $e'),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Datos básicos',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Nombre'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Requerido' : null,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _amountCtrl,
              decoration: const InputDecoration(labelText: 'Monto'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (v) {
                final t = (v ?? '').replaceAll(',', '.');
                final d = double.tryParse(t);
                if (d == null || d <= 0) return 'Monto inválido';
                return null;
              },
            ),
            const SizedBox(height: 8),
            _dropdownCategoriaUnificada(),
            const SizedBox(height: 8),
            _dropdownMetodoPago(),
            const SizedBox(height: 12),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Tiene intereses'),
              value: _hasInterest,
              onChanged: (v) => setState(() => _hasInterest = v),
            ),
            if (_hasInterest) ...[
              DropdownButtonFormField<String>(
                value: _interestType,
                decoration: const InputDecoration(labelText: 'Tipo de interés'),
                items: const [
                  DropdownMenuItem(
                      value: 'FIXED_INSTALLMENTS', child: Text('Cuotas fijas')),
                  DropdownMenuItem(value: 'FLEXIBLE', child: Text('Flexible')),
                ],
                onChanged: (v) =>
                    setState(() => _interestType = v ?? 'FIXED_INSTALLMENTS'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _interestRateCtrl,
                decoration:
                    const InputDecoration(labelText: 'Tasa mensual (%)'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              if (_interestType == 'FIXED_INSTALLMENTS') ...[
                const SizedBox(height: 8),
                TextFormField(
                  controller: _termMonthsCtrl,
                  decoration: const InputDecoration(labelText: 'Plazo (meses)'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _graceMonthsCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Meses de gracia'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ],
            const SizedBox(height: 12),
            TextFormField(
              controller: _notesCtrl,
              decoration: const InputDecoration(labelText: 'Notas'),
              minLines: 1,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  // Eliminado: dropdowns legacy de categoría. Se usa solo _dropdownCategoriaUnificada() dentro de Datos básicos.

  Widget _dropdownMetodoPago() {
    return FutureBuilder<List<db.PaymentMethod>>(
      future: ref.read(paymentMethodRepositoryProvider).getAll(),
      builder: (context, snap) {
        final methods = snap.data ?? <db.PaymentMethod>[];
        final items = <DropdownMenuItem<String?>>[
          const DropdownMenuItem(value: null, child: Text('Sin método')),
          ...methods.map((m) => DropdownMenuItem(
                value: m.id,
                child: Text(
                    m.type == 'CARD' && (m.last4 ?? '').isNotEmpty
                        ? '${m.alias} (****${m.last4})'
                        : m.alias,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              )),
        ];
        return Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String?>(
                isExpanded: true,
                value: _paymentMethodId,
                items: items,
                onChanged: (v) => setState(() => _paymentMethodId = v),
                decoration: const InputDecoration(labelText: 'Método de pago'),
              ),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: () async {
                await context.push('/payment-methods');
                if (mounted)
                  setState(() {}); // fuerza rebuild del FutureBuilder
              },
              icon: const Icon(Icons.credit_card),
              label: const Text('Gestionar métodos…'),
            )
          ],
        );
      },
    );
  }

  // Sección B — Tipo de deuda
  Widget _sectionTipo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tipo de recordatorio',
                style: Theme.of(context).textTheme.titleMedium),
            Row(
              children: [
                Radio<DebtType>(
                  value: DebtType.punctual,
                  groupValue: _type,
                  onChanged: (v) => setState(() => _type = v!),
                ),
                const Text('Puntual'),
                const SizedBox(width: 16),
                Radio<DebtType>(
                  value: DebtType.recurrent,
                  groupValue: _type,
                  onChanged: (v) => setState(() => _type = v!),
                ),
                const Text('Recurrente'),
              ],
            ),
            const SizedBox(height: 8),
            if (_type == DebtType.punctual)
              _puntualControls()
            else
              _recurrenteControls(),
          ],
        ),
      ),
    );
  }

  Widget _puntualControls() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Se creará un único vencimiento en la fecha elegida.',
            style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: InputDecorator(
                decoration:
                    const InputDecoration(labelText: 'Fecha de vencimiento'),
                child: InkWell(
                  onTap: _pickDueDate,
                  child: Text(
                      _dueDate == null ? 'Elegir fecha' : _fmtDate(_dueDate!)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _recurrenteControls() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: _freq,
          decoration: const InputDecoration(labelText: 'Frecuencia'),
          items: const [
            DropdownMenuItem(
                value: 'MONTHLY_BY_DOM', child: Text('Mensual (día del mes)')),
            DropdownMenuItem(
                value: 'WEEKLY_BY_DOW',
                child: Text('Semanal (día de la semana)')),
            DropdownMenuItem(
                value: 'YEARLY_BY_DOM', child: Text('Anual (día y mes)')),
            DropdownMenuItem(value: 'EVERY_N_DAYS', child: Text('Cada N días')),
          ],
          onChanged: (v) => setState(() => _freq = v!),
        ),
        const SizedBox(height: 8),
        if (_freq == 'MONTHLY_BY_DOM' || _freq == 'YEARLY_BY_DOM')
          TextFormField(
            initialValue: _diaMes.toString(),
            decoration: const InputDecoration(labelText: 'Día del mes (1-31)'),
            keyboardType: TextInputType.number,
            onChanged: (v) => _diaMes = int.tryParse(v) ?? _diaMes,
          ),
        if (_freq == 'WEEKLY_BY_DOW')
          DropdownButtonFormField<int>(
            value: _dow,
            decoration: const InputDecoration(labelText: 'Día de la semana'),
            items: const [
              DropdownMenuItem(value: 1, child: Text('Lunes')),
              DropdownMenuItem(value: 2, child: Text('Martes')),
              DropdownMenuItem(value: 3, child: Text('Miércoles')),
              DropdownMenuItem(value: 4, child: Text('Jueves')),
              DropdownMenuItem(value: 5, child: Text('Viernes')),
              DropdownMenuItem(value: 6, child: Text('Sábado')),
              DropdownMenuItem(value: 7, child: Text('Domingo')),
            ],
            onChanged: (v) => setState(() => _dow = v ?? _dow),
          ),
        if (_freq == 'EVERY_N_DAYS')
          TextFormField(
            initialValue: _everyNDays.toString(),
            decoration: const InputDecoration(labelText: 'Cada N días (>=1)'),
            keyboardType: TextInputType.number,
            onChanged: (v) => _everyNDays = int.tryParse(v) ?? _everyNDays,
          ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: InputDecorator(
                decoration: const InputDecoration(labelText: 'Fecha inicio'),
                child: InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _fechaInicio,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) setState(() => _fechaInicio = picked);
                  },
                  child: Text(_fmtDate(_fechaInicio)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InputDecorator(
                decoration:
                    const InputDecoration(labelText: 'Fecha fin (opcional)'),
                child: InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _fechaFin ?? _fechaInicio,
                      firstDate: _fechaInicio,
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) setState(() => _fechaFin = picked);
                  },
                  child: Text(_fechaFin == null
                      ? 'Sin fecha fin'
                      : _fmtDate(_fechaFin!)),
                ),
              ),
            ),
          ],
        ),
        TextFormField(
          initialValue: _totalCiclos?.toString() ?? '',
          decoration:
              const InputDecoration(labelText: 'Total de ciclos (opcional)'),
          keyboardType: TextInputType.number,
          onChanged: (v) =>
              _totalCiclos = (v.trim().isEmpty) ? null : int.tryParse(v),
        ),
        const SizedBox(height: 4),
        Text(
            'Mensual: si el día no existe (p. ej., 31 en febrero), usar último día del mes.',
            style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  // Sección C — Recordatorios
  Widget _sectionRecordatorios() {
    const defaults = [-7, -5, -3, -1, 0];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recordatorios (días antes):',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final d in defaults)
                  FilterChip(
                    selected: _offsets.contains(d),
                    label: Text(d.toString()),
                    onSelected: (_) => setState(() {
                      _offsets.contains(d)
                          ? _offsets.remove(d)
                          : _offsets.add(d);
                    }),
                  ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _customOffsetCtrl,
                    decoration: const InputDecoration(
                        hintText: 'Agregar personalizado (<=0)'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {
                    final v = int.tryParse(_customOffsetCtrl.text.trim());
                    if (v != null && v <= 0) {
                      setState(() => _offsets.add(v));
                      _customOffsetCtrl.clear();
                    }
                  },
                  child: const Text('Agregar'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _pickDueDate() async {
    final initial = _dueDate ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  String _fmtDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  // Eliminado: helper de color para categorías. No se usa color.

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;
    if (_type == DebtType.punctual && _dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una fecha de vencimiento')),
      );
      return;
    }

    final amount = double.parse(_amountCtrl.text.replaceAll(',', '.'));
    final basic = DebtBasicData(
      id: widget.templateId,
      nombre: _nameCtrl.text.trim(),
      monto: amount,
      categoria: null,
      categoryId: _categoryId,
      cardId: _cardId,
      paymentMethodId: _paymentMethodId,
      notas: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      hasInterest: _hasInterest,
      interestType: _hasInterest ? _interestType : null,
      interestRateMonthly: _hasInterest
          ? double.tryParse(_interestRateCtrl.text.replaceAll(',', '.'))
          : null,
      termMonths: _hasInterest && _interestType == 'FIXED_INSTALLMENTS'
          ? int.tryParse(_termMonthsCtrl.text.trim())
          : null,
      graceMonths: _hasInterest && _interestType == 'FIXED_INSTALLMENTS'
          ? int.tryParse(_graceMonthsCtrl.text.trim()) ?? 0
          : null,
      currentBalance: _hasInterest ? amount : null,
    );

    // Validaciones de interés
    if (_hasInterest) {
      final rate =
          double.tryParse(_interestRateCtrl.text.replaceAll(',', '.')) ?? 0;
      if (rate <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('La tasa mensual debe ser > 0')));
        return;
      }
      if (_interestType == 'FIXED_INSTALLMENTS') {
        final term = int.tryParse(_termMonthsCtrl.text.trim());
        if (term == null || term < 1) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Plazo inválido')));
          return;
        }
      }
    }

    RecurrenceData? rec;
    if (_type == DebtType.recurrent) {
      rec = RecurrenceData(
        tipo: _freq,
        diaMes: (_freq == 'MONTHLY_BY_DOM' || _freq == 'YEARLY_BY_DOM')
            ? _diaMes
            : null,
        dow: _freq == 'WEEKLY_BY_DOW' ? _dow : null,
        everyNDays: _freq == 'EVERY_N_DAYS' ? _everyNDays : null,
        fechaInicio: _fechaInicio,
        fechaFin: _fechaFin,
        totalCiclos: _totalCiclos,
      );
    }

    final controller = ref.read(saveDebtControllerProvider.notifier);
    final templateId = await controller.save(
      basic: basic,
      type: _type,
      punctualDueDate: _dueDate,
      recurrence: rec,
      offsets: _offsets.take(5).toList(),
    );

    if (!mounted) return;
    if (templateId != null) {
      // Invalidaciones por cambios que afectan KPIs/listas
      ref.invalidate(templatesProvider);
      ref.invalidate(upcomingOccurrencesWithDetailsProvider);
      ref.invalidate(monthSummaryProvider);
      ref.invalidate(monthCountsProvider);
      final monthStart = ref.read(op2.focusedMonthProvider);
      ref.invalidate(op2.monthKpisProvider(monthStart));
      ref.invalidate(dashboardStatsProvider);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Guardado')));
      context.go('/debts');
    } else {
      final err =
          ref.read(saveDebtControllerProvider).error ?? 'Error al guardar';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
    }
  }
}
