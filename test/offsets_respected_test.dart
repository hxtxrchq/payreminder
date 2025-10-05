import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payreminderapp/services/notifications/i_notification_service.dart';
import 'package:payreminderapp/logic/providers/repository_providers.dart';
import 'package:payreminderapp/logic/providers/usecase_providers.dart';
import 'test_utils.dart';
import 'package:payreminderapp/logic/providers/settings_providers.dart';

class MockNotif extends Mock implements INotificationService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
      'Offsets personalizados se cancelan y re-programan correctamente al editar',
      () async {
    final mock = MockNotif();
    final scheduled =
        <String, List<int>>{}; // occurrenceId -> offsets programados
    final cancelled = <String, List<int>>{};

    when(() => mock.scheduleOccurrenceReminder(
        occurrenceId: any(named: 'occurrenceId'),
        title: any(named: 'title'),
        body: any(named: 'body'),
        dueDateLocal: any(named: 'dueDateLocal'),
        offsetDays: any(named: 'offsetDays'),
        hour: any(named: 'hour'),
        minute: any(named: 'minute'))).thenAnswer((invocation) async {
      final occId =
          invocation.namedArguments[const Symbol('occurrenceId')] as String;
      final off = invocation.namedArguments[const Symbol('offsetDays')] as int;
      scheduled.putIfAbsent(occId, () => []).add(off);
    });

    when(() => mock.cancelOccurrenceReminders(any(), any()))
        .thenAnswer((inv) async {
      final occId = inv.positionalArguments[0] as String;
      final offs = (inv.positionalArguments[1] as List<int>);
      cancelled.putIfAbsent(occId, () => []).addAll(offs);
    });
    when(() => mock.schedulePaymentReminder(
        id: any(named: 'id'),
        title: any(named: 'title'),
        body: any(named: 'body'),
        scheduledDate: any(named: 'scheduledDate'),
        payload: any(named: 'payload'))).thenAnswer((_) async {});
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

    // Crear template recurrente con offsets [-3]
    final templateId = 'tpl_offsets_${DateTime.now().millisecondsSinceEpoch}';
    await tplRepo.createTemplate(
        id: templateId, nombre: 'Offsets', monto: 10, hasInterest: false);
    await ruleRepo.replaceReminderRulesForTemplate(templateId, const [-3]);
    // occurrence inicial
    final due = DateTime.now().add(const Duration(days: 5));
    final occId = 'occ_off_${due.millisecondsSinceEpoch}';
    await occRepo.createOccurrence(
        id: occId, templateId: templateId, fechaDue: due, monto: 10);

    // Simular programación inicial
    await mock.scheduleOccurrenceReminder(
        occurrenceId: occId,
        title: 't',
        body: 'b',
        dueDateLocal: due,
        offsetDays: -3);

    // Editar: nuevos offsets [-5,-1,0]
    await ruleRepo
        .replaceReminderRulesForTemplate(templateId, const [-5, -1, 0]);
    // Cancelamos manualmente prev offset
    await mock.cancelOccurrenceReminders(occId, const [-3]);
    // Programamos nuevos
    for (final o in const [-5, -1, 0]) {
      await mock.scheduleOccurrenceReminder(
          occurrenceId: occId,
          title: 't2',
          body: 'b2',
          dueDateLocal: due,
          offsetDays: o);
    }

    expect(cancelled[occId]!.contains(-3), true);
    expect(
        scheduled[occId]!.toSet(),
        equals(const {-3, -5, -1, 0}
            .toSet())); // incluye histórico de programación
  });
}
