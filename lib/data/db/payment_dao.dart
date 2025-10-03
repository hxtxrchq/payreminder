import 'package:drift/drift.dart';
import '../db/app_database.dart';

part 'payment_dao.g.dart';

@DriftAccessor(tables: [Payments, Occurrences, DebtTemplates])
class PaymentDao extends DatabaseAccessor<AppDatabase> with _$PaymentDaoMixin {
  PaymentDao(AppDatabase db) : super(db);

  // CRUD Operations
  Future<String> insertPayment(PaymentsCompanion payment) async {
    await into(payments).insert(payment);
    return payment.id.value;
  }

  Future<Payment?> getPaymentById(String id) async {
    return await (select(payments)..where((p) => p.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<Payment>> getAllPayments() async {
    return await (select(payments)
          ..orderBy([(p) => OrderingTerm.desc(p.fechaPago)]))
        .get();
  }

  Future<bool> updatePayment(PaymentsCompanion payment) async {
    final result = await (update(payments)
          ..where((p) => p.id.equals(payment.id.value)))
        .write(payment);
    return result > 0;
  }

  Future<bool> deletePayment(String id) async {
    final result = await (delete(payments)..where((p) => p.id.equals(id))).go();
    return result > 0;
  }

  // Occurrence-specific operations
  Future<Payment?> getPaymentByOccurrence(String occurrenceId) async {
    return await (select(payments)
          ..where((p) => p.occurrenceId.equals(occurrenceId)))
        .getSingleOrNull();
  }

  Future<bool> deletePaymentByOccurrence(String occurrenceId) async {
    final result = await (delete(payments)
          ..where((p) => p.occurrenceId.equals(occurrenceId)))
        .go();
    return result > 0;
  }

  Future<bool> paymentExistsForOccurrence(String occurrenceId) async {
    final payment = await getPaymentByOccurrence(occurrenceId);
    return payment != null;
  }

  // Filter by date range
  Future<List<Payment>> getPaymentsByDateRange(
      DateTime startDate, DateTime endDate) async {
    final startTimestamp = _getStartOfDay(startDate).millisecondsSinceEpoch;
    final endTimestamp = _getEndOfDay(endDate).millisecondsSinceEpoch;

    return await (select(payments)
          ..where(
              (p) => p.fechaPago.isBetweenValues(startTimestamp, endTimestamp))
          ..orderBy([(p) => OrderingTerm.desc(p.fechaPago)]))
        .get();
  }

  Future<List<Payment>> getPaymentsForMonth(int year, int month) async {
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 0); // Last day of month
    return await getPaymentsByDateRange(startDate, endDate);
  }

  Future<List<Payment>> getPaymentsForToday() async {
    final today = DateTime.now();
    return await getPaymentsByDateRange(today, today);
  }

  Future<List<Payment>> getPaymentsForWeek(DateTime weekStart) async {
    final weekEnd = weekStart.add(const Duration(days: 6));
    return await getPaymentsByDateRange(weekStart, weekEnd);
  }

  Future<List<Payment>> getRecentPayments(int days) async {
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: days));
    return await getPaymentsByDateRange(startDate, endDate);
  }

  // Filter by amount range
  Future<List<Payment>> getPaymentsByAmountRange(
      double minAmount, double maxAmount) async {
    return await (select(payments)
          ..where((p) => p.montoPagado.isBetweenValues(minAmount, maxAmount))
          ..orderBy([(p) => OrderingTerm.desc(p.fechaPago)]))
        .get();
  }

  // Join operations
  Future<List<PaymentWithDetails>> getPaymentsWithDetails() async {
    final query = select(payments).join([
      innerJoin(occurrences, occurrences.id.equalsExp(payments.occurrenceId)),
      innerJoin(
          debtTemplates, debtTemplates.id.equalsExp(occurrences.templateId))
    ])
      ..orderBy([OrderingTerm.desc(payments.fechaPago)]);

    final result = await query.get();
    return result
        .map((row) => PaymentWithDetails(
              payment: row.readTable(payments),
              occurrence: row.readTable(occurrences),
              template: row.readTable(debtTemplates),
            ))
        .toList();
  }

  Future<PaymentWithDetails?> getPaymentWithDetailsById(String id) async {
    final query = select(payments).join([
      innerJoin(occurrences, occurrences.id.equalsExp(payments.occurrenceId)),
      innerJoin(
          debtTemplates, debtTemplates.id.equalsExp(occurrences.templateId))
    ])
      ..where(payments.id.equals(id));

    final result = await query.getSingleOrNull();
    if (result == null) return null;

    return PaymentWithDetails(
      payment: result.readTable(payments),
      occurrence: result.readTable(occurrences),
      template: result.readTable(debtTemplates),
    );
  }

  Future<List<PaymentWithDetails>> getPaymentsWithDetailsByDateRange(
      DateTime startDate, DateTime endDate) async {
    final startTimestamp = _getStartOfDay(startDate).millisecondsSinceEpoch;
    final endTimestamp = _getEndOfDay(endDate).millisecondsSinceEpoch;

    final query = select(payments).join([
      innerJoin(occurrences, occurrences.id.equalsExp(payments.occurrenceId)),
      innerJoin(
          debtTemplates, debtTemplates.id.equalsExp(occurrences.templateId))
    ])
      ..where(payments.fechaPago.isBetweenValues(startTimestamp, endTimestamp))
      ..orderBy([OrderingTerm.desc(payments.fechaPago)]);

    final result = await query.get();
    return result
        .map((row) => PaymentWithDetails(
              payment: row.readTable(payments),
              occurrence: row.readTable(occurrences),
              template: row.readTable(debtTemplates),
            ))
        .toList();
  }

  // Count payments associated to a given template via join on occurrences
  Future<int> getPaymentsCountByTemplateId(String templateId) async {
    final query = select(payments).join([
      innerJoin(occurrences, occurrences.id.equalsExp(payments.occurrenceId)),
    ])
      ..where(occurrences.templateId.equals(templateId));
    final result = await query.get();
    return result.length;
  }

  // Statistics
  Future<int> getPaymentCount() async {
    final countExp = payments.id.count();
    final query = selectOnly(payments)..addColumns([countExp]);
    final result = await query.getSingle();
    return result.read(countExp) ?? 0;
  }

  Future<double> getTotalPaidAmount() async {
    final sumExp = payments.montoPagado.sum();
    final query = selectOnly(payments)..addColumns([sumExp]);
    final result = await query.getSingle();
    return result.read(sumExp) ?? 0.0;
  }

  Future<double> getTotalPaidAmountByDateRange(
      DateTime startDate, DateTime endDate) async {
    final startTimestamp = _getStartOfDay(startDate).millisecondsSinceEpoch;
    final endTimestamp = _getEndOfDay(endDate).millisecondsSinceEpoch;

    final sumExp = payments.montoPagado.sum();
    final query = selectOnly(payments)
      ..addColumns([sumExp])
      ..where(payments.fechaPago.isBetweenValues(startTimestamp, endTimestamp));
    final result = await query.getSingle();
    return result.read(sumExp) ?? 0.0;
  }

  Future<double> getTotalPaidAmountForMonth(int year, int month) async {
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 0);
    return await getTotalPaidAmountByDateRange(startDate, endDate);
  }

  Future<double> getAveragePaymentAmount() async {
    final avgExp = payments.montoPagado.avg();
    final query = selectOnly(payments)..addColumns([avgExp]);
    final result = await query.getSingle();
    return result.read(avgExp) ?? 0.0;
  }

  Future<double> getMaxPaymentAmount() async {
    final maxExp = payments.montoPagado.max();
    final query = selectOnly(payments)..addColumns([maxExp]);
    final result = await query.getSingle();
    return result.read(maxExp) ?? 0.0;
  }

  Future<double> getMinPaymentAmount() async {
    final minExp = payments.montoPagado.min();
    final query = selectOnly(payments)..addColumns([minExp]);
    final result = await query.getSingle();
    return result.read(minExp) ?? 0.0;
  }

  // Watchers
  Stream<double> watchSumPaidBetween(DateTime startDate, DateTime endDate) {
    final start = _getStartOfDay(startDate).millisecondsSinceEpoch;
    final end = _getEndOfDay(endDate).millisecondsSinceEpoch;
    final sumExp = payments.montoPagado.sum();
    final query = selectOnly(payments)
      ..addColumns([sumExp])
      ..where(payments.fechaPago.isBetweenValues(start, end));
    return query.watchSingleOrNull().map((row) => row?.read(sumExp) ?? 0.0);
  }

  // Payment analytics
  Future<Map<String, double>> getPaymentsByTemplate() async {
    final query = select(payments).join([
      innerJoin(occurrences, occurrences.id.equalsExp(payments.occurrenceId)),
      innerJoin(
          debtTemplates, debtTemplates.id.equalsExp(occurrences.templateId))
    ]);

    final result = await query.get();
    final Map<String, double> paymentsByTemplate = {};

    for (final row in result) {
      final template = row.readTable(debtTemplates);
      final payment = row.readTable(payments);

      paymentsByTemplate[template.nombre] =
          (paymentsByTemplate[template.nombre] ?? 0.0) + payment.montoPagado;
    }

    return paymentsByTemplate;
  }

  Future<Map<int, double>> getMonthlyPaymentTotals(int year) async {
    final startDate = DateTime(year, 1, 1);
    final endDate = DateTime(year, 12, 31);
    final paymentsInYear = await getPaymentsByDateRange(startDate, endDate);

    final Map<int, double> monthlyTotals = {};

    for (final payment in paymentsInYear) {
      final paymentDate =
          DateTime.fromMillisecondsSinceEpoch(payment.fechaPago);
      final month = paymentDate.month;

      monthlyTotals[month] =
          (monthlyTotals[month] ?? 0.0) + payment.montoPagado;
    }

    return monthlyTotals;
  }

  // Bulk operations
  Future<void> insertPayments(List<PaymentsCompanion> paymentList) async {
    await batch((batch) {
      batch.insertAll(payments, paymentList);
    });
  }

  Future<int> deletePaymentsByDateRange(
      DateTime startDate, DateTime endDate) async {
    final startTimestamp = _getStartOfDay(startDate).millisecondsSinceEpoch;
    final endTimestamp = _getEndOfDay(endDate).millisecondsSinceEpoch;

    return await (delete(payments)
          ..where(
              (p) => p.fechaPago.isBetweenValues(startTimestamp, endTimestamp)))
        .go();
  }

  // Watch for real-time updates
  Stream<List<Payment>> watchAllPayments() {
    return (select(payments)..orderBy([(p) => OrderingTerm.desc(p.fechaPago)]))
        .watch();
  }

  Stream<Payment?> watchPayment(String id) {
    return (select(payments)..where((p) => p.id.equals(id)))
        .watchSingleOrNull();
  }

  Stream<Payment?> watchPaymentByOccurrence(String occurrenceId) {
    return (select(payments)..where((p) => p.occurrenceId.equals(occurrenceId)))
        .watchSingleOrNull();
  }

  Stream<List<PaymentWithDetails>> watchPaymentsWithDetails() {
    final query = select(payments).join([
      innerJoin(occurrences, occurrences.id.equalsExp(payments.occurrenceId)),
      innerJoin(
          debtTemplates, debtTemplates.id.equalsExp(occurrences.templateId))
    ])
      ..orderBy([OrderingTerm.desc(payments.fechaPago)]);

    return query.watch().map((rows) => rows
        .map((row) => PaymentWithDetails(
              payment: row.readTable(payments),
              occurrence: row.readTable(occurrences),
              template: row.readTable(debtTemplates),
            ))
        .toList());
  }

  // Helper methods
  DateTime _getStartOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  DateTime _getEndOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }
}

// Helper class for joined data
class PaymentWithDetails {
  final Payment payment;
  final Occurrence occurrence;
  final DebtTemplate template;

  PaymentWithDetails({
    required this.payment,
    required this.occurrence,
    required this.template,
  });

  String get templateName => template.nombre;
  DateTime get paymentDate =>
      DateTime.fromMillisecondsSinceEpoch(payment.fechaPago);
  DateTime get dueDate =>
      DateTime.fromMillisecondsSinceEpoch(occurrence.fechaDue);
  double get amountPaid => payment.montoPagado;
  double get originalAmount => occurrence.monto;
  bool get isPaidInFull => payment.montoPagado >= occurrence.monto;
  Duration get daysDifference => paymentDate.difference(dueDate);
  bool get isPaidLate => daysDifference.inDays > 0;
  bool get isPaidEarly => daysDifference.inDays < 0;
}
