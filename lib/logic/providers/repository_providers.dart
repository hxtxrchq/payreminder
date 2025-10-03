import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repos/card_repository.dart';
import '../../data/repos/template_repository.dart';
import '../../data/repos/recurrence_repository.dart';
import '../../data/repos/occurrence_repository.dart';
import '../../data/repos/reminder_rule_repository.dart';
import '../../data/repos/payment_repository.dart';
import '../../data/repository/payment_method_repository.dart';
import 'database_providers.dart';

// Providers para los repositorios
final cardRepositoryProvider = Provider<CardRepository>((ref) {
  final cardDao = ref.watch(cardDaoProvider);
  return CardRepository(cardDao);
});

final templateRepositoryProvider = Provider<TemplateRepository>((ref) {
  final templateDao = ref.watch(templateDaoProvider);
  return TemplateRepository(templateDao);
});

final recurrenceRepositoryProvider = Provider<RecurrenceRepository>((ref) {
  final recurrenceDao = ref.watch(recurrenceDaoProvider);
  return RecurrenceRepository(recurrenceDao);
});

final occurrenceRepositoryProvider = Provider<OccurrenceRepository>((ref) {
  final occurrenceDao = ref.watch(occurrenceDaoProvider);
  return OccurrenceRepository(occurrenceDao);
});

final reminderRuleRepositoryProvider = Provider<ReminderRuleRepository>((ref) {
  final reminderRuleDao = ref.watch(reminderRuleDaoProvider);
  return ReminderRuleRepository(reminderRuleDao);
});

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  final paymentDao = ref.watch(paymentDaoProvider);
  return PaymentRepository(paymentDao);
});

final paymentMethodRepositoryProvider =
    Provider<PaymentMethodRepository>((ref) {
  final dao = ref.watch(paymentMethodDaoProvider);
  return PaymentMethodRepository(dao);
});
