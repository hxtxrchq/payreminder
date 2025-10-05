import '../../../data/repos/occurrence_repository.dart';
import '../../../data/repos/reminder_rule_repository.dart';
import '../../../services/notifications/i_notification_service.dart';

class ScheduleRemindersForOccurrenceUseCase {
  final OccurrenceRepository _occurrenceRepository;
  final ReminderRuleRepository _reminderRuleRepository;
  final INotificationService _notificationService;

  ScheduleRemindersForOccurrenceUseCase(
    this._occurrenceRepository,
    this._reminderRuleRepository,
    this._notificationService,
  );

  Future<ReminderScheduleResult> execute(String occurrenceId) async {
    try {
      // Obtener la ocurrencia
      final occurrence =
          await _occurrenceRepository.getOccurrence(occurrenceId);
      if (occurrence == null) {
        return ReminderScheduleResult.error('Ocurrencia no encontrada');
      }

      // Solo programar recordatorios para ocurrencias activas
      if (occurrence.estado == 'PAID' || occurrence.estado == 'CANCELLED') {
        return ReminderScheduleResult.success(
          scheduledCount: 0,
          message:
              'No se programan recordatorios para ocurrencias pagadas o canceladas',
        );
      }

      // Obtener las reglas de recordatorio para la plantilla
      final reminderRules = await _reminderRuleRepository
          .getReminderRulesByTemplate(occurrence.templateId);

      if (reminderRules.isEmpty) {
        return ReminderScheduleResult.success(
          scheduledCount: 0,
          message:
              'No hay reglas de recordatorio configuradas para esta plantilla',
        );
      }

      final dueDate = DateTime.fromMillisecondsSinceEpoch(occurrence.fechaDue);
      final List<ScheduledReminder> scheduledReminders = [];
      final List<String> errors = [];

      // Programar cada recordatorio según las reglas
      for (final rule in reminderRules) {
        try {
          final reminderDate = dueDate.add(Duration(days: rule.offsetDays));

          // Solo programar recordatorios futuros
          if (reminderDate.isAfter(DateTime.now())) {
            final notificationId = '${occurrenceId}_${rule.offsetDays}';

            await _notificationService.schedulePaymentReminder(
              id: notificationId,
              title: _getReminderTitle(rule.offsetDays),
              body: _getReminderBody(occurrence, dueDate, rule.offsetDays),
              scheduledDate: reminderDate,
              payload: occurrenceId,
            );

            scheduledReminders.add(ScheduledReminder(
              notificationId: notificationId,
              occurrenceId: occurrenceId,
              scheduledDate: reminderDate,
              offsetDays: rule.offsetDays,
              ruleId: rule.id,
            ));
          }
        } catch (e) {
          errors.add(
              'Error programando recordatorio para offset ${rule.offsetDays}: $e');
        }
      }

      return ReminderScheduleResult.success(
        scheduledCount: scheduledReminders.length,
        scheduledReminders: scheduledReminders,
        errors: errors,
        message: 'Se programaron ${scheduledReminders.length} recordatorios',
      );
    } catch (e) {
      return ReminderScheduleResult.error(
          'Error programando recordatorios: $e');
    }
  }

  Future<BatchReminderResult> scheduleRemindersForMultipleOccurrences(
      List<String> occurrenceIds) async {
    final List<ReminderScheduleResult> results = [];
    int totalScheduled = 0;
    final List<String> allErrors = [];

    for (final occurrenceId in occurrenceIds) {
      final result = await execute(occurrenceId);
      results.add(result);

      if (result.isSuccess) {
        totalScheduled += result.scheduledCount;
      }

      allErrors.addAll(result.errors);
    }

    return BatchReminderResult(
      results: results,
      totalScheduled: totalScheduled,
      processedOccurrences: occurrenceIds.length,
      errors: allErrors,
    );
  }

  Future<ReminderScheduleResult> cancelRemindersForOccurrence(
      String occurrenceId) async {
    try {
      // Obtener la ocurrencia para saber qué recordatorios cancelar
      final occurrence =
          await _occurrenceRepository.getOccurrence(occurrenceId);
      if (occurrence == null) {
        return ReminderScheduleResult.error('Ocurrencia no encontrada');
      }

      // Obtener las reglas de recordatorio para saber qué notificaciones cancelar
      final reminderRules = await _reminderRuleRepository
          .getReminderRulesByTemplate(occurrence.templateId);

      int cancelledCount = 0;
      final List<String> errors = [];

      // Cancelar cada notificación programada
      for (final rule in reminderRules) {
        try {
          final notificationId = '${occurrenceId}_${rule.offsetDays}';
          await _notificationService.cancelNotification(notificationId);
          cancelledCount++;
        } catch (e) {
          errors.add('Error cancelando recordatorio ${rule.offsetDays}: $e');
        }
      }

      return ReminderScheduleResult.success(
        scheduledCount: cancelledCount,
        errors: errors,
        message: 'Se cancelaron $cancelledCount recordatorios',
      );
    } catch (e) {
      return ReminderScheduleResult.error('Error cancelando recordatorios: $e');
    }
  }

  Future<ReminderScheduleResult> rescheduleRemindersForOccurrence(
      String occurrenceId, DateTime newDueDate) async {
    try {
      // Primero cancelar los recordatorios existentes
      await cancelRemindersForOccurrence(occurrenceId);

      // Actualizar la fecha de vencimiento de la ocurrencia
      await _occurrenceRepository.updateOccurrence(
        id: occurrenceId,
        fechaDue: newDueDate,
      );

      // Programar nuevos recordatorios con la nueva fecha
      final result = await execute(occurrenceId);

      return ReminderScheduleResult.success(
        scheduledCount: result.scheduledCount,
        scheduledReminders: result.scheduledReminders,
        errors: result.errors,
        message: 'Recordatorios reprogramados exitosamente',
      );
    } catch (e) {
      return ReminderScheduleResult.error(
          'Error reprogramando recordatorios: $e');
    }
  }

  // Método para programar recordatorios pendientes
  Future<BatchReminderResult> scheduleUpcomingReminders({
    int lookAheadDays = 30,
    List<String>? specificTemplateIds,
  }) async {
    try {
      // Obtener ocurrencias pendientes próximas
      final endDate = DateTime.now().add(Duration(days: lookAheadDays));
      final occurrences = await _occurrenceRepository.getOccurrencesByDateRange(
        DateTime.now(),
        endDate,
      );

      // Filtrar por plantillas específicas si se proporcionan
      final filteredOccurrences = specificTemplateIds != null
          ? occurrences
              .where((o) => specificTemplateIds.contains(o.templateId))
              .toList()
          : occurrences;

      // Filtrar solo ocurrencias pendientes
      final pendingOccurrences = filteredOccurrences
          .where((o) => o.estado == 'PENDING' || o.estado == 'OVERDUE')
          .toList();

      final occurrenceIds = pendingOccurrences.map((o) => o.id).toList();

      return await scheduleRemindersForMultipleOccurrences(occurrenceIds);
    } catch (e) {
      return BatchReminderResult(
        results: [],
        totalScheduled: 0,
        processedOccurrences: 0,
        errors: ['Error programando recordatorios próximos: $e'],
      );
    }
  }

  // Métodos de utilidad para generar contenido de recordatorios
  String _getReminderTitle(int offsetDays) {
    if (offsetDays < 0) {
      final absDays = offsetDays.abs();
      if (absDays == 1) {
        return 'Recordatorio: Pago mañana';
      } else {
        return 'Recordatorio: Pago en $absDays días';
      }
    } else if (offsetDays == 0) {
      return '¡Pago vencido hoy!';
    } else {
      if (offsetDays == 1) {
        return 'Pago vencido desde ayer';
      } else {
        return 'Pago vencido hace $offsetDays días';
      }
    }
  }

  String _getReminderBody(
      dynamic occurrence, DateTime dueDate, int offsetDays) {
    final dueDateStr = '${dueDate.day}/${dueDate.month}/${dueDate.year}';
    final amount = occurrence.monto.toStringAsFixed(2);

    if (offsetDays < 0) {
      return 'Tienes un pago pendiente de \$$amount con vencimiento el $dueDateStr';
    } else if (offsetDays == 0) {
      return 'Tu pago de \$$amount vence hoy ($dueDateStr)';
    } else {
      return 'Tu pago de \$$amount venció el $dueDateStr. ¡Págalo cuanto antes!';
    }
  }

  // Métodos de configuración
  Future<void> updateReminderRulesForTemplate(
      String templateId, List<int> newOffsetDays) async {
    // Actualizar las reglas de recordatorio
    await _reminderRuleRepository.replaceReminderRulesForTemplate(
        templateId, newOffsetDays);

    // Reprogramar recordatorios para todas las ocurrencias pendientes de esta plantilla
    final pendingOccurrences =
        await _occurrenceRepository.getOccurrencesByTemplate(templateId);
    final activePendingOccurrences = pendingOccurrences
        .where((o) => o.estado == 'PENDING' || o.estado == 'OVERDUE')
        .toList();

    for (final occurrence in activePendingOccurrences) {
      await cancelRemindersForOccurrence(occurrence.id);
      await execute(occurrence.id);
    }
  }

  // Estadísticas y análisis
  Future<ReminderStatistics> getReminderStatistics() async {
    final allRules = await _reminderRuleRepository.getAllReminderRules();
    final pendingOccurrences =
        await _occurrenceRepository.getPendingOccurrences();

    final estimatedNotifications = pendingOccurrences.length *
        (allRules.length / allRules.map((r) => r.templateId).toSet().length);

    return ReminderStatistics(
      totalReminderRules: allRules.length,
      activePendingOccurrences: pendingOccurrences.length,
      estimatedActiveNotifications: estimatedNotifications.round(),
      templatesWithRules: allRules.map((r) => r.templateId).toSet().length,
    );
  }
}

class ReminderScheduleResult {
  final bool isSuccess;
  final int scheduledCount;
  final List<ScheduledReminder> scheduledReminders;
  final List<String> errors;
  final String message;
  final String? error;

  ReminderScheduleResult._({
    required this.isSuccess,
    required this.scheduledCount,
    required this.scheduledReminders,
    required this.errors,
    required this.message,
    this.error,
  });

  factory ReminderScheduleResult.success({
    required int scheduledCount,
    List<ScheduledReminder>? scheduledReminders,
    List<String>? errors,
    String? message,
  }) {
    return ReminderScheduleResult._(
      isSuccess: true,
      scheduledCount: scheduledCount,
      scheduledReminders: scheduledReminders ?? [],
      errors: errors ?? [],
      message: message ?? 'Recordatorios programados exitosamente',
    );
  }

  factory ReminderScheduleResult.error(String error) {
    return ReminderScheduleResult._(
      isSuccess: false,
      scheduledCount: 0,
      scheduledReminders: [],
      errors: [],
      message: error,
      error: error,
    );
  }
}

class ScheduledReminder {
  final String notificationId;
  final String occurrenceId;
  final DateTime scheduledDate;
  final int offsetDays;
  final String ruleId;

  ScheduledReminder({
    required this.notificationId,
    required this.occurrenceId,
    required this.scheduledDate,
    required this.offsetDays,
    required this.ruleId,
  });
}

class BatchReminderResult {
  final List<ReminderScheduleResult> results;
  final int totalScheduled;
  final int processedOccurrences;
  final List<String> errors;

  BatchReminderResult({
    required this.results,
    required this.totalScheduled,
    required this.processedOccurrences,
    required this.errors,
  });

  int get successfulOccurrences => results.where((r) => r.isSuccess).length;
  int get failedOccurrences => results.where((r) => !r.isSuccess).length;
  bool get hasErrors => errors.isNotEmpty || failedOccurrences > 0;
}

class ReminderStatistics {
  final int totalReminderRules;
  final int activePendingOccurrences;
  final int estimatedActiveNotifications;
  final int templatesWithRules;

  ReminderStatistics({
    required this.totalReminderRules,
    required this.activePendingOccurrences,
    required this.estimatedActiveNotifications,
    required this.templatesWithRules,
  });
}
