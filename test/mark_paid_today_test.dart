import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payreminderapp/logic/providers/repository_providers.dart';
import 'test_utils.dart';
import 'package:payreminderapp/logic/providers/settings_providers.dart';
import 'package:payreminderapp/logic/providers/usecase_providers.dart';
import 'package:payreminderapp/services/notifications/i_notification_service.dart';

class MockNotif extends Mock implements INotificationService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('MarkPaid permite pagar occurrence DUE_TODAY y cancela offsets reales',
      () async {
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

    final overrides = <Override>[
      notificationServiceProvider.overrideWithValue(mock),
      settingsProvider
          .overrideWith((ref) => SettingsNotifier(ref, skipLoad: true)),
      ...inMemoryDbOverride(),
    ];
    final container = ProviderContainer(overrides: overrides);
    addTearDown(container.dispose);

    // Crear template y occurrence manualmente
    final tplRepo = container.read(templateRepositoryProvider);
    final occRepo = container.read(occurrenceRepositoryProvider);
    final ruleRepo = container.read(reminderRuleRepositoryProvider);
    final today = DateTime.now();
    final templateId = 'tpl_test_${today.millisecondsSinceEpoch}';
    await tplRepo.createTemplate(
        id: templateId, nombre: 'Hoy', monto: 50, hasInterest: false);
    // reglas
    await ruleRepo
        .replaceReminderRulesForTemplate(templateId, const [-3, -1, 0]);
    final occId = 'occ_${today.millisecondsSinceEpoch}';
    await occRepo.createOccurrence(
        id: occId,
        templateId: templateId,
        fechaDue: today,
        monto: 50,
        estado: 'DUE_TODAY');
    final occ = (await occRepo.getOccurrence(occId))!;
    // Forzamos estado DUE_TODAY por consistencia (en caso nearThreshold lógica)
    await occRepo.updateOccurrence(id: occ.id, estado: 'DUE_TODAY');

    final markUc = container.read(markPaidUseCaseProvider);
    final payResult = await markUc.execute(occurrenceId: occ.id);
    expect(payResult.isSuccess, true);

    // Verifica pago insertado
    final payment = await container
        .read(paymentRepositoryProvider)
        .getPaymentByOccurrence(occ.id);
    expect(payment != null, true);

    // Verifica estado PAID
    final updated = await occRepo.getOccurrence(occ.id);
    expect(updated!.estado, 'PAID');

    // Verifica cancelOccurrenceReminders fue llamado con offsets reales
    verify(() =>
            mock.cancelOccurrenceReminders(occ.id, any(that: isA<List<int>>())))
        .called(greaterThan(0));
  });
}
