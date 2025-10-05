import 'package:drift/drift.dart';
import '../db/app_database.dart';

part 'reminder_rule_dao.g.dart';

@DriftAccessor(tables: [ReminderRules, DebtTemplates])
class ReminderRuleDao extends DatabaseAccessor<AppDatabase> with _$ReminderRuleDaoMixin {
  ReminderRuleDao(AppDatabase db) : super(db);

  // CRUD Operations
  Future<String> insertReminderRule(ReminderRulesCompanion rule) async {
    await into(reminderRules).insert(rule);
    return rule.id.value;
  }

  Future<ReminderRule?> getReminderRuleById(String id) async {
    return await (select(reminderRules)..where((r) => r.id.equals(id))).getSingleOrNull();
  }

  Future<List<ReminderRule>> getAllReminderRules() async {
    return await (select(reminderRules)..orderBy([(r) => OrderingTerm.asc(r.offsetDays)])).get();
  }

  Future<bool> updateReminderRule(ReminderRulesCompanion rule) async {
    final result = await (update(reminderRules)..where((r) => r.id.equals(rule.id.value))).write(rule);
    return result > 0;
  }

  Future<bool> deleteReminderRule(String id) async {
    final result = await (delete(reminderRules)..where((r) => r.id.equals(id))).go();
    return result > 0;
  }

  // Template-specific operations
  Future<List<ReminderRule>> getReminderRulesByTemplate(String templateId) async {
    return await (select(reminderRules)
      ..where((r) => r.templateId.equals(templateId))
      ..orderBy([(r) => OrderingTerm.asc(r.offsetDays)])).get();
  }

  Future<bool> deleteReminderRulesByTemplate(String templateId) async {
    final result = await (delete(reminderRules)..where((r) => r.templateId.equals(templateId))).go();
    return result > 0;
  }

  // Filter by offset days
  Future<List<ReminderRule>> getReminderRulesByOffset(int offsetDays) async {
    return await (select(reminderRules)
      ..where((r) => r.offsetDays.equals(offsetDays))
      ..orderBy([(r) => OrderingTerm.asc(r.templateId)])).get();
  }

  Future<List<ReminderRule>> getReminderRulesInRange(int minOffset, int maxOffset) async {
    return await (select(reminderRules)
      ..where((r) => r.offsetDays.isBetweenValues(minOffset, maxOffset))
      ..orderBy([(r) => OrderingTerm.asc(r.offsetDays)])).get();
  }

  // Before due date (negative offsets)
  Future<List<ReminderRule>> getBeforeDueReminderRules() async {
    return await (select(reminderRules)
      ..where((r) => r.offsetDays.isSmallerThanValue(0))
      ..orderBy([(r) => OrderingTerm.asc(r.offsetDays)])).get();
  }

  // On due date (zero offset)
  Future<List<ReminderRule>> getOnDueDateReminderRules() async {
    return await getReminderRulesByOffset(0);
  }

  // After due date (positive offsets)
  Future<List<ReminderRule>> getAfterDueReminderRules() async {
    return await (select(reminderRules)
      ..where((r) => r.offsetDays.isBiggerThanValue(0))
      ..orderBy([(r) => OrderingTerm.asc(r.offsetDays)])).get();
  }

  // Bulk operations
  Future<void> insertReminderRules(List<ReminderRulesCompanion> rules) async {
    await batch((batch) {
      batch.insertAll(reminderRules, rules);
    });
  }

  Future<void> replaceReminderRulesForTemplate(String templateId, List<ReminderRulesCompanion> newRules) async {
    await transaction(() async {
      // Delete existing rules for this template
      await deleteReminderRulesByTemplate(templateId);
      
      // Insert new rules
      await insertReminderRules(newRules);
    });
  }

  // Join with templates
  Future<List<ReminderRuleWithTemplate>> getReminderRulesWithTemplates() async {
    final query = select(reminderRules).join([
      innerJoin(debtTemplates, debtTemplates.id.equalsExp(reminderRules.templateId))
    ])..orderBy([OrderingTerm.asc(reminderRules.offsetDays)]);
    
    final result = await query.get();
    return result.map((row) => ReminderRuleWithTemplate(
      rule: row.readTable(reminderRules),
      template: row.readTable(debtTemplates),
    )).toList();
  }

  Future<List<ReminderRuleWithTemplate>> getReminderRulesWithTemplatesByOffset(int offsetDays) async {
    final query = select(reminderRules).join([
      innerJoin(debtTemplates, debtTemplates.id.equalsExp(reminderRules.templateId))
    ])..where(reminderRules.offsetDays.equals(offsetDays))
     ..orderBy([OrderingTerm.asc(debtTemplates.nombre)]);
    
    final result = await query.get();
    return result.map((row) => ReminderRuleWithTemplate(
      rule: row.readTable(reminderRules),
      template: row.readTable(debtTemplates),
    )).toList();
  }

  // Check if rule exists
  Future<bool> reminderRuleExists(String templateId, int offsetDays) async {
    final rule = await (select(reminderRules)
      ..where((r) => r.templateId.equals(templateId) & r.offsetDays.equals(offsetDays))
      ..limit(1)).getSingleOrNull();
    return rule != null;
  }

  // Get unique offset values
  Future<List<int>> getUniqueOffsetDays() async {
    final query = selectOnly(reminderRules)
      ..addColumns([reminderRules.offsetDays])
      ..groupBy([reminderRules.offsetDays])
      ..orderBy([OrderingTerm.asc(reminderRules.offsetDays)]);
    
    final result = await query.get();
    return result.map((row) => row.read(reminderRules.offsetDays)!).toList();
  }

  // Statistics
  Future<int> getReminderRuleCount() async {
    final countExp = reminderRules.id.count();
    final query = selectOnly(reminderRules)..addColumns([countExp]);
    final result = await query.getSingle();
    return result.read(countExp) ?? 0;
  }

  Future<int> getReminderRuleCountByTemplate(String templateId) async {
    final countExp = reminderRules.id.count();
    final query = selectOnly(reminderRules)
      ..addColumns([countExp])
      ..where(reminderRules.templateId.equals(templateId));
    final result = await query.getSingle();
    return result.read(countExp) ?? 0;
  }

  Future<int> getReminderRuleCountByOffset(int offsetDays) async {
    final countExp = reminderRules.id.count();
    final query = selectOnly(reminderRules)
      ..addColumns([countExp])
      ..where(reminderRules.offsetDays.equals(offsetDays));
    final result = await query.getSingle();
    return result.read(countExp) ?? 0;
  }

  // Watch for real-time updates
  Stream<List<ReminderRule>> watchAllReminderRules() {
    return (select(reminderRules)..orderBy([(r) => OrderingTerm.asc(r.offsetDays)])).watch();
  }

  Stream<ReminderRule?> watchReminderRule(String id) {
    return (select(reminderRules)..where((r) => r.id.equals(id))).watchSingleOrNull();
  }

  Stream<List<ReminderRule>> watchReminderRulesByTemplate(String templateId) {
    return (select(reminderRules)
      ..where((r) => r.templateId.equals(templateId))
      ..orderBy([(r) => OrderingTerm.asc(r.offsetDays)])).watch();
  }

  Stream<List<ReminderRuleWithTemplate>> watchReminderRulesWithTemplates() {
    final query = select(reminderRules).join([
      innerJoin(debtTemplates, debtTemplates.id.equalsExp(reminderRules.templateId))
    ])..orderBy([OrderingTerm.asc(reminderRules.offsetDays)]);
    
    return query.watch().map((rows) => rows.map((row) => ReminderRuleWithTemplate(
      rule: row.readTable(reminderRules),
      template: row.readTable(debtTemplates),
    )).toList());
  }
}

// Helper class for joined data
class ReminderRuleWithTemplate {
  final ReminderRule rule;
  final DebtTemplate template;

  ReminderRuleWithTemplate({required this.rule, required this.template});
  
  String get templateName => template.nombre;
  int get offsetDays => rule.offsetDays;
  String get templateId => rule.templateId;
}