import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TimezoneService {
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    tz.initializeTimeZones();
    
    // Configurar timezone para Lima, Perú (UTC-5)
    tz.setLocalLocation(tz.getLocation('America/Lima'));
    
    _initialized = true;
  }

  static tz.TZDateTime now() {
    return tz.TZDateTime.now(tz.local);
  }

  static tz.TZDateTime fromDateTime(DateTime dateTime) {
    return tz.TZDateTime.from(dateTime, tz.local);
  }

  static tz.TZDateTime create(int year, int month, int day, [int hour = 0, int minute = 0, int second = 0]) {
    return tz.TZDateTime(tz.local, year, month, day, hour, minute, second);
  }

  static String getLocalTimezoneName() {
    return tz.local.name;
  }

  static int getTimezoneOffset() {
    return tz.local.currentTimeZone.offset;
  }
}