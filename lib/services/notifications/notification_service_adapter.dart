import 'i_notification_service.dart';
import 'notification_service.dart';

class NotificationServiceAdapter implements INotificationService {
  final NotificationService _inner;
  NotificationServiceAdapter({NotificationService? inner})
      : _inner = inner ?? NotificationService.instance;

  @override
  Future<void> cancelOccurrenceReminders(
      String occurrenceId, List<int> offsets) {
    return _inner.cancelOccurrenceReminders(occurrenceId, offsets);
  }

  @override
  Future<void> schedulePaymentReminder({
    required String id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) {
    return _inner.schedulePaymentReminder(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      payload: payload,
    );
  }

  @override
  Future<void> cancelNotification(String id) async {
    // El NotificationService original usa string -> hash; aquí recibimos int directo.
    // Para compatibilidad mínima, ignoramos si no existe.
    // No hay método directo para cancelar por int salvo cancel(id) a través de instancia.
    // Reutilizamos el plugin interno mediante método show/schedule ya implementado.
    try {
      // ignore: invalid_use_of_visible_for_testing_member
      await NotificationService.instance.cancelNotification(id); // hash interno
    } catch (_) {}
  }

  @override
  Future<void> scheduleOccurrenceReminder({
    required String occurrenceId,
    required String title,
    required String body,
    required DateTime dueDateLocal,
    required int offsetDays,
    int hour = 9,
    int minute = 0,
  }) {
    return _inner.scheduleOccurrenceReminder(
      occurrenceId: occurrenceId,
      title: title,
      body: body,
      dueDateLocal: dueDateLocal,
      offsetDays: offsetDays,
      hour: hour,
      minute: minute,
    );
  }
}
