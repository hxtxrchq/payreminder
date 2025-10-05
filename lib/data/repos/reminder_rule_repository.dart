import 'package:drift/drift.dart';
import '../db/app_database.dart';
import '../db/reminder_rule_dao.dart';

class ReminderRuleRepository {
  final ReminderRuleDao _reminderRuleDao;

  ReminderRuleRepository(this._reminderRuleDao);

  // Basic CRUD operations
  Future<String> createReminderRule({
    required String id,
    required String templateId,
    required int offsetDays,
  }) async {
    final rule = ReminderRulesCompanion(
      id: Value(id),
      templateId: Value(templateId),
      offsetDays: Value(offsetDays),
    );
    return await _reminderRuleDao.insertReminderRule(rule);
  }

  Future<ReminderRule?> getReminderRule(String id) async {
    return await _reminderRuleDao.getReminderRuleById(id);
  }

  Future<List<ReminderRule>> getAllReminderRules() async {
    return await _reminderRuleDao.getAllReminderRules();
  }

  Future<List<ReminderRuleWithTemplate>> getReminderRulesWithTemplates() async {
    return await _reminderRuleDao.getReminderRulesWithTemplates();
  }

  Future<bool> updateReminderRule({
    required String id,
    String? templateId,
    int? offsetDays,
  }) async {
    final updates = ReminderRulesCompanion(
      id: Value(id),
      templateId: templateId != null ? Value(templateId) : Value.absent(),
      offsetDays: offsetDays != null ? Value(offsetDays) : Value.absent(),
    );
    return await _reminderRuleDao.updateReminderRule(updates);
  }

  Future<bool> deleteReminderRule(String id) async {
    return await _reminderRuleDao.deleteReminderRule(id);
  }

  // Template-specific operations
  Future<List<ReminderRule>> getReminderRulesByTemplate(String templateId) async {
    return await _reminderRuleDao.getReminderRulesByTemplate(templateId);
  }

  Future<bool> deleteReminderRulesByTemplate(String templateId) async {
    return await _reminderRuleDao.deleteReminderRulesByTemplate(templateId);
  }

  // Filter by offset
  Future<List<ReminderRule>> getReminderRulesByOffset(int offsetDays) async {
    return await _reminderRuleDao.getReminderRulesByOffset(offsetDays);
  }

  Future<List<ReminderRuleWithTemplate>> getReminderRulesWithTemplatesByOffset(int offsetDays) async {
    return await _reminderRuleDao.getReminderRulesWithTemplatesByOffset(offsetDays);
  }

  Future<List<ReminderRule>> getReminderRulesInRange(int minOffset, int maxOffset) async {
    return await _reminderRuleDao.getReminderRulesInRange(minOffset, maxOffset);
  }

  Future<List<ReminderRule>> getBeforeDueReminderRules() async {
    return await _reminderRuleDao.getBeforeDueReminderRules();
  }

  Future<List<ReminderRule>> getOnDueDateReminderRules() async {
    return await _reminderRuleDao.getOnDueDateReminderRules();
  }

  Future<List<ReminderRule>> getAfterDueReminderRules() async {
    return await _reminderRuleDao.getAfterDueReminderRules();
  }

  // Bulk operations
  Future<void> createReminderRules(List<ReminderRuleData> rulesData) async {
    final companions = rulesData.map((data) => ReminderRulesCompanion(
      id: Value(data.id),
      templateId: Value(data.templateId),
      offsetDays: Value(data.offsetDays),
    )).toList();
    
    await _reminderRuleDao.insertReminderRules(companions);
  }

  Future<void> replaceReminderRulesForTemplate(String templateId, List<int> offsetDaysList) async {
    final rulesData = offsetDaysList.map((offset) => ReminderRuleData(
      id: '${templateId}_$offset',
      templateId: templateId,
      offsetDays: offset,
    )).toList();
    
    final companions = rulesData.map((data) => ReminderRulesCompanion(
      id: Value(data.id),
      templateId: Value(data.templateId),
      offsetDays: Value(data.offsetDays),
    )).toList();
    
    await _reminderRuleDao.replaceReminderRulesForTemplate(templateId, companions);
  }

  // Validation and checking
  Future<bool> reminderRuleExists(String templateId, int offsetDays) async {
    return await _reminderRuleDao.reminderRuleExists(templateId, offsetDays);
  }

  Future<List<int>> getUniqueOffsetDays() async {
    return await _reminderRuleDao.getUniqueOffsetDays();
  }

  // Statistics
  Future<int> getReminderRuleCount() async {
    return await _reminderRuleDao.getReminderRuleCount();
  }

  Future<int> getReminderRuleCountByTemplate(String templateId) async {
    return await _reminderRuleDao.getReminderRuleCountByTemplate(templateId);
  }

  Future<int> getReminderRuleCountByOffset(int offsetDays) async {
    return await _reminderRuleDao.getReminderRuleCountByOffset(offsetDays);
  }

  Future<Map<int, int>> getReminderRuleCountByOffsetRange() async {
    final rules = await getAllReminderRules();
    final Map<int, int> offsetCounts = {};
    
    for (final rule in rules) {
      offsetCounts[rule.offsetDays] = (offsetCounts[rule.offsetDays] ?? 0) + 1;
    }
    
    return offsetCounts;
  }

  // Stream operations for real-time updates
  Stream<List<ReminderRule>> watchAllReminderRules() {
    return _reminderRuleDao.watchAllReminderRules();
  }

  Stream<ReminderRule?> watchReminderRule(String id) {
    return _reminderRuleDao.watchReminderRule(id);
  }

  Stream<List<ReminderRule>> watchReminderRulesByTemplate(String templateId) {
    return _reminderRuleDao.watchReminderRulesByTemplate(templateId);
  }

  Stream<List<ReminderRuleWithTemplate>> watchReminderRulesWithTemplates() {
    return _reminderRuleDao.watchReminderRulesWithTemplates();
  }

  // Validation methods
  String? validateOffsetDays(int? offsetDays) {
    if (offsetDays == null) {
      return 'Los días de offset son requeridos';
    }
    
    if (offsetDays < -365 || offsetDays > 365) {
      return 'Los días de offset deben estar entre -365 y 365';
    }
    
    return null;
  }

  bool isValidOffsetRange(List<int> offsets) {
    return offsets.every((offset) => validateOffsetDays(offset) == null);
  }

  // Utility methods
  List<int> getDefaultOffsetDays() {
    return [-7, -3, -1, 0]; // 7 days before, 3 days before, 1 day before, on due date
  }

  List<int> getCommonOffsetDays() {
    return [-30, -14, -7, -3, -1, 0, 1, 3, 7]; // Common reminder patterns
  }

  String getOffsetDescription(int offsetDays) {
    if (offsetDays < 0) {
      final absDays = offsetDays.abs();
      if (absDays == 1) {
        return '1 día antes del vencimiento';
      } else {
        return '$absDays días antes del vencimiento';
      }
    } else if (offsetDays == 0) {
      return 'El día del vencimiento';
    } else {
      if (offsetDays == 1) {
        return '1 día después del vencimiento';
      } else {
        return '$offsetDays días después del vencimiento';
      }
    }
  }

  String getOffsetShortDescription(int offsetDays) {
    if (offsetDays < 0) {
      return '${offsetDays.abs()}d antes';
    } else if (offsetDays == 0) {
      return 'El día';
    } else {
      return '${offsetDays}d después';
    }
  }

  DateTime calculateReminderDate(DateTime dueDate, int offsetDays) {
    return dueDate.add(Duration(days: offsetDays));
  }

  List<DateTime> calculateReminderDates(DateTime dueDate, List<int> offsetDaysList) {
    return offsetDaysList
        .map((offset) => calculateReminderDate(dueDate, offset))
        .toList();
  }

  // Group reminder rules by type
  Map<String, List<ReminderRule>> groupReminderRulesByType(List<ReminderRule> rules) {
    final Map<String, List<ReminderRule>> groups = {
      'before': [],
      'onDate': [],
      'after': [],
    };
    
    for (final rule in rules) {
      if (rule.offsetDays < 0) {
        groups['before']!.add(rule);
      } else if (rule.offsetDays == 0) {
        groups['onDate']!.add(rule);
      } else {
        groups['after']!.add(rule);
      }
    }
    
    // Sort each group
    groups['before']!.sort((a, b) => a.offsetDays.compareTo(b.offsetDays));
    groups['onDate']!.sort((a, b) => a.offsetDays.compareTo(b.offsetDays));
    groups['after']!.sort((a, b) => a.offsetDays.compareTo(b.offsetDays));
    
    return groups;
  }

  // Template setup helpers
  Future<void> setupDefaultReminderRulesForTemplate(String templateId) async {
    final defaultOffsets = getDefaultOffsetDays();
    await replaceReminderRulesForTemplate(templateId, defaultOffsets);
  }

  Future<void> copyReminderRulesFromTemplate(String fromTemplateId, String toTemplateId) async {
    final existingRules = await getReminderRulesByTemplate(fromTemplateId);
    final offsetDays = existingRules.map((rule) => rule.offsetDays).toList();
    await replaceReminderRulesForTemplate(toTemplateId, offsetDays);
  }

  // Analysis methods
  Future<ReminderRuleAnalysis> analyzeReminderRules() async {
    final rules = await getAllReminderRules();
    final offsetCounts = getReminderRuleCountByOffsetRange();
    
    final beforeDueCount = rules.where((r) => r.offsetDays < 0).length;
    final onDueDateCount = rules.where((r) => r.offsetDays == 0).length;
    final afterDueCount = rules.where((r) => r.offsetDays > 0).length;
    
    final uniqueOffsets = rules.map((r) => r.offsetDays).toSet().toList()..sort();
    
    return ReminderRuleAnalysis(
      totalRules: rules.length,
      beforeDueCount: beforeDueCount,
      onDueDateCount: onDueDateCount,
      afterDueCount: afterDueCount,
      uniqueOffsets: uniqueOffsets,
      offsetCounts: await offsetCounts,
    );
  }
}

// Helper classes
class ReminderRuleData {
  final String id;
  final String templateId;
  final int offsetDays;

  ReminderRuleData({
    required this.id,
    required this.templateId,
    required this.offsetDays,
  });
}

class ReminderRuleAnalysis {
  final int totalRules;
  final int beforeDueCount;
  final int onDueDateCount;
  final int afterDueCount;
  final List<int> uniqueOffsets;
  final Map<int, int> offsetCounts;

  ReminderRuleAnalysis({
    required this.totalRules,
    required this.beforeDueCount,
    required this.onDueDateCount,
    required this.afterDueCount,
    required this.uniqueOffsets,
    required this.offsetCounts,
  });
}