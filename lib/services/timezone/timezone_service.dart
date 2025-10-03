import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TimezoneService {
  static Future<void> initialize() async {
    tz.initializeTimeZones();
    // Para Perú por defecto
    tz.setLocalLocation(tz.getLocation('America/Lima'));
  }
}