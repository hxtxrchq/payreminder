import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../logic/providers/category_providers.dart';
import '../../../data/db/app_database.dart';
import '../../../logic/providers/occurrence_providers.dart';
import '../../../logic/providers/summary_providers.dart';
import '../../../logic/providers/month_counts_provider.dart';
import '../../../logic/providers/template_providers.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cats = ref.watch(categoriesStreamProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías'),
        leading: BackButton(
            onPressed: () =>
                context.canPop() ? context.pop() : context.go('/')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEditDialog(context, ref),
        child: const Icon(Icons.add),
      ),
      body: cats.when(
        data: (list) => ListView.separated(
          itemCount: list.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, i) => _CategoryTile(cat: list[i], ref: ref),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context, WidgetRef ref,
      {Category? cat}) async {
    final nameCtrl = TextEditingController(text: cat?.name ?? '');
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(cat == null ? 'Nueva categoría' : 'Editar categoría'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          FilledButton(
            onPressed: () async {
              final name = nameCtrl.text.trim();
              if (name.isEmpty) return;
              bool ok = false;
              if (cat == null) {
                ok = await ref
                        .read(createCategoryProvider((name: name)).future) ==
                    true;
              } else {
                ok = await ref.read(
                        updateCategoryProvider((id: cat.id, name: name))
                            .future) ==
                    true;
              }
              if (!ok) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Ya existe una categoría con ese nombre.')));
                return;
              }
              // Invalidaciones por cambios
              ref.invalidate(upcomingOccurrencesWithDetailsProvider);
              ref.invalidate(monthSummaryProvider);
              ref.invalidate(monthCountsProvider);
              final monthStart = ref.read(focusedMonthProvider);
              ref.invalidate(monthKpisProvider(monthStart));
              ref.invalidate(dashboardStatsProvider);
              ref.invalidate(templatesProvider);
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          )
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final Category cat;
  final WidgetRef ref;
  const _CategoryTile({required this.cat, required this.ref});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.label_outline)),
      title: Text(cat.name),
      subtitle: Text(cat.id),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _showEdit(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Eliminar categoría'),
                  content: Text('¿Eliminar "${cat.name}"?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancelar')),
                    FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Eliminar')),
                  ],
                ),
              );
              if (ok == true) {
                final deleted =
                    await ref.read(deleteCategoryProvider(cat.id).future);
                if (deleted) {
                  ref.invalidate(upcomingOccurrencesWithDetailsProvider);
                  ref.invalidate(monthSummaryProvider);
                  ref.invalidate(monthCountsProvider);
                  final monthStart = ref.read(focusedMonthProvider);
                  ref.invalidate(monthKpisProvider(monthStart));
                  ref.invalidate(dashboardStatsProvider);
                  ref.invalidate(templatesProvider);
                }
              }
            },
          )
        ],
      ),
    );
  }

  void _showEdit(BuildContext context) {
    final nameCtrl = TextEditingController(text: cat.name);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar categoría'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          FilledButton(
            onPressed: () async {
              final name = nameCtrl.text.trim();
              if (name.isEmpty) return;
              final ok = await ref.read(
                      updateCategoryProvider((id: cat.id, name: name))
                          .future) ==
                  true;
              if (!ok) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Ya existe una categoría con ese nombre.')));
                return;
              }
              ref.invalidate(upcomingOccurrencesWithDetailsProvider);
              ref.invalidate(monthSummaryProvider);
              ref.invalidate(monthCountsProvider);
              final monthStart = ref.read(focusedMonthProvider);
              ref.invalidate(monthKpisProvider(monthStart));
              ref.invalidate(dashboardStatsProvider);
              ref.invalidate(templatesProvider);
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          )
        ],
      ),
    );
  }
}
