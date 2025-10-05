import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/timezone/timezone_service.dart';
import 'services/notifications/notification_service.dart';
import 'app/router.dart';
import 'app/theme/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TimezoneService.initialize();
  await NotificationService.instance.initialize();
  runApp(const ProviderScope(child: PayReminderApp()));
}

class PayReminderApp extends StatelessWidget {
  const PayReminderApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = createRouter();
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'PayReminderApp',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      supportedLocales: const [Locale('es', 'PE'), Locale('es')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
    );
  }
}
