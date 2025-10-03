import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:flutter_native_timezone_updated_gradle/flutter_native_timezone.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _fln =
      FlutterLocalNotificationsPlugin();
  // Use a versioned channel to guarantee max importance on devices that may have created
  // a previous channel with lower importance (Android doesn't allow changing it later).
  static const String channelId = 'payreminder_reminders_v2';

  // Produce a safe, non-negative 31-bit int ID from any string key
  int _safeId(String key) {
    final mixed = key.hashCode;
    return (mixed.abs()) & 0x7fffffff;
  }

  Future<void> initialize() async {
    // Asegurar TZ inicializado y zona local correcta (Android/iOS)
    tzdata.initializeTimeZones();
    try {
      final name = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(name));
    } catch (_) {
      // Fallback: mantener tz.local como esté configurado (p. ej., por TimezoneService)
    }

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await _fln.initialize(initSettings,
        onDidReceiveNotificationResponse: (details) {
      // TODO: navegar a /occurrence/:id con NavigatorKey global si agregas deep links
    });

    const androidChannel = AndroidNotificationChannel(
      channelId,
      'Recordatorios de pago',
      description: 'Notificaciones de vencimientos y recordatorios',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );
    await _fln
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  // Helper: schedule mode según permisos de exact alarms
  Future<AndroidScheduleMode> _pickScheduleMode() async {
    final android = _fln.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    bool canExact = await android?.canScheduleExactNotifications() ?? false;
    if (!canExact) {
      try {
        await android?.requestExactAlarmsPermission();
      } catch (_) {}
      canExact = await android?.canScheduleExactNotifications() ?? false;
    }
    return canExact
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;
  }

  NotificationDetails _defaultDetails({String? bigText}) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        'Recordatorios de pago',
        channelDescription: 'Notificaciones de vencimientos y recordatorios',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        visibility: NotificationVisibility.public,
        styleInformation:
            bigText != null ? BigTextStyleInformation(bigText) : null,
      ),
      iOS: const DarwinNotificationDetails(),
    );
  }

  // Android 13+ (Tiramisu) notifications runtime permission helpers
  Future<bool> areNotificationsEnabled() async {
    final android = _fln.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final enabled = await android?.areNotificationsEnabled();
    return enabled ?? true; // assume enabled when API not available
  }

  Future<bool> requestNotificationsPermission() async {
    final android = _fln.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    try {
      final granted = await android?.requestNotificationsPermission();
      return granted ?? true;
    } catch (_) {
      return false;
    }
  }

  // Generate a safe 31-bit positive notification ID based on occurrence and offset
  int _idFor(String occurrenceId, int offsetDays) {
    final mixed = (occurrenceId.hashCode ^ offsetDays);
    return (mixed.abs()) & 0x7fffffff; // ensure non-negative 31-bit int
  }

  Future<void> scheduleOccurrenceReminder({
    required String occurrenceId,
    required String title,
    required String body,
    required DateTime dueDateLocal,
    required int offsetDays,
    int hour = 9,
    int minute = 0,
  }) async {
    final when =
        DateTime(dueDateLocal.year, dueDateLocal.month, dueDateLocal.day)
            .add(Duration(days: offsetDays, hours: hour, minutes: minute));
    if (when.isBefore(DateTime.now())) return;

    final tzWhen = tz.TZDateTime.from(when, tz.local);
    final id = _idFor(occurrenceId, offsetDays);

    final details = _defaultDetails();

    // Check exact alarm permission and select schedule mode accordingly
    final android = _fln.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    bool canExact = await android?.canScheduleExactNotifications() ?? false;
    if (!canExact) {
      // Best-effort request on supported Android versions; ignore if not available
      try {
        await android?.requestExactAlarmsPermission();
      } catch (_) {}
      canExact = await android?.canScheduleExactNotifications() ?? false;
    }
    final scheduleMode = canExact
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;

    await _fln.zonedSchedule(
      id,
      title,
      body,
      tzWhen,
      details,
      androidScheduleMode: scheduleMode,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  Future<void> cancelOccurrenceReminders(
      String occurrenceId, List<int> offsets) async {
    for (final o in offsets) {
      await _fln.cancel(_idFor(occurrenceId, o));
    }
  }

  // Compatibility wrappers for legacy callers scheduling/cancelling by string IDs
  Future<void> schedulePaymentReminder({
    required String id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    final tzWhen = tz.TZDateTime.from(scheduledDate, tz.local);

    final details = _defaultDetails();

    final android = _fln.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    bool canExact = await android?.canScheduleExactNotifications() ?? false;
    if (!canExact) {
      try {
        await android?.requestExactAlarmsPermission();
      } catch (_) {}
      canExact = await android?.canScheduleExactNotifications() ?? false;
    }
    final scheduleMode = canExact
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;

    await _fln.zonedSchedule(
      _safeId(id),
      title,
      body,
      tzWhen,
      details,
      androidScheduleMode: scheduleMode,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
      payload: payload,
    );
  }

  Future<void> cancelNotification(String id) async {
    await _fln.cancel(_safeId(id));
  }

  // Show a payment reminder immediately (preview)
  Future<void> showPaymentReminderNow({
    required String id,
    required String title,
    required String body,
    String? payload,
  }) async {
    final nid = _safeId(id);
    final details = _defaultDetails(bigText: body);
    // Debug log para QA rápida
    // ignore: avoid_print
    print('[NotifPreview] immediate channel=$channelId id=$nid tz=${tz.local}');
    await _fln.show(nid, title, body, details, payload: payload);
  }

  // Programar notificación en N segundos (para pruebas de background)
  Future<void> scheduleInSeconds({
    required String id,
    required String title,
    required String body,
    required int seconds,
    String? payload,
  }) async {
    final nid = _safeId(id);
    final when = tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds));
    final mode = await _pickScheduleMode();

    // Sanity logs (debug)
    try {
      final android = _fln.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      final enabled = await android?.areNotificationsEnabled();
      final exact = await android?.canScheduleExactNotifications();
      // ignore: avoid_print
      print('[NotifPreview] enabled='
          '${enabled} exact=${exact} tz=${tz.local} '
          'channel=${channelId} id=${nid} when=${when} mode=${mode}');
    } catch (_) {}

    await _fln.zonedSchedule(
      nid,
      title,
      body,
      when,
      _defaultDetails(bigText: body),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: mode,
      payload: payload,
    );
  }
}
