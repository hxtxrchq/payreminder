import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../logic/providers/template_providers.dart';
import '../../../app/formatters/money.dart';
import '../../../logic/providers/usecase_providers.dart';
import '../../../logic/providers/occurrence_providers.dart';
import '../../../logic/providers/summary_providers.dart';
import '../../../logic/providers/month_counts_provider.dart';
import '../../../logic/providers/repository_providers.dart';

class DebtsListScreen extends ConsumerWidget {
  const DebtsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templates = ref.watch(templatesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deudas'),
        leading: BackButton(
            onPressed: () =>
                context.canPop() ? context.pop() : context.go('/')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/template/new'),
        child: const Icon(Icons.add_alert),
      ),
      body: templates.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('No hay deudas.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final t = items[index];
              return ListTile(
                leading: const Icon(Icons.receipt_long),
                title: Text(t.nombre,
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text('Monto base: ${formatMoney(t.monto)}'),
                trailing: PopupMenuButton<String>(
                  onSelected: (v) async {
                    if (v == 'edit') {
                      context.go('/template/${t.id}');
                      return;
                    }
                    if (v == 'delete') {
                      // Check payments
                      int has;
                      try {
                        has = await ref
                            .read(paymentRepositoryProvider)
                            .hasPayments(t.id);
                      } catch (_) {
                        // Fallback: use use case helper
                        final del = ref.read(deleteDebtUseCaseProvider);
                        has = await del.hasPayments(t.id);
                      }
                      if (has > 0) {
                        final arch = await _confirmArchiveDialog(context);
                        if (arch) {
                          final res = await ref
                              .read(toggleArchiveProvider(t.id).future);
                          if (res) {
                            _invalidateAfterChange(ref);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Deuda archivada')),
                              );
                            }
                          }
                        }
                      } else {
                        final ok = await _confirmDeleteDialog(context);
                        if (ok) {
                          final deleted = await ref
                              .read(deleteDebtUseCaseProvider)
                              .execute(t.id);
                          if (deleted) {
                            _invalidateAfterChange(ref);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Deuda eliminada')),
                              );
                            }
                          }
                        }
                      }
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'edit', child: Text('Editar')),
                    PopupMenuItem(value: 'delete', child: Text('Eliminar')),
                  ],
                ),
                onTap: () => context.go('/template/${t.id}'),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

Future<bool> _confirmDeleteDialog(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Eliminar deuda'),
          content: const Text(
              'Esta acción eliminará la plantilla y sus ocurrencias futuras no pagadas. ¿Deseas continuar?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Eliminar'),
            ),
          ],
        ),
      ) ??
      false;
}

Future<bool> _confirmArchiveDialog(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Archivar deuda'),
          content: const Text(
              'Para conservar tu historial, solo puedes archivar esta deuda.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Archivar'),
            ),
          ],
        ),
      ) ??
      false;
}

void _invalidateAfterChange(WidgetRef ref) {
  ref.invalidate(templatesProvider);
  ref.invalidate(activeTemplatesProvider);
  ref.invalidate(upcomingOccurrencesWithDetailsProvider);
  ref.invalidate(thisMonthOccurrencesProvider);
  // occurrencesByDateProvider is family; UI should invalidate when needed
  ref.invalidate(monthSummaryProvider);
  ref.invalidate(dashboardStatsProvider);
  ref.invalidate(monthCountsProvider);
  final monthStart = ref.read(focusedMonthProvider);
  ref.invalidate(monthKpisProvider(monthStart));
}
