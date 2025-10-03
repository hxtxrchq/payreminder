import '../../data/repos/occurrence_repository.dart';
import '../../data/repos/payment_repository.dart';
import '../../data/repos/reminder_rule_repository.dart';
import '../../data/repos/recurrence_repository.dart';
import '../../data/repos/template_repository.dart';
import '../../services/notifications/notification_service.dart';

class DeleteDebtUseCase {
  final OccurrenceRepository _occRepo;
  final PaymentRepository _payRepo;
  final ReminderRuleRepository _ruleRepo;
  final RecurrenceRepository _recRepo;
  final TemplateRepository _tplRepo;
  final NotificationService _notif;

  DeleteDebtUseCase(
    this._occRepo,
    this._payRepo,
    this._ruleRepo,
    this._recRepo,
    this._tplRepo,
    this._notif,
  );

  /// Returns true if deleted, false otherwise. Throws on unexpected errors.
  Future<bool> execute(String templateId) async {
    // Rule: if there are payments for this template, do not delete.
    final count = await hasPayments(templateId);
    if (count > 0) return false;

    // Obtain reminder rule offsets for this template
    final rules = await _ruleRepo.getReminderRulesByTemplate(templateId);
    final offsets = rules.map((r) => r.offsetDays).toList();

    // Get occurrences for template and cancel notifications for future/today unpaid ones
    final occurrences = await _occRepo.getOccurrencesByTemplate(templateId);
    final now = DateTime.now();
    for (final occ in occurrences) {
      final due = DateTime.fromMillisecondsSinceEpoch(occ.fechaDue);
      final isUnpaid = occ.estado != 'PAID';
      final isFutureOrToday = DateTime(due.year, due.month, due.day).isAfter(
          DateTime(now.year, now.month, now.day)
              .subtract(const Duration(days: 1)));
      if (isUnpaid && isFutureOrToday && offsets.isNotEmpty) {
        try {
          await _notif.cancelOccurrenceReminders(occ.id, offsets);
        } catch (_) {}
      }
    }

    // Delete all occurrences for this template.
    await _occRepo.deleteOccurrencesByTemplate(templateId);

    // Delete reminder rules for template.
    await _ruleRepo.deleteReminderRulesByTemplate(templateId);

    // Delete recurrence for template (if exists).
    await _recRepo.deleteRecurrencesByTemplate(templateId);

    // Finally, delete the template itself.
    final ok = await _tplRepo.deleteTemplate(templateId);
    return ok;
  }

  Future<int> hasPayments(String templateId) async {
    // Fallback approach: count payments joining via occurrences by template
    // If PaymentRepository/DAO lacks a dedicated method, compute here.
    final occs = await _occRepo.getOccurrencesByTemplate(templateId);
    int total = 0;
    for (final o in occs) {
      final p = await _payRepo.getPaymentByOccurrence(o.id);
      if (p != null) total++;
    }
    return total;
  }
}
