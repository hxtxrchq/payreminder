abstract class INotificationService {
  Future<void> cancelOccurrenceReminders(
      String occurrenceId, List<int> offsets);
  Future<void> schedulePaymentReminder({
    required String id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  });
  Future<void> cancelNotification(String id);

  // Método específico existente en NotificationService para scheduling de occurrence con offset
  Future<void> scheduleOccurrenceReminder({
    required String occurrenceId,
    required String title,
    required String body,
    required DateTime dueDateLocal,
    required int offsetDays,
    int hour = 9,
    int minute = 0,
  });
}
