import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payreminderapp/services/notifications/i_notification_service.dart';
import 'package:payreminderapp/logic/providers/repository_providers.dart';
import 'package:payreminderapp/logic/providers/usecase_providers.dart';
import 'test_utils.dart';
import 'package:payreminderapp/logic/providers/settings_providers.dart';
import 'package:payreminderapp/logic/providers/occurrence_providers.dart';

class MockNotif extends Mock implements INotificationService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('KPIs se actualizan tras marcar como pagado', () async {
    final mock = MockNotif();
    when(() => mock.cancelOccurrenceReminders(any(), any()))
        .thenAnswer((_) async {});
    when(() => mock.schedulePaymentReminder(
        id: any(named: 'id'),
        title: any(named: 'title'),
        body: any(named: 'body'),
        scheduledDate: any(named: 'scheduledDate'),
        payload: any(named: 'payload'))).thenAnswer((_) async {});
    when(() => mock.scheduleOccurrenceReminder(
        occurrenceId: any(named: 'occurrenceId'),
        title: any(named: 'title'),
        body: any(named: 'body'),
        dueDateLocal: any(named: 'dueDateLocal'),
        offsetDays: any(named: 'offsetDays'),
        hour: any(named: 'hour'),
        minute: any(named: 'minute'))).thenAnswer((_) async {});
    when(() => mock.cancelNotification(any())).thenAnswer((_) async {});

    final container = ProviderContainer(overrides: [
      notificationServiceProvider.overrideWithValue(mock),
      settingsProvider
          .overrideWith((ref) => SettingsNotifier(ref, skipLoad: true)),
      ...inMemoryDbOverride()
    ]);
    addTearDown(container.dispose);

    final tplRepo = container.read(templateRepositoryProvider);
    final occRepo = container.read(occurrenceRepositoryProvider);
    final ruleRepo = container.read(reminderRuleRepositoryProvider);

    final today = DateTime.now();
    final templateId = 'tpl_kpi_${today.millisecondsSinceEpoch}';
    await tplRepo.createTemplate(
        id: templateId, nombre: 'KPI', monto: 20, hasInterest: false);
    await ruleRepo.replaceReminderRulesForTemplate(templateId, const [-1]);
    final occId = 'occ_kpi_${today.millisecondsSinceEpoch}';
    await occRepo.createOccurrence(
        id: occId,
        templateId: templateId,
        fechaDue: today,
        monto: 20,
        estado: 'DUE_TODAY');

    final monthStart = DateTime(today.year, today.month, 1);
    final kpiStream = container.read(monthKpisProvider(monthStart).stream);
    final first = await kpiStream.firstWhere((_) => true);

    // Debe contar pending-like
    final pendingBaseline = first.pendingCount;

    final markUc = container.read(markPaidUseCaseProvider);
    final res = await markUc.execute(occurrenceId: occId);
    expect(res.isSuccess, true);

    final after = await kpiStream.firstWhere((k) => k.paidCount >= 1);
    expect(after.paidCount, first.paidCount + 1);
    expect(after.pendingCount, pendingBaseline - 1);
  });
}
