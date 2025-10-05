import 'package:flutter_test/flutter_test.dart';
import 'package:payreminderapp/logic/providers/repository_providers.dart';
import 'package:payreminderapp/domain/usecases/save_debt_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'test_utils.dart';
import 'package:payreminderapp/logic/providers/settings_providers.dart';

// Nota: Este esqueleto asume existencia de un AppDatabase in-memory provider para tests.
// Si no existe, habría que crear uno. Aquí simplificamos y sólo verificamos lógica básica
// a través de repositorios reales sobre la DB existente.

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Recurrencia mensual incluye HOY cuando startDate == hoy', () async {
    final container = ProviderContainer(overrides: [
      settingsProvider
          .overrideWith((ref) => SettingsNotifier(ref, skipLoad: true)),
      ...inMemoryDbOverride()
    ]);
    addTearDown(container.dispose);
    final today = DateTime.now();

    final saveUc = SaveDebtUseCase(container);

    final templateName = 'Test Mensual';

    final result = await saveUc.save(
      basic: DebtBasicData(nombre: templateName, monto: 100),
      type: DebtType.recurrent,
      recurrence: RecurrenceData(
        tipo: 'MONTHLY_BY_DOM',
        diaMes: today.day,
        fechaInicio: today,
      ),
      offsets: const [-3],
    );

    expect(result.templateId.isNotEmpty, true);

    final occRepo = container.read(occurrenceRepositoryProvider);
    final occs = await occRepo.getOccurrencesByTemplate(result.templateId);
    expect(occs.isNotEmpty, true);

    final hasToday = occs.any((o) {
      final d = DateTime.fromMillisecondsSinceEpoch(o.fechaDue);
      return d.year == today.year &&
          d.month == today.month &&
          d.day == today.day;
    });
    expect(hasToday, true, reason: 'Debe existir occurrence para HOY');
  });
}
