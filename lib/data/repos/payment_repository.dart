import 'package:drift/drift.dart';
import '../../app/formatters/money.dart';
import '../db/app_database.dart';
import '../db/payment_dao.dart';

class PaymentRepository {
  final PaymentDao _paymentDao;

  PaymentRepository(this._paymentDao);

  // Basic CRUD operations
  Future<String> createPayment({
    required String id,
    required String occurrenceId,
    required DateTime fechaPago,
    required double montoPagado,
    String? paymentMethodId,
    double? interestPortion,
    double? principalPortion,
  }) async {
    final payment = PaymentsCompanion(
      id: Value(id),
      occurrenceId: Value(occurrenceId),
      fechaPago: Value(fechaPago.millisecondsSinceEpoch),
      montoPagado: Value(montoPagado),
      paymentMethodId: Value(paymentMethodId),
      interestPortion: interestPortion != null
          ? Value(interestPortion)
          : const Value.absent(),
      principalPortion: principalPortion != null
          ? Value(principalPortion)
          : const Value.absent(),
    );
    return await _paymentDao.insertPayment(payment);
  }

  Future<Payment?> getPayment(String id) async {
    return await _paymentDao.getPaymentById(id);
  }

  Future<PaymentWithDetails?> getPaymentWithDetails(String id) async {
    return await _paymentDao.getPaymentWithDetailsById(id);
  }

  Future<List<Payment>> getAllPayments() async {
    return await _paymentDao.getAllPayments();
  }

  Future<List<PaymentWithDetails>> getPaymentsWithDetails() async {
    return await _paymentDao.getPaymentsWithDetails();
  }

  Future<bool> updatePayment({
    required String id,
    String? occurrenceId,
    DateTime? fechaPago,
    double? montoPagado,
    String? paymentMethodId,
    double? interestPortion,
    double? principalPortion,
  }) async {
    final updates = PaymentsCompanion(
      id: Value(id),
      occurrenceId: occurrenceId != null ? Value(occurrenceId) : Value.absent(),
      fechaPago: fechaPago != null
          ? Value(fechaPago.millisecondsSinceEpoch)
          : Value.absent(),
      montoPagado: montoPagado != null ? Value(montoPagado) : Value.absent(),
      paymentMethodId: paymentMethodId != null
          ? Value(paymentMethodId)
          : const Value.absent(),
      interestPortion: interestPortion != null
          ? Value(interestPortion)
          : const Value.absent(),
      principalPortion: principalPortion != null
          ? Value(principalPortion)
          : const Value.absent(),
    );
    return await _paymentDao.updatePayment(updates);
  }

  Future<bool> deletePayment(String id) async {
    return await _paymentDao.deletePayment(id);
  }

  // Occurrence-specific operations
  Future<Payment?> getPaymentByOccurrence(String occurrenceId) async {
    return await _paymentDao.getPaymentByOccurrence(occurrenceId);
  }

  Future<bool> deletePaymentByOccurrence(String occurrenceId) async {
    return await _paymentDao.deletePaymentByOccurrence(occurrenceId);
  }

  Future<bool> paymentExistsForOccurrence(String occurrenceId) async {
    return await _paymentDao.paymentExistsForOccurrence(occurrenceId);
  }

  // Date-based queries
  Future<List<Payment>> getPaymentsByDateRange(
      DateTime startDate, DateTime endDate) async {
    return await _paymentDao.getPaymentsByDateRange(startDate, endDate);
  }

  Future<List<PaymentWithDetails>> getPaymentsWithDetailsByDateRange(
      DateTime startDate, DateTime endDate) async {
    return await _paymentDao.getPaymentsWithDetailsByDateRange(
        startDate, endDate);
  }

  Future<List<Payment>> getPaymentsForMonth(int year, int month) async {
    return await _paymentDao.getPaymentsForMonth(year, month);
  }

  Future<List<Payment>> getPaymentsForToday() async {
    return await _paymentDao.getPaymentsForToday();
  }

  Future<List<Payment>> getPaymentsForWeek(DateTime weekStart) async {
    return await _paymentDao.getPaymentsForWeek(weekStart);
  }

  Future<List<Payment>> getRecentPayments(int days) async {
    return await _paymentDao.getRecentPayments(days);
  }

  // Amount-based queries
  Future<List<Payment>> getPaymentsByAmountRange(
      double minAmount, double maxAmount) async {
    return await _paymentDao.getPaymentsByAmountRange(minAmount, maxAmount);
  }

  // Statistics
  Future<int> getPaymentCount() async {
    return await _paymentDao.getPaymentCount();
  }

  Future<double> getTotalPaidAmount() async {
    return await _paymentDao.getTotalPaidAmount();
  }

  Future<double> getTotalPaidAmountByDateRange(
      DateTime startDate, DateTime endDate) async {
    return await _paymentDao.getTotalPaidAmountByDateRange(startDate, endDate);
  }

  Future<double> getTotalPaidAmountForMonth(int year, int month) async {
    return await _paymentDao.getTotalPaidAmountForMonth(year, month);
  }

  Future<double> getAveragePaymentAmount() async {
    return await _paymentDao.getAveragePaymentAmount();
  }

  Future<double> getMaxPaymentAmount() async {
    return await _paymentDao.getMaxPaymentAmount();
  }

  // Business helper: count payments linked to a template (via occurrences)
  Future<int> hasPayments(String templateId) async {
    return await _paymentDao.getPaymentsCountByTemplateId(templateId);
  }

  // Watchers for sums in date range
  Stream<double> watchSumPaidBetween(DateTime start, DateTime end) {
    return _paymentDao.watchSumPaidBetween(start, end);
  }

  // Analytics
  Future<Map<String, double>> getPaymentsByTemplate() async {
    return await _paymentDao.getPaymentsByTemplate();
  }

  Future<Map<int, double>> getMonthlyPaymentTotals(int year) async {
    return await _paymentDao.getMonthlyPaymentTotals(year);
  }

  Future<List<PaymentSummary>> getPaymentSummaryByMonth(int year) async {
    final monthlyTotals = await getMonthlyPaymentTotals(year);
    final List<PaymentSummary> summaries = [];

    for (int month = 1; month <= 12; month++) {
      final total = monthlyTotals[month] ?? 0.0;
      final payments = await getPaymentsForMonth(year, month);

      summaries.add(PaymentSummary(
        year: year,
        month: month,
        totalAmount: total,
        paymentCount: payments.length,
      ));
    }

    return summaries;
  }

  Future<PaymentStats> getPaymentStats(
      {DateTime? startDate, DateTime? endDate}) async {
    List<Payment> payments;

    if (startDate != null && endDate != null) {
      payments = await getPaymentsByDateRange(startDate, endDate);
    } else {
      payments = await getAllPayments();
    }

    if (payments.isEmpty) {
      return PaymentStats(
        totalPayments: 0,
        totalAmount: 0.0,
        averageAmount: 0.0,
        minAmount: 0.0,
        maxAmount: 0.0,
      );
    }

    final totalAmount =
        payments.fold<double>(0.0, (sum, payment) => sum + payment.montoPagado);
    final averageAmount = totalAmount / payments.length;
    final minAmount =
        payments.map((p) => p.montoPagado).reduce((a, b) => a < b ? a : b);
    final maxAmount =
        payments.map((p) => p.montoPagado).reduce((a, b) => a > b ? a : b);

    return PaymentStats(
      totalPayments: payments.length,
      totalAmount: totalAmount,
      averageAmount: averageAmount,
      minAmount: minAmount,
      maxAmount: maxAmount,
    );
  }

  // Bulk operations
  Future<void> createPayments(List<PaymentData> paymentsData) async {
    final companions = paymentsData
        .map((data) => PaymentsCompanion(
              id: Value(data.id),
              occurrenceId: Value(data.occurrenceId),
              fechaPago: Value(data.fechaPago.millisecondsSinceEpoch),
              montoPagado: Value(data.montoPagado),
            ))
        .toList();

    await _paymentDao.insertPayments(companions);
  }

  Future<int> deletePaymentsByDateRange(
      DateTime startDate, DateTime endDate) async {
    return await _paymentDao.deletePaymentsByDateRange(startDate, endDate);
  }

  // Stream operations for real-time updates
  Stream<List<Payment>> watchAllPayments() {
    return _paymentDao.watchAllPayments();
  }

  Stream<Payment?> watchPayment(String id) {
    return _paymentDao.watchPayment(id);
  }

  Stream<Payment?> watchPaymentByOccurrence(String occurrenceId) {
    return _paymentDao.watchPaymentByOccurrence(occurrenceId);
  }

  Stream<List<PaymentWithDetails>> watchPaymentsWithDetails() {
    return _paymentDao.watchPaymentsWithDetails();
  }

  // Validation methods
  String? validateAmount(String? amountText) {
    if (amountText == null || amountText.trim().isEmpty) {
      return 'El monto es requerido';
    }

    final amount = double.tryParse(amountText.trim());
    if (amount == null) {
      return 'Ingrese un monto válido';
    }

    if (amount <= 0) {
      return 'El monto debe ser mayor a 0';
    }

    if (amount > 999999.99) {
      return 'El monto no puede exceder 999,999.99';
    }

    return null;
  }

  String? validatePaymentDate(DateTime? date) {
    if (date == null) {
      return 'La fecha de pago es requerida';
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final paymentDate = DateTime(date.year, date.month, date.day);

    if (paymentDate.isAfter(today)) {
      return 'La fecha de pago no puede ser futura';
    }

    final oneYearAgo = today.subtract(const Duration(days: 365));
    if (paymentDate.isBefore(oneYearAgo)) {
      return 'La fecha de pago no puede ser mayor a 1 año atrás';
    }

    return null;
  }

  // Utility methods
  Future<bool> canDeletePayment(String id) async {
    final payment = await getPayment(id);
    return payment != null;
  }

  String formatAmount(double amount) {
    return formatMoney(amount);
  }

  String formatPaymentDate(DateTime date) {
    final months = [
      '',
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];

    return '${date.day} de ${months[date.month]} de ${date.year}';
  }
}

// Helper classes
class PaymentData {
  final String id;
  final String occurrenceId;
  final DateTime fechaPago;
  final double montoPagado;

  PaymentData({
    required this.id,
    required this.occurrenceId,
    required this.fechaPago,
    required this.montoPagado,
  });
}

class PaymentSummary {
  final int year;
  final int month;
  final double totalAmount;
  final int paymentCount;

  PaymentSummary({
    required this.year,
    required this.month,
    required this.totalAmount,
    required this.paymentCount,
  });

  String get monthName {
    const months = [
      '',
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];
    return months[month];
  }
}

class PaymentStats {
  final int totalPayments;
  final double totalAmount;
  final double averageAmount;
  final double minAmount;
  final double maxAmount;

  PaymentStats({
    required this.totalPayments,
    required this.totalAmount,
    required this.averageAmount,
    required this.minAmount,
    required this.maxAmount,
  });
}
