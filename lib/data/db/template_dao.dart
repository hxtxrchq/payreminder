import 'package:drift/drift.dart';
import '../db/app_database.dart';

part 'template_dao.g.dart';

@DriftAccessor(tables: [DebtTemplates, Cards])
class TemplateDao extends DatabaseAccessor<AppDatabase> with _$TemplateDaoMixin {
  TemplateDao(AppDatabase db) : super(db);

  // CRUD Operations
  Future<String> insertTemplate(DebtTemplatesCompanion template) async {
    await into(debtTemplates).insert(template);
    return template.id.value;
  }

  Future<DebtTemplate?> getTemplateById(String id) async {
    return await (select(debtTemplates)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List<DebtTemplate>> getAllTemplates() async {
    return await (select(debtTemplates)
      ..where((t) => t.isArchived.equals(false))
      ..orderBy([(t) => OrderingTerm.asc(t.nombre)])).get();
  }

  Future<List<DebtTemplate>> getArchivedTemplates() async {
    return await (select(debtTemplates)
      ..where((t) => t.isArchived.equals(true))
      ..orderBy([(t) => OrderingTerm.asc(t.nombre)])).get();
  }

  Future<bool> updateTemplate(DebtTemplatesCompanion template) async {
    final result = await (update(debtTemplates)..where((t) => t.id.equals(template.id.value))).write(template);
    return result > 0;
  }

  Future<bool> deleteTemplate(String id) async {
    final result = await (delete(debtTemplates)..where((t) => t.id.equals(id))).go();
    return result > 0;
  }

  Future<bool> archiveTemplate(String id) async {
    final result = await (update(debtTemplates)..where((t) => t.id.equals(id)))
        .write(DebtTemplatesCompanion(
          isArchived: const Value(true),
          updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
        ));
    return result > 0;
  }

  Future<bool> unarchiveTemplate(String id) async {
    final result = await (update(debtTemplates)..where((t) => t.id.equals(id)))
        .write(DebtTemplatesCompanion(
          isArchived: const Value(false),
          updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
        ));
    return result > 0;
  }

  // Search and filter operations
  Future<List<DebtTemplate>> searchTemplatesByName(String query) async {
    return await (select(debtTemplates)
      ..where((t) => t.nombre.contains(query) & t.isArchived.equals(false))
      ..orderBy([(t) => OrderingTerm.asc(t.nombre)])).get();
  }

  Future<List<DebtTemplate>> getTemplatesByCategory(String category) async {
    return await (select(debtTemplates)
      ..where((t) => t.categoria.equals(category) & t.isArchived.equals(false))
      ..orderBy([(t) => OrderingTerm.asc(t.nombre)])).get();
  }

  Future<List<DebtTemplate>> getTemplatesByCard(String cardId) async {
    return await (select(debtTemplates)
      ..where((t) => t.cardId.equals(cardId) & t.isArchived.equals(false))
      ..orderBy([(t) => OrderingTerm.asc(t.nombre)])).get();
  }

  Future<List<DebtTemplate>> getTemplatesByAmountRange(double minAmount, double maxAmount) async {
    return await (select(debtTemplates)
      ..where((t) => t.monto.isBetweenValues(minAmount, maxAmount) & t.isArchived.equals(false))
      ..orderBy([(t) => OrderingTerm.asc(t.monto)])).get();
  }

  // Join operations
  Future<List<TemplateWithCard>> getTemplatesWithCards() async {
    final query = select(debtTemplates).join([
      leftOuterJoin(cards, cards.id.equalsExp(debtTemplates.cardId))
    ])..where(debtTemplates.isArchived.equals(false))
     ..orderBy([OrderingTerm.asc(debtTemplates.nombre)]);
    
    final result = await query.get();
    return result.map((row) => TemplateWithCard(
      template: row.readTable(debtTemplates),
      card: row.readTableOrNull(cards),
    )).toList();
  }

  Future<TemplateWithCard?> getTemplateWithCardById(String id) async {
    final query = select(debtTemplates).join([
      leftOuterJoin(cards, cards.id.equalsExp(debtTemplates.cardId))
    ])..where(debtTemplates.id.equals(id));
    
    final result = await query.getSingleOrNull();
    if (result == null) return null;
    
    return TemplateWithCard(
      template: result.readTable(debtTemplates),
      card: result.readTableOrNull(cards),
    );
  }

  // Statistics
  Future<int> getTemplateCount() async {
    final countExp = debtTemplates.id.count();
    final query = selectOnly(debtTemplates)
      ..addColumns([countExp])
      ..where(debtTemplates.isArchived.equals(false));
    final result = await query.getSingle();
    return result.read(countExp) ?? 0;
  }

  Future<double> getTotalAmount() async {
    final sumExp = debtTemplates.monto.sum();
    final query = selectOnly(debtTemplates)
      ..addColumns([sumExp])
      ..where(debtTemplates.isArchived.equals(false));
    final result = await query.getSingle();
    return result.read(sumExp) ?? 0.0;
  }

  Future<List<String>> getUniqueCategories() async {
    final query = selectOnly(debtTemplates)
      ..addColumns([debtTemplates.categoria])
      ..where(debtTemplates.categoria.isNotNull() & debtTemplates.isArchived.equals(false))
      ..groupBy([debtTemplates.categoria])
      ..orderBy([OrderingTerm.asc(debtTemplates.categoria)]);
    
    final result = await query.get();
    return result.map((row) => row.read(debtTemplates.categoria)!).toList();
  }

  // Watch for real-time updates
  Stream<List<DebtTemplate>> watchAllTemplates() {
    return (select(debtTemplates)
      ..where((t) => t.isArchived.equals(false))
      ..orderBy([(t) => OrderingTerm.asc(t.nombre)])).watch();
  }

  Stream<DebtTemplate?> watchTemplate(String id) {
    return (select(debtTemplates)..where((t) => t.id.equals(id))).watchSingleOrNull();
  }

  Stream<List<TemplateWithCard>> watchTemplatesWithCards() {
    final query = select(debtTemplates).join([
      leftOuterJoin(cards, cards.id.equalsExp(debtTemplates.cardId))
    ])..where(debtTemplates.isArchived.equals(false))
     ..orderBy([OrderingTerm.asc(debtTemplates.nombre)]);
    
    return query.watch().map((rows) => rows.map((row) => TemplateWithCard(
      template: row.readTable(debtTemplates),
      card: row.readTableOrNull(cards),
    )).toList());
  }
}

// Helper class for joined data
class TemplateWithCard {
  final DebtTemplate template;
  final Card? card;

  TemplateWithCard({required this.template, this.card});
}