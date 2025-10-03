import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../logic/providers/repository_providers.dart';
import '../../../logic/providers/payment_methods_providers.dart';

class PaymentMethodsScreen extends ConsumerWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(paymentMethodRepositoryProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Métodos de pago'),
        leading: BackButton(
            onPressed: () =>
                context.canPop() ? context.pop() : context.go('/settings')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _showForm(context, ref, repo);
          // Refrescar listeners en otras pantallas (por ejemplo, formulario)
          ref.invalidate(paymentMethodsProvider);
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: repo.watchAll(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data!;
          if (items.isEmpty) {
            return const Center(child: Text('No hay métodos registrados'));
          }
          final grouped = <String, List<dynamic>>{};
          for (final m in items) {
            (grouped[m.type] ??= []).add(m);
          }
          return ListView(
            children: grouped.entries.map((e) {
              return _Group(
                title: _typeLabel(e.key),
                children: e.value.map((m) => _Item(method: m)).toList(),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  String _typeLabel(String type) {
    switch (type) {
      case 'CASH':
        return 'Efectivo';
      case 'YAPE':
        return 'Yape';
      case 'CARD':
        return 'Tarjetas';
      case 'PAYPAL':
        return 'PayPal';
      case 'BANK_TRANSFER':
        return 'Transferencia';
      default:
        return 'Otros';
    }
  }
}

class _Group extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Group({required this.title, required this.children});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _Item extends ConsumerWidget {
  final dynamic method; // PaymentMethod
  const _Item({required this.method});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(paymentMethodRepositoryProvider);
    final subtitle = method.type == 'CARD' && (method.last4 ?? '').isNotEmpty
        ? '****${method.last4}${method.issuer != null ? ' · ${method.issuer}' : ''}'
        : method.issuer ?? '';
    return ListTile(
      leading: Icon(method.isDefault ? Icons.star : Icons.payment),
      title: Text(method.alias),
      subtitle: subtitle.isEmpty ? null : Text(subtitle),
      trailing: PopupMenuButton<String>(
        onSelected: (v) async {
          if (v == 'default') {
            try {
              await repo.setDefault(method.id);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Predeterminado actualizado')),
              );
              ref.invalidate(paymentMethodsProvider);
            } catch (e) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: $e')),
              );
            }
          }
          if (v == 'edit') {
            await _showForm(context, ref, repo, method: method);
            ref.invalidate(paymentMethodsProvider);
          }
          if (v == 'delete') {
            try {
              await repo.delete(method.id);
              ref.invalidate(paymentMethodsProvider);
            } catch (e) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error eliminando: $e')),
              );
            }
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem(value: 'default', child: Text('Predeterminar')),
          const PopupMenuItem(value: 'edit', child: Text('Editar')),
          const PopupMenuItem(value: 'delete', child: Text('Eliminar')),
        ],
      ),
    );
  }
}

Future<void> _showForm(BuildContext context, WidgetRef ref, dynamic repo,
    {dynamic method}) async {
  final formKey = GlobalKey<FormState>();
  String type = method?.type ?? 'CASH';
  final aliasCtrl = TextEditingController(text: method?.alias ?? '');
  final issuerCtrl = TextEditingController(text: method?.issuer ?? '');
  final last4Ctrl = TextEditingController(text: method?.last4 ?? '');
  await showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(method == null ? 'Nuevo método' : 'Editar método'),
      content: Form(
        key: formKey,
        child: SizedBox(
          width: 320,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: type,
                items: const [
                  DropdownMenuItem(value: 'CASH', child: Text('Efectivo')),
                  DropdownMenuItem(value: 'YAPE', child: Text('Yape')),
                  DropdownMenuItem(
                      value: 'BANK_TRANSFER', child: Text('Transferencia')),
                  DropdownMenuItem(value: 'PAYPAL', child: Text('PayPal')),
                  DropdownMenuItem(value: 'CARD', child: Text('Tarjeta')),
                  DropdownMenuItem(value: 'OTHER', child: Text('Otros')),
                ],
                onChanged: (v) => type = v ?? type,
                decoration: const InputDecoration(labelText: 'Tipo'),
              ),
              TextFormField(
                controller: aliasCtrl,
                decoration: const InputDecoration(labelText: 'Alias'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Requerido' : null,
              ),
              if (type == 'CARD') ...[
                TextFormField(
                  controller: issuerCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Banco/Marca (opcional)'),
                ),
                TextFormField(
                  controller: last4Ctrl,
                  decoration:
                      const InputDecoration(labelText: 'Últimos 4 (opcional)'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
        FilledButton(
          onPressed: () async {
            if (!formKey.currentState!.validate()) return;

            // Validaciones adicionales
            if (type == 'CARD' && last4Ctrl.text.trim().isNotEmpty) {
              final last4 = last4Ctrl.text.trim();
              final isValid = RegExp(r'^\d{4}\$').hasMatch(last4);
              if (!isValid) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Últimos 4 inválidos')),
                );
                return;
              }
            }
            if (method == null) {
              try {
                await repo.create(
                  id: 'pm_${DateTime.now().millisecondsSinceEpoch}',
                  type: type,
                  alias: aliasCtrl.text.trim(),
                  issuer: issuerCtrl.text.trim().isEmpty
                      ? null
                      : issuerCtrl.text.trim(),
                  last4: last4Ctrl.text.trim().isEmpty
                      ? null
                      : last4Ctrl.text.trim(),
                );
                ref.invalidate(paymentMethodsProvider);
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error creando: $e')),
                );
                return;
              }
            } else {
              try {
                await repo.update(
                  id: method.id,
                  type: type,
                  alias: aliasCtrl.text.trim(),
                  issuer: issuerCtrl.text.trim().isEmpty
                      ? null
                      : issuerCtrl.text.trim(),
                  last4: last4Ctrl.text.trim().isEmpty
                      ? null
                      : last4Ctrl.text.trim(),
                );
                ref.invalidate(paymentMethodsProvider);
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error guardando: $e')),
                );
                return;
              }
            }
            if (!context.mounted) return;
            Navigator.pop(ctx);
          },
          child: const Text('Guardar'),
        ),
      ],
    ),
  );
}
