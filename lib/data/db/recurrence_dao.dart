import 'package:drift/drift.dart';
import '../db/app_database.dart';

part 'recurrence_dao.g.dart';

@DriftAccessor(tables: [Recurrences, DebtTemplates])
class RecurrenceDao extends DatabaseAccessor<AppDatabase> with _$RecurrenceDaoMixin {
  RecurrenceDao(AppDatabase db) : super(db);

  // CRUD Operations
  Future<String> insertRecurrence(RecurrencesCompanion recurrence) async {
    await into(recurrences).insert(recurrence);
    return recurrence.id.value;
  }

  Future<Recurrence?> getRecurrenceById(String id) async {
    return await (select(recurrences)..where((r) => r.id.equals(id))).getSingleOrNull();
  }

  Future<List<Recurrence>> getAllRecurrences() async {
    return await (select(recurrences)..orderBy([(r) => OrderingTerm.asc(r.fechaInicio)])).get();
  }

  Future<bool> updateRecurrence(RecurrencesCompanion recurrence) async {
    final result = await (update(recurrences)..where((r) => r.id.equals(recurrence.id.value))).write(recurrence);
    return result > 0;
  }

  Future<bool> deleteRecurrence(String id) async {
    final result = await (delete(recurrences)..where((r) => r.id.equals(id))).go();
    return result > 0;
  }

  // Template-specific operations
  Future<List<Recurrence>> getRecurrencesByTemplate(String templateId) async {
    return await (select(recurrences)
      ..where((r) => r.templateId.equals(templateId))
      ..orderBy([(r) => OrderingTerm.asc(r.fechaInicio)])).get();
  }

  Future<Recurrence?> getActiveRecurrenceForTemplate(String templateId) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    return await (select(recurrences)
      ..where((r) => 
        r.templateId.equals(templateId) & 
        r.fechaInicio.isSmallerOrEqualValue(now) &
        (r.fechaFin.isNull() | r.fechaFin.isBiggerOrEqualValue(now)))
      ..orderBy([(r) => OrderingTerm.desc(r.fechaInicio)])
      ..limit(1)).getSingleOrNull();
  }

  Future<bool> deleteRecurrencesByTemplate(String templateId) async {
    final result = await (delete(recurrences)..where((r) => r.templateId.equals(templateId))).go();
    return result > 0;
  }

  // Filter by recurrence type
  Future<List<Recurrence>> getRecurrencesByType(String tipo) async {
    return await (select(recurrences)
      ..where((r) => r.tipo.equals(tipo))
      ..orderBy([(r) => OrderingTerm.asc(r.fechaInicio)])).get();
  }

  // Active recurrences (not expired)
  Future<List<Recurrence>> getActiveRecurrences([int? asOfTimestamp]) async {
    final timestamp = asOfTimestamp ?? DateTime.now().millisecondsSinceEpoch;
    return await (select(recurrences)
      ..where((r) => 
        r.fechaInicio.isSmallerOrEqualValue(timestamp) &
        (r.fechaFin.isNull() | r.fechaFin.isBiggerOrEqualValue(timestamp)))
      ..orderBy([(r) => OrderingTerm.asc(r.fechaInicio)])).get();
  }

  // Expired recurrences
  Future<List<Recurrence>> getExpiredRecurrences([int? asOfTimestamp]) async {
    final timestamp = asOfTimestamp ?? DateTime.now().millisecondsSinceEpoch;
    return await (select(recurrences)
      ..where((r) => r.fechaFin.isNotNull() & r.fechaFin.isSmallerThanValue(timestamp))
      ..orderBy([(r) => OrderingTerm.desc(r.fechaFin)])).get();
  }

  // Recurrences ending soon
  Future<List<Recurrence>> getRecurrencesEndingSoon(int daysAhead) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final futureDate = DateTime.now().add(Duration(days: daysAhead)).millisecondsSinceEpoch;
    
    return await (select(recurrences)
      ..where((r) => 
        r.fechaFin.isNotNull() & 
        r.fechaFin.isBiggerOrEqualValue(now) &
        r.fechaFin.isSmallerOrEqualValue(futureDate))
      ..orderBy([(r) => OrderingTerm.asc(r.fechaFin)])).get();
  }

  // Update remaining cycles
  Future<bool> updateRemainingCycles(String id, int remainingCycles) async {
    final result = await (update(recurrences)..where((r) => r.id.equals(id)))
        .write(RecurrencesCompanion(
          ciclosRestantes: Value(remainingCycles),
          updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
        ));
    return result > 0;
  }

  Future<bool> decrementRemainingCycles(String id) async {
    final recurrence = await getRecurrenceById(id);
    if (recurrence?.ciclosRestantes != null && recurrence!.ciclosRestantes! > 0) {
      return await updateRemainingCycles(id, recurrence.ciclosRestantes! - 1);
    }
    return false;
  }

  // Join with templates
  Future<List<RecurrenceWithTemplate>> getRecurrencesWithTemplates() async {
    final query = select(recurrences).join([
      innerJoin(debtTemplates, debtTemplates.id.equalsExp(recurrences.templateId))
    ])..orderBy([OrderingTerm.asc(recurrences.fechaInicio)]);
    
    final result = await query.get();
    return result.map((row) => RecurrenceWithTemplate(
      recurrence: row.readTable(recurrences),
      template: row.readTable(debtTemplates),
    )).toList();
  }

  Future<RecurrenceWithTemplate?> getRecurrenceWithTemplateById(String id) async {
    final query = select(recurrences).join([
      innerJoin(debtTemplates, debtTemplates.id.equalsExp(recurrences.templateId))
    ])..where(recurrences.id.equals(id));
    
    final result = await query.getSingleOrNull();
    if (result == null) return null;
    
    return RecurrenceWithTemplate(
      recurrence: result.readTable(recurrences),
      template: result.readTable(debtTemplates),
    );
  }

  // Statistics
  Future<int> getRecurrenceCount() async {
    final countExp = recurrences.id.count();
    final query = selectOnly(recurrences)..addColumns([countExp]);
    final result = await query.getSingle();
    return result.read(countExp) ?? 0;
  }

  Future<int> getActiveRecurrenceCount() async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final countExp = recurrences.id.count();
    final query = selectOnly(recurrences)
      ..addColumns([countExp])
      ..where(
        recurrences.fechaInicio.isSmallerOrEqualValue(timestamp) &
        (recurrences.fechaFin.isNull() | recurrences.fechaFin.isBiggerOrEqualValue(timestamp))
      );
    final result = await query.getSingle();
    return result.read(countExp) ?? 0;
  }

  // Watch for real-time updates
  Stream<List<Recurrence>> watchAllRecurrences() {
    return (select(recurrences)..orderBy([(r) => OrderingTerm.asc(r.fechaInicio)])).watch();
  }

  Stream<Recurrence?> watchRecurrence(String id) {
    return (select(recurrences)..where((r) => r.id.equals(id))).watchSingleOrNull();
  }

  Stream<List<Recurrence>> watchRecurrencesByTemplate(String templateId) {
    return (select(recurrences)
      ..where((r) => r.templateId.equals(templateId))
      ..orderBy([(r) => OrderingTerm.asc(r.fechaInicio)])).watch();
  }

  Stream<List<RecurrenceWithTemplate>> watchRecurrencesWithTemplates() {
    final query = select(recurrences).join([
      innerJoin(debtTemplates, debtTemplates.id.equalsExp(recurrences.templateId))
    ])..orderBy([OrderingTerm.asc(recurrences.fechaInicio)]);
    
    return query.watch().map((rows) => rows.map((row) => RecurrenceWithTemplate(
      recurrence: row.readTable(recurrences),
      template: row.readTable(debtTemplates),
    )).toList());
  }
}

// Helper class for joined data
class RecurrenceWithTemplate {
  final Recurrence recurrence;
  final DebtTemplate template;

  RecurrenceWithTemplate({required this.recurrence, required this.template});
}