import '../../../data/repos/occurrence_repository.dart';
import '../../../data/repos/payment_repository.dart';
import '../../../data/repos/template_repository.dart';
import 'update_occurrence_statuses_usecase.dart';
import '../../services/notifications/notification_service.dart';

class MarkPaidUseCase {
  final OccurrenceRepository _occurrenceRepository;
  final PaymentRepository _paymentRepository;
  final TemplateRepository _templateRepository;
  final UpdateOccurrenceStatusesUseCase _updateStatusesUseCase;
  final NotificationService _notificationService;

  MarkPaidUseCase(
    this._occurrenceRepository,
    this._paymentRepository,
    this._templateRepository,
    this._updateStatusesUseCase,
    this._notificationService,
  );

  Future<PaymentResult> execute({
    required String occurrenceId,
    double? amountPaid,
    DateTime? paymentDate,
    String? paymentMethod,
    String? notes,
  }) async {
    try {
      // Obtener la ocurrencia
      final occurrence =
          await _occurrenceRepository.getOccurrence(occurrenceId);
      if (occurrence == null) {
        return PaymentResult.error('Ocurrencia no encontrada');
      }

      // Validaciones de negocio
      final validationError = _validatePayment(occurrence);
      if (validationError != null) {
        return PaymentResult.error(validationError);
      }

      // Verificar si ya existe un pago
      final existingPayment =
          await _paymentRepository.getPaymentByOccurrence(occurrenceId);
      if (existingPayment != null) {
        return PaymentResult.error(
            'Ya existe un pago registrado para esta ocurrencia');
      }

      // Calcular monto a pagar
      final finalAmount = amountPaid ?? occurrence.monto;
      final finalPaymentDate = paymentDate ?? DateTime.now();

      // Validar monto
      if (finalAmount <= 0) {
        return PaymentResult.error('El monto del pago debe ser mayor a cero');
      }

      // Posible cálculo de interés/capital si la plantilla tiene interés
      final template =
          await _templateRepository.getTemplate(occurrence.templateId);
      double? interestPortion;
      double? principalPortion;
      double? newBalance;
      if (template != null && template.hasInterest) {
        final rate = (template.interestRateMonthly ?? 0) / 100.0;
        final balance = template.currentBalance ?? occurrence.monto;
        interestPortion = (balance * rate);
        if (interestPortion.isNaN || interestPortion.isInfinite) {
          interestPortion = 0;
        }
        principalPortion = (finalAmount - interestPortion);
        if (principalPortion < 0) principalPortion = 0;
        newBalance = balance - principalPortion;
        if (newBalance < 0) newBalance = 0;
      }

      // Crear el registro de pago
      final paymentId =
          'payment_${occurrenceId}_${DateTime.now().millisecondsSinceEpoch}';

      final createdPaymentId = await _paymentRepository.createPayment(
        id: paymentId,
        occurrenceId: occurrenceId,
        fechaPago: finalPaymentDate,
        montoPagado: finalAmount,
        interestPortion: interestPortion,
        principalPortion: principalPortion,
      );

      if (createdPaymentId.isEmpty) {
        return PaymentResult.error('Error creando el registro de pago');
      }

      // Actualizar el estado de la ocurrencia a PAID (no dependemos de defaults)
      final statusResult =
          await _updateStatusesUseCase.execute([occurrenceId], 'PAID');

      if (!statusResult.isSuccess) {
        // Si falla la actualización del estado, eliminar el pago creado
        await _paymentRepository.deletePayment(createdPaymentId);
        return PaymentResult.error(
            'Error actualizando el estado: ${statusResult.generalError}');
      }

      // Si hubo interés/capital, actualizar saldo en plantilla
      if (template != null && newBalance != null) {
        try {
          await _templateRepository.updateTemplate(
              id: template.id, currentBalance: newBalance);
        } catch (_) {}
      }

      // Cancelar notificaciones pendientes relacionadas con esta ocurrencia (si usas offsets conocidos)
      try {
        // Si manejas offsets configurados globalmente, cancélalos todos. Aquí usamos un set típico.
        await _notificationService.cancelOccurrenceReminders(
            occurrenceId, const [-7, -3, -1, 0, 1, 3, 7]);
      } catch (_) {}

      return PaymentResult.success(
        paymentId: createdPaymentId,
        occurrenceId: occurrenceId,
        amountPaid: finalAmount,
        paymentDate: finalPaymentDate,
        isPartialPayment: finalAmount < occurrence.monto,
        changeAmount: finalAmount - occurrence.monto,
      );
    } catch (e) {
      return PaymentResult.error('Error procesando el pago: $e');
    }
  }

  Future<BatchPaymentResult> markMultiplePaid({
    required List<String> occurrenceIds,
    DateTime? paymentDate,
    String? paymentMethod,
    String? notes,
  }) async {
    final List<PaymentResult> results = [];
    final List<String> successfulPayments = [];
    final List<String> failedPayments = [];

    for (final occurrenceId in occurrenceIds) {
      final result = await execute(
        occurrenceId: occurrenceId,
        paymentDate: paymentDate,
        paymentMethod: paymentMethod,
        notes: notes,
      );

      results.add(result);

      if (result.isSuccess) {
        successfulPayments.add(occurrenceId);
      } else {
        failedPayments.add(occurrenceId);
      }
    }

    return BatchPaymentResult(
      results: results,
      totalProcessed: occurrenceIds.length,
      successfulPayments: successfulPayments,
      failedPayments: failedPayments,
    );
  }

  Future<PaymentResult> markPaidWithCustomAmount({
    required String occurrenceId,
    required double customAmount,
    DateTime? paymentDate,
    String? notes,
  }) async {
    return await execute(
      occurrenceId: occurrenceId,
      amountPaid: customAmount,
      paymentDate: paymentDate,
      notes: notes,
    );
  }

  Future<PaymentResult> markPaidPartial({
    required String occurrenceId,
    required double partialAmount,
    DateTime? paymentDate,
    String? notes,
  }) async {
    final occurrence = await _occurrenceRepository.getOccurrence(occurrenceId);
    if (occurrence == null) {
      return PaymentResult.error('Ocurrencia no encontrada');
    }

    if (partialAmount >= occurrence.monto) {
      return PaymentResult.error('Para pago completo usa markPaid normal');
    }

    return await execute(
      occurrenceId: occurrenceId,
      amountPaid: partialAmount,
      paymentDate: paymentDate,
      notes: notes,
    );
  }

  // Método para casos específicos de sobrepago
  Future<PaymentResult> markPaidWithOverpayment({
    required String occurrenceId,
    required double overpaidAmount,
    DateTime? paymentDate,
    String? notes,
  }) async {
    final occurrence = await _occurrenceRepository.getOccurrence(occurrenceId);
    if (occurrence == null) {
      return PaymentResult.error('Ocurrencia no encontrada');
    }

    if (overpaidAmount <= occurrence.monto) {
      return PaymentResult.error(
          'Para pagos normales o parciales usa otros métodos');
    }

    return await execute(
      occurrenceId: occurrenceId,
      amountPaid: overpaidAmount,
      paymentDate: paymentDate,
      notes: notes,
    );
  }

  // Validaciones de negocio
  String? _validatePayment(dynamic occurrence) {
    if (occurrence.estado == 'PAID') {
      return 'La ocurrencia ya está marcada como pagada';
    }

    if (occurrence.estado == 'CANCELLED') {
      return 'No se puede pagar una ocurrencia cancelada';
    }

    // Validar que no sea muy antigua (opcional)
    final dueDate = DateTime.fromMillisecondsSinceEpoch(occurrence.fechaDue);
    final daysSinceDue = DateTime.now().difference(dueDate).inDays;

    if (daysSinceDue > 365) {
      return 'No se puede pagar una ocurrencia con más de un año de vencimiento';
    }

    return null;
  }

  // Métodos de consulta
  Future<PaymentSummary> getPaymentSummary(String occurrenceId) async {
    final occurrence = await _occurrenceRepository.getOccurrence(occurrenceId);
    final payment =
        await _paymentRepository.getPaymentByOccurrence(occurrenceId);

    if (occurrence == null) {
      throw Exception('Ocurrencia no encontrada');
    }

    return PaymentSummary(
      occurrenceId: occurrenceId,
      originalAmount: occurrence.monto,
      isPaid: occurrence.estado == 'PAID',
      paymentId: payment?.id,
      amountPaid: payment?.montoPagado,
      paymentDate: payment != null
          ? DateTime.fromMillisecondsSinceEpoch(payment.fechaPago)
          : null,
      isPartialPayment:
          payment != null && payment.montoPagado < occurrence.monto,
      isOverpayment: payment != null && payment.montoPagado > occurrence.monto,
    );
  }

  Future<List<PaymentSummary>> getPaymentsSummaryForOccurrences(
      List<String> occurrenceIds) async {
    final List<PaymentSummary> summaries = [];

    for (final occurrenceId in occurrenceIds) {
      try {
        final summary = await getPaymentSummary(occurrenceId);
        summaries.add(summary);
      } catch (e) {
        // Agregar summary con error para mantener la lista consistente
        summaries.add(PaymentSummary(
          occurrenceId: occurrenceId,
          originalAmount: 0.0,
          isPaid: false,
          hasError: true,
          errorMessage: e.toString(),
        ));
      }
    }

    return summaries;
  }

  // Métodos de análisis
  Future<PaymentAnalytics> getPaymentAnalytics({
    DateTime? fromDate,
    DateTime? toDate,
    String? templateId,
  }) async {
    final startDate =
        fromDate ?? DateTime.now().subtract(const Duration(days: 30));
    final endDate = toDate ?? DateTime.now();

    // Obtener todas las ocurrencias en el rango
    final occurrences = await _occurrenceRepository.getOccurrencesByDateRange(
        startDate, endDate);

    // Filtrar por plantilla si se especifica
    final filteredOccurrences = templateId != null
        ? occurrences.where((o) => o.templateId == templateId).toList()
        : occurrences;

    // Obtener pagos para estas ocurrencias - implementar método simple
    final occurrenceIds = filteredOccurrences.map((o) => o.id).toList();
    final List<dynamic> payments = [];
    for (final occurrenceId in occurrenceIds) {
      final payment =
          await _paymentRepository.getPaymentByOccurrence(occurrenceId);
      if (payment != null) {
        payments.add(payment);
      }
    }

    final paidOccurrences =
        filteredOccurrences.where((o) => o.estado == 'PAID').toList();
    final pendingOccurrences =
        filteredOccurrences.where((o) => o.estado == 'PENDING').toList();
    final overdueOccurrences =
        filteredOccurrences.where((o) => o.estado == 'OVERDUE').toList();

    final totalExpected =
        filteredOccurrences.fold<double>(0.0, (sum, o) => sum + o.monto);
    final totalPaid =
        payments.fold<double>(0.0, (sum, p) => sum + p.montoPagado);

    return PaymentAnalytics(
      totalOccurrences: filteredOccurrences.length,
      paidOccurrences: paidOccurrences.length,
      pendingOccurrences: pendingOccurrences.length,
      overdueOccurrences: overdueOccurrences.length,
      totalExpectedAmount: totalExpected,
      totalPaidAmount: totalPaid,
      paymentRate: filteredOccurrences.isNotEmpty
          ? (paidOccurrences.length / filteredOccurrences.length)
          : 0.0,
      averagePaymentAmount:
          payments.isNotEmpty ? (totalPaid / payments.length) : 0.0,
      partialPayments: payments.where((p) {
        final occurrence =
            filteredOccurrences.firstWhere((o) => o.id == p.occurrenceId);
        return p.montoPagado < occurrence.monto;
      }).length,
      overpayments: payments.where((p) {
        final occurrence =
            filteredOccurrences.firstWhere((o) => o.id == p.occurrenceId);
        return p.montoPagado > occurrence.monto;
      }).length,
    );
  }
}

class PaymentResult {
  final bool isSuccess;
  final String? paymentId;
  final String? occurrenceId;
  final double? amountPaid;
  final DateTime? paymentDate;
  final bool isPartialPayment;
  final double changeAmount;
  final String message;
  final String? error;

  PaymentResult._({
    required this.isSuccess,
    this.paymentId,
    this.occurrenceId,
    this.amountPaid,
    this.paymentDate,
    this.isPartialPayment = false,
    this.changeAmount = 0.0,
    required this.message,
    this.error,
  });

  factory PaymentResult.success({
    required String paymentId,
    required String occurrenceId,
    required double amountPaid,
    required DateTime paymentDate,
    bool isPartialPayment = false,
    double changeAmount = 0.0,
  }) {
    return PaymentResult._(
      isSuccess: true,
      paymentId: paymentId,
      occurrenceId: occurrenceId,
      amountPaid: amountPaid,
      paymentDate: paymentDate,
      isPartialPayment: isPartialPayment,
      changeAmount: changeAmount,
      message: 'Pago registrado exitosamente',
    );
  }

  factory PaymentResult.error(String error) {
    return PaymentResult._(
      isSuccess: false,
      message: error,
      error: error,
    );
  }
}

class BatchPaymentResult {
  final List<PaymentResult> results;
  final int totalProcessed;
  final List<String> successfulPayments;
  final List<String> failedPayments;

  BatchPaymentResult({
    required this.results,
    required this.totalProcessed,
    required this.successfulPayments,
    required this.failedPayments,
  });

  int get successCount => successfulPayments.length;
  int get failureCount => failedPayments.length;
  double get successRate =>
      totalProcessed > 0 ? (successCount / totalProcessed) : 0.0;
  bool get hasFailures => failedPayments.isNotEmpty;
}

class PaymentSummary {
  final String occurrenceId;
  final double originalAmount;
  final bool isPaid;
  final String? paymentId;
  final double? amountPaid;
  final DateTime? paymentDate;
  final bool isPartialPayment;
  final bool isOverpayment;
  final bool hasError;
  final String? errorMessage;

  PaymentSummary({
    required this.occurrenceId,
    required this.originalAmount,
    required this.isPaid,
    this.paymentId,
    this.amountPaid,
    this.paymentDate,
    this.isPartialPayment = false,
    this.isOverpayment = false,
    this.hasError = false,
    this.errorMessage,
  });

  double get remainingAmount => isPartialPayment && amountPaid != null
      ? originalAmount - amountPaid!
      : 0.0;

  double get overpaidAmount =>
      isOverpayment && amountPaid != null ? amountPaid! - originalAmount : 0.0;
}

class PaymentAnalytics {
  final int totalOccurrences;
  final int paidOccurrences;
  final int pendingOccurrences;
  final int overdueOccurrences;
  final double totalExpectedAmount;
  final double totalPaidAmount;
  final double paymentRate;
  final double averagePaymentAmount;
  final int partialPayments;
  final int overpayments;

  PaymentAnalytics({
    required this.totalOccurrences,
    required this.paidOccurrences,
    required this.pendingOccurrences,
    required this.overdueOccurrences,
    required this.totalExpectedAmount,
    required this.totalPaidAmount,
    required this.paymentRate,
    required this.averagePaymentAmount,
    required this.partialPayments,
    required this.overpayments,
  });

  double get collectionRate =>
      totalExpectedAmount > 0 ? (totalPaidAmount / totalExpectedAmount) : 0.0;
  double get pendingAmount => totalExpectedAmount - totalPaidAmount;
}
