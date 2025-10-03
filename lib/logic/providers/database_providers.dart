import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/db/app_database.dart';
import '../../data/db/card_dao.dart';
import '../../data/db/template_dao.dart';
import '../../data/db/recurrence_dao.dart';
import '../../data/db/occurrence_dao.dart';
import '../../data/db/reminder_rule_dao.dart';
import '../../data/db/payment_dao.dart';
import '../../data/db/payment_method_dao.dart';

// Provider para la base de datos
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

// Providers para los DAOs
final cardDaoProvider = Provider<CardDao>((ref) {
  final database = ref.watch(databaseProvider);
  return CardDao(database);
});

final templateDaoProvider = Provider<TemplateDao>((ref) {
  final database = ref.watch(databaseProvider);
  return TemplateDao(database);
});

final recurrenceDaoProvider = Provider<RecurrenceDao>((ref) {
  final database = ref.watch(databaseProvider);
  return RecurrenceDao(database);
});

final occurrenceDaoProvider = Provider<OccurrenceDao>((ref) {
  final database = ref.watch(databaseProvider);
  return OccurrenceDao(database);
});

final reminderRuleDaoProvider = Provider<ReminderRuleDao>((ref) {
  final database = ref.watch(databaseProvider);
  return ReminderRuleDao(database);
});

final paymentDaoProvider = Provider<PaymentDao>((ref) {
  final database = ref.watch(databaseProvider);
  return PaymentDao(database);
});

final paymentMethodDaoProvider = Provider<PaymentMethodDao>((ref) {
  final database = ref.watch(databaseProvider);
  return PaymentMethodDao(database);
});
