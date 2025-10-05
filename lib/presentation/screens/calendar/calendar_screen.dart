import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../logic/providers/occurrence_providers.dart';
import '../../../logic/providers/usecase_providers.dart';
import '../../../logic/providers/summary_providers.dart';
import '../../../app/formatters/money.dart';
import '../../../data/db/occurrence_dao.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;
  late final ValueNotifier<List<OccurrenceWithDetails>> _selectedEvents;

  @override
  void initState() {
    super.initState();
    selectedDay = DateTime.now();
    _selectedEvents = ValueNotifier(_getEventsForDay(selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<OccurrenceWithDetails> _getEventsForDay(DateTime day) {
    // Esta función será llamada con datos reales desde el provider
    return [];
  }

  List<OccurrenceWithDetails> _getEventsForDayWithData(
      DateTime day, List<OccurrenceWithDetails> allOccurrences) {
    return allOccurrences.where((occurrence) {
      final occurrenceDate =
          DateTime.fromMillisecondsSinceEpoch(occurrence.occurrence.fechaDue);
      return isSameDay(day, occurrenceDate);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final monthStart = ref.watch(focusedMonthProvider);
    final thisMonthOccurrences =
        ref.watch(occurrencesForMonthProvider(monthStart));
    final selectedDayOccurrences = selectedDay != null
        ? ref.watch(occurrencesByDateProvider(selectedDay!))
        : const AsyncValue.data(<OccurrenceWithDetails>[]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario de Pagos'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        leading: BackButton(
            onPressed: () =>
                context.canPop() ? context.pop() : context.go('/')),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: () {
              setState(() {
                focusedDay = DateTime.now();
                selectedDay = DateTime.now();
              });
            },
            tooltip: 'Ir a hoy',
          ),
        ],
      ),
      body: Column(
        children: [
          // Calendario
          Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: thisMonthOccurrences.when(
                data: (occurrences) => TableCalendar<OccurrenceWithDetails>(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: focusedDay,
                  selectedDayPredicate: (day) => isSameDay(selectedDay, day),
                  eventLoader: (day) =>
                      _getEventsForDayWithData(day, occurrences),
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(this.selectedDay, selectedDay)) {
                      setState(() {
                        this.selectedDay = selectedDay;
                        this.focusedDay = focusedDay;
                      });
                    }
                  },
                  onPageChanged: (newFocused) {
                    setState(() {
                      focusedDay = newFocused;
                    });
                    // Update focused month provider for global consumers
                    final monthKey =
                        DateTime(newFocused.year, newFocused.month, 1);
                    ref.read(focusedMonthProvider.notifier).state = monthKey;
                  },
                  calendarFormat: CalendarFormat.month,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: false,
                    markerDecoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                    markerSize: 6,
                    markersMaxCount: 3,
                  ),
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, day, events) {
                      if (events.isEmpty) return null;
                      // Priority: RED (OVERDUE/DUE_TODAY) > YELLOW (NEAR) > GREEN (PAID) > BLACK (PENDING)
                      bool red = false, yellow = false, green = false;
                      for (final e in events) {
                        final st = e.occurrence.estado;
                        if (st == 'OVERDUE' || st == 'DUE_TODAY')
                          red = true;
                        else if (st == 'NEAR')
                          yellow = true;
                        else if (st == 'PAID') green = true;
                      }
                      final color = red
                          ? const Color(0xFFE74C3C)
                          : yellow
                              ? const Color(0xFFF4D03F)
                              : green
                                  ? const Color(0xFF27AE60)
                                  : const Color(0xFF111111);
                      return Positioned(
                        bottom: 4,
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                loading: () => Container(
                  height: 300,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                error: (error, stack) => Container(
                  height: 300,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 48),
                        const SizedBox(height: 8),
                        Text('Error cargando calendario: $error'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Lista de eventos del día seleccionado
          Expanded(
            child: Card(
              margin: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.event,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          selectedDay != null
                              ? 'Pagos del ${_formatDate(selectedDay!)}'
                              : 'Selecciona una fecha',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: selectedDayOccurrences.when(
                      data: (occurrences) {
                        if (occurrences.isEmpty) {
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.event_available,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No hay pagos programados para este día',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.separated(
                          padding: const EdgeInsets.all(8),
                          itemCount: occurrences.length,
                          separatorBuilder: (context, index) =>
                              const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final occurrence = occurrences[index];
                            return _OccurrenceListItem(
                              occurrence: occurrence,
                              onMarkPaid: () => _markAsPaid(occurrence),
                              onEdit: () => _editOccurrence(occurrence),
                            );
                          },
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, stack) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error,
                                color: Colors.red, size: 48),
                            const SizedBox(height: 8),
                            Text('Error: $error'),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () =>
                                  ref.invalidate(occurrencesByDateProvider),
                              child: const Text('Reintentar'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<OccurrenceWithDetails> _getEventsForDayWithOccurrences(
      DateTime day, List<OccurrenceWithDetails> allOccurrences) {
    return allOccurrences.where((occurrence) {
      final occurrenceDate =
          DateTime.fromMillisecondsSinceEpoch(occurrence.occurrence.fechaDue);
      return isSameDay(day, occurrenceDate);
    }).toList();
  }

  String _formatDate(DateTime date) {
    const months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];
    return '${date.day} de ${months[date.month - 1]}, ${date.year}';
  }

  Future<void> _markAsPaid(OccurrenceWithDetails occ) async {
    final useCase = ref.read(markPaidUseCaseProvider);
    final result = await useCase.execute(
      occurrenceId: occ.occurrence.id,
      amountPaid: occ.occurrence.monto,
      paymentDate: DateTime.now(),
    );
    if (!mounted) return;
    if (result.isSuccess) {
      // Cancelar recordatorios restantes para esta ocurrencia si usas offsets
      // Aquí no tenemos offsets, pero si los tuvieras: NotificationService.instance.cancelOccurrenceReminders(...)
      // Refrescar calendario y módulos relacionados
      ref.invalidate(thisMonthOccurrencesProvider);
      if (selectedDay != null) {
        ref.invalidate(occurrencesByDateProvider(selectedDay!));
      }
      ref.invalidate(pendingOccurrencesProvider);
      // Nuevos reactivos: resumen del mes y próximos pagos
      ref.invalidate(monthSummaryProvider);
      final monthStart = ref.read(focusedMonthProvider);
      ref.invalidate(monthKpisProvider(monthStart));
      ref.invalidate(upcomingOccurrencesWithDetailsProvider);
      ref.invalidate(dashboardStatsProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Marcado como pagado')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.error ?? 'Error al marcar pagado')),
      );
    }
  }

  void _editOccurrence(OccurrenceWithDetails occ) {
    context.push('/template/${occ.template.id}');
  }
}

class _OccurrenceListItem extends StatelessWidget {
  final OccurrenceWithDetails occurrence;
  final VoidCallback onMarkPaid;
  final VoidCallback onEdit;

  const _OccurrenceListItem({
    required this.occurrence,
    required this.onMarkPaid,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final dueDate =
        DateTime.fromMillisecondsSinceEpoch(occurrence.occurrence.fechaDue);
    Color stateColor(String s) {
      switch (s) {
        case 'OVERDUE':
        case 'DUE_TODAY':
          return const Color(0xFFE74C3C);
        case 'NEAR':
          return const Color(0xFFF4D03F);
        case 'PAID':
          return const Color(0xFF27AE60);
        default:
          return const Color(0xFF111111); // PENDING
      }
    }

    final estado = occurrence.occurrence.estado;
    Color statusColor = stateColor(estado);
    IconData statusIcon = estado == 'PAID'
        ? Icons.check_circle
        : (estado == 'OVERDUE' || estado == 'DUE_TODAY')
            ? Icons.warning
            : Icons.pending;
    String statusText = () {
      switch (estado) {
        case 'PAID':
          return 'Pagado';
        case 'OVERDUE':
          return 'Vencido';
        case 'DUE_TODAY':
          return 'Vence hoy';
        case 'NEAR':
          return 'Próximo';
        default:
          return 'Pendiente';
      }
    }();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.15),
          child: Icon(statusIcon, color: statusColor, size: 18),
        ),
        title: Text(
          occurrence.template.nombre,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(statusText, style: TextStyle(color: statusColor)),
            if (occurrence.template.categoria != null)
              Text('Categoría: ${occurrence.template.categoria}'),
            if (occurrence.card?.nombre != null)
              Text('Tarjeta: ${occurrence.card!.nombre}'),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              formatMoney(occurrence.occurrence.monto),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
            ),
            Text(
              '${dueDate.hour.toString().padLeft(2, '0')}:${dueDate.minute.toString().padLeft(2, '0')}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        onTap: () {
          // Mostrar opciones
          showModalBottomSheet(
            context: context,
            builder: (context) => _OccurrenceActionSheet(
              occurrence: occurrence,
              onMarkPaid: onMarkPaid,
              onEdit: onEdit,
            ),
          );
        },
      ),
    );
  }
}

class _OccurrenceActionSheet extends StatelessWidget {
  final OccurrenceWithDetails occurrence;
  final VoidCallback onMarkPaid;
  final VoidCallback onEdit;

  const _OccurrenceActionSheet({
    required this.occurrence,
    required this.onMarkPaid,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final estado = occurrence.occurrence.estado;
    final isPaid = estado == 'PAID';
    const pagables = {'PENDING', 'NEAR', 'DUE_TODAY', 'OVERDUE'};

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.receipt_long,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  occurrence.template.nombre,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Monto: ${formatMoney(occurrence.occurrence.monto)}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            'Estado: ${occurrence.occurrence.estado}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              if (!isPaid && pagables.contains(estado)) ...[
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      onMarkPaid();
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('Marcar como Pagado'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    onEdit();
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Editar'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ),
        ],
      ),
    );
  }
}
