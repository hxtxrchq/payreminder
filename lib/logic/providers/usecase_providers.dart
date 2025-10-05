import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/generate_occurrences_for_template_usecase.dart';
import '../../domain/usecases/update_occurrence_statuses_usecase.dart';
import '../../domain/usecases/schedule_reminders_for_occurrence_usecase.dart';
import '../../domain/usecases/mark_paid_usecase.dart';
import '../../domain/usecases/undo_paid_usecase.dart';
import '../../services/notifications/i_notification_service.dart';
import '../../services/notifications/notification_service_adapter.dart';
import '../../domain/usecases/delete_debt_usecase.dart';
import 'repository_providers.dart';

// Provider para el servicio de notificaciones
final notificationServiceProvider = Provider<INotificationService>((ref) {
  return NotificationServiceAdapter();
});

// Providers para los casos de uso
final generateOccurrencesUseCaseProvider =
    Provider<GenerateOccurrencesForTemplateUseCase>((ref) {
  final occurrenceRepository = ref.watch(occurrenceRepositoryProvider);
  final recurrenceRepository = ref.watch(recurrenceRepositoryProvider);
  final templateRepository = ref.watch(templateRepositoryProvider);
  final notificationService = ref.watch(notificationServiceProvider);

  return GenerateOccurrencesForTemplateUseCase(
    occurrenceRepository,
    recurrenceRepository,
    templateRepository,
    notificationService,
  );
});

final updateOccurrenceStatusesUseCaseProvider =
    Provider<UpdateOccurrenceStatusesUseCase>((ref) {
  final occurrenceRepository = ref.watch(occurrenceRepositoryProvider);
  final paymentRepository = ref.watch(paymentRepositoryProvider);

  return UpdateOccurrenceStatusesUseCase(
    occurrenceRepository,
    paymentRepository,
  );
});

final scheduleRemindersUseCaseProvider =
    Provider<ScheduleRemindersForOccurrenceUseCase>((ref) {
  final occurrenceRepository = ref.watch(occurrenceRepositoryProvider);
  final reminderRuleRepository = ref.watch(reminderRuleRepositoryProvider);
  final notificationService = ref.watch(notificationServiceProvider);

  return ScheduleRemindersForOccurrenceUseCase(
    occurrenceRepository,
    reminderRuleRepository,
    notificationService,
  );
});

final markPaidUseCaseProvider = Provider<MarkPaidUseCase>((ref) {
  final occurrenceRepository = ref.watch(occurrenceRepositoryProvider);
  final paymentRepository = ref.watch(paymentRepositoryProvider);
  final templateRepository = ref.watch(templateRepositoryProvider);
  final reminderRuleRepository = ref.watch(reminderRuleRepositoryProvider);
  final updateStatusesUseCase =
      ref.watch(updateOccurrenceStatusesUseCaseProvider);
  final notificationService = ref.watch(notificationServiceProvider);

  return MarkPaidUseCase(
    occurrenceRepository,
    paymentRepository,
    templateRepository,
    reminderRuleRepository,
    updateStatusesUseCase,
    notificationService,
    ref,
  );
});

final undoPaidUseCaseProvider = Provider<UndoPaidUseCase>((ref) {
  final occurrenceRepository = ref.watch(occurrenceRepositoryProvider);
  final paymentRepository = ref.watch(paymentRepositoryProvider);
  final updateStatusesUseCase =
      ref.watch(updateOccurrenceStatusesUseCaseProvider);

  return UndoPaidUseCase(
    occurrenceRepository,
    paymentRepository,
    updateStatusesUseCase,
  );
});

// Delete debt use case
final deleteDebtUseCaseProvider = Provider<DeleteDebtUseCase>((ref) {
  final occ = ref.watch(occurrenceRepositoryProvider);
  final pay = ref.watch(paymentRepositoryProvider);
  final rule = ref.watch(reminderRuleRepositoryProvider);
  final rec = ref.watch(recurrenceRepositoryProvider);
  final tpl = ref.watch(templateRepositoryProvider);
  final notif = ref.watch(notificationServiceProvider);
  return DeleteDebtUseCase(occ, pay, rule, rec, tpl, notif);
});

// Helper to toggle archive flag on a template
final toggleArchiveProvider =
    FutureProvider.family<bool, String>((ref, templateId) async {
  final tplRepo = ref.read(templateRepositoryProvider);
  final tpl = await tplRepo.getTemplate(templateId);
  if (tpl == null) return false;
  return tplRepo.updateTemplate(id: templateId, isArchived: !tpl.isArchived);
});
