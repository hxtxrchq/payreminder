import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../presentation/screens/dashboard/dashboard_screen.dart';
import '../presentation/screens/calendar/calendar_screen.dart';
import '../presentation/screens/occurrence_detail/occurrence_detail_screen.dart';
import '../presentation/screens/template_form/template_form_screen.dart';
import '../presentation/screens/card_form/card_form_screen.dart';
import '../presentation/screens/history/history_screen.dart';
import '../presentation/screens/settings/settings_screen.dart';
import '../presentation/screens/settings/notifications_preview_screen.dart';
import '../presentation/screens/debts/debts_list_screen.dart';
import '../presentation/screens/payment_methods/payment_methods_screen.dart';
import '../presentation/screens/categories/categories_screen.dart';

GoRouter createRouter() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/calendar',
        builder: (context, state) => const CalendarScreen(),
      ),
      GoRoute(
        path: '/occurrence/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return OccurrenceDetailScreen(occurrenceId: id);
        },
      ),
      GoRoute(
        path: '/template/new',
        builder: (context, state) => const TemplateFormScreen(),
      ),
      GoRoute(
        path: '/template/:id',
        builder: (context, state) =>
            TemplateFormScreen(templateId: state.pathParameters['id']),
      ),
      GoRoute(
        path: '/card/new',
        builder: (context, state) => const CardFormScreen(),
      ),
      GoRoute(
        path: '/card/:id',
        builder: (context, state) =>
            CardFormScreen(cardId: state.pathParameters['id']),
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/settings/notifications-preview',
        builder: (context, state) => const NotificationsPreviewScreen(),
      ),
      GoRoute(
        path: '/debts',
        builder: (context, state) => const DebtsListScreen(),
      ),
      GoRoute(
        path: '/payment-methods',
        builder: (context, state) => const PaymentMethodsScreen(),
      ),
      GoRoute(
        path: '/categories',
        builder: (context, state) => const CategoriesScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('404')),
      body: Center(child: Text(state.error.toString())),
    ),
  );
}
