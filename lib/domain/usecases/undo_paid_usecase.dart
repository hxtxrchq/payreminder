import '../../../data/repos/occurrence_repository.dart';
import '../../../data/repos/payment_repository.dart';
import 'update_occurrence_statuses_usecase.dart';

class UndoPaidUseCase {
  final OccurrenceRepository _occurrenceRepository;
  final PaymentRepository _paymentRepository;
  final UpdateOccurrenceStatusesUseCase _updateStatusesUseCase;

  UndoPaidUseCase(
    this._occurrenceRepository,
    this._paymentRepository,
    this._updateStatusesUseCase,
  );

  Future<UndoPaymentResult> execute(String occurrenceId, {String? reason}) async {
    try {
      // Obtener la ocurrencia
      final occurrence = await _occurrenceRepository.getOccurrence(occurrenceId);
      if (occurrence == null) {
        return UndoPaymentResult.error('Ocurrencia no encontrada');
      }

      // Validar que esté pagada
      if (occurrence.estado != 'PAID') {
        return UndoPaymentResult.error('La ocurrencia no está marcada como pagada');
      }

      // Obtener el registro de pago
      final payment = await _paymentRepository.getPaymentByOccurrence(occurrenceId);
      if (payment == null) {
        return UndoPaymentResult.error('No se encontró el registro de pago');
      }

      // Validaciones de negocio
      final validationError = _validateUndoPayment(payment);
      if (validationError != null) {
        return UndoPaymentResult.error(validationError);
      }

      // Determinar el nuevo estado basado en la fecha de vencimiento
      final now = DateTime.now();
      final dueDate = DateTime.fromMillisecondsSinceEpoch(occurrence.fechaDue);
      final newStatus = now.isAfter(dueDate) ? 'OVERDUE' : 'PENDING';

      // Eliminar el registro de pago
      final paymentDeleted = await _paymentRepository.deletePayment(payment.id);
      if (!paymentDeleted) {
        return UndoPaymentResult.error('Error eliminando el registro de pago');
      }

      // Actualizar el estado de la ocurrencia
      final statusResult = await _updateStatusesUseCase.execute([occurrenceId], newStatus);
      
      if (!statusResult.isSuccess) {
        // Si falla la actualización del estado, intentar restaurar el pago
        await _attemptRestorePayment(payment);
        return UndoPaymentResult.error('Error actualizando el estado: ${statusResult.generalError}');
      }

      return UndoPaymentResult.success(
        occurrenceId: occurrenceId,
        previousPaymentId: payment.id,
        refundedAmount: payment.montoPagado,
        newStatus: newStatus,
        reason: reason,
      );

    } catch (e) {
      return UndoPaymentResult.error('Error deshaciendo el pago: $e');
    }
  }

  Future<BatchUndoResult> undoMultiplePayments({
    required List<String> occurrenceIds,
    String? reason,
  }) async {
    final List<UndoPaymentResult> results = [];
    final List<String> successfulUndos = [];
    final List<String> failedUndos = [];

    for (final occurrenceId in occurrenceIds) {
      final result = await execute(occurrenceId, reason: reason);
      results.add(result);

      if (result.isSuccess) {
        successfulUndos.add(occurrenceId);
      } else {
        failedUndos.add(occurrenceId);
      }
    }

    return BatchUndoResult(
      results: results,
      totalProcessed: occurrenceIds.length,
      successfulUndos: successfulUndos,
      failedUndos: failedUndos,
    );
  }

  Future<UndoPaymentResult> undoPaymentWithRefund({
    required String occurrenceId,
    required String refundMethod,
    String? refundReference,
    String? reason,
  }) async {
    final result = await execute(occurrenceId, reason: reason);
    
    if (result.isSuccess) {
      // Aquí se podría integrar con un sistema de reembolsos
      return UndoPaymentResult.success(
        occurrenceId: result.occurrenceId!,
        previousPaymentId: result.previousPaymentId!,
        refundedAmount: result.refundedAmount!,
        newStatus: result.newStatus!,
        reason: reason,
        refundMethod: refundMethod,
        refundReference: refundReference,
      );
    }

    return result;
  }

  Future<UndoPaymentResult> undoRecentPayment(String occurrenceId, {
    Duration maxAge = const Duration(hours: 24),
    String? reason,
  }) async {
    try {
      // Obtener el pago para verificar cuándo se hizo
      final payment = await _paymentRepository.getPaymentByOccurrence(occurrenceId);
      if (payment == null) {
        return UndoPaymentResult.error('No se encontró el registro de pago');
      }

      final paymentDate = DateTime.fromMillisecondsSinceEpoch(payment.fechaPago);
      final timeSincePayment = DateTime.now().difference(paymentDate);

      if (timeSincePayment > maxAge) {
        return UndoPaymentResult.error(
          'No se puede deshacer un pago después de ${maxAge.inHours} horas'
        );
      }

      return await execute(occurrenceId, reason: reason ?? 'Deshacer pago reciente');

    } catch (e) {
      return UndoPaymentResult.error('Error verificando el pago reciente: $e');
    }
  }

  // Validaciones de negocio
  String? _validateUndoPayment(dynamic payment) {
    final paymentDate = DateTime.fromMillisecondsSinceEpoch(payment.fechaPago);
    final daysSincePayment = DateTime.now().difference(paymentDate).inDays;

    // Validar que no sea muy antiguo
    if (daysSincePayment > 90) {
      return 'No se puede deshacer un pago con más de 90 días de antigüedad';
    }

    // Validar horario de negocio (opcional)
    final now = DateTime.now();
    if (now.hour < 6 || now.hour > 22) {
      return 'Los pagos solo se pueden deshacer en horario de 6:00 AM a 10:00 PM';
    }

    return null;
  }

  // Método para intentar restaurar un pago si falla la actualización de estado
  Future<void> _attemptRestorePayment(dynamic originalPayment) async {
    try {
      await _paymentRepository.createPayment(
        id: '${originalPayment.id}_restored',
        occurrenceId: originalPayment.occurrenceId,
        fechaPago: DateTime.fromMillisecondsSinceEpoch(originalPayment.fechaPago),
        montoPagado: originalPayment.montoPagado,
      );
    } catch (e) {
      // Log error but don't throw - this is a recovery attempt
      print('Error restaurando pago: $e');
    }
  }

  // Métodos de consulta y análisis
  Future<UndoEligibility> checkUndoEligibility(String occurrenceId) async {
    try {
      final occurrence = await _occurrenceRepository.getOccurrence(occurrenceId);
      if (occurrence == null) {
        return UndoEligibility(
          isEligible: false,
          reason: 'Ocurrencia no encontrada',
        );
      }

      if (occurrence.estado != 'PAID') {
        return UndoEligibility(
          isEligible: false,
          reason: 'La ocurrencia no está pagada',
        );
      }

      final payment = await _paymentRepository.getPaymentByOccurrence(occurrenceId);
      if (payment == null) {
        return UndoEligibility(
          isEligible: false,
          reason: 'No se encontró el registro de pago',
        );
      }

      final validationError = _validateUndoPayment(payment);
      if (validationError != null) {
        return UndoEligibility(
          isEligible: false,
          reason: validationError,
        );
      }

      final paymentDate = DateTime.fromMillisecondsSinceEpoch(payment.fechaPago);
      final timeSincePayment = DateTime.now().difference(paymentDate);

      return UndoEligibility(
        isEligible: true,
        reason: 'Elegible para deshacer',
        paymentId: payment.id,
        paymentDate: paymentDate,
        timeSincePayment: timeSincePayment,
        refundableAmount: payment.montoPagado,
      );

    } catch (e) {
      return UndoEligibility(
        isEligible: false,
        reason: 'Error verificando eligibilidad: $e',
      );
    }
  }

  Future<List<UndoEligibility>> checkMultipleUndoEligibility(List<String> occurrenceIds) async {
    final List<UndoEligibility> results = [];

    for (final occurrenceId in occurrenceIds) {
      final eligibility = await checkUndoEligibility(occurrenceId);
      results.add(eligibility);
    }

    return results;
  }

  Future<UndoAnalytics> getUndoAnalytics({
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    // En una implementación real, se guardarian los undos en una tabla de auditoría
    final paidOccurrences = await _occurrenceRepository.getOccurrencesByStatus('PAID');
    final totalPayments = paidOccurrences.length;

    // Simular algunas estadísticas básicas
    return UndoAnalytics(
      totalPayments: totalPayments,
      eligibleForUndo: (totalPayments * 0.8).round(), // 80% elegibles estimado
      undosPerformed: 0, // Requiere tabla de auditoría
      averageUndoTime: const Duration(hours: 2), // Promedio estimado
      mostCommonUndoReason: 'Error en el monto',
    );
  }
}

class UndoPaymentResult {
  final bool isSuccess;
  final String? occurrenceId;
  final String? previousPaymentId;
  final double? refundedAmount;
  final String? newStatus;
  final String? reason;
  final String? refundMethod;
  final String? refundReference;
  final String message;
  final String? error;

  UndoPaymentResult._({
    required this.isSuccess,
    this.occurrenceId,
    this.previousPaymentId,
    this.refundedAmount,
    this.newStatus,
    this.reason,
    this.refundMethod,
    this.refundReference,
    required this.message,
    this.error,
  });

  factory UndoPaymentResult.success({
    required String occurrenceId,
    required String previousPaymentId,
    required double refundedAmount,
    required String newStatus,
    String? reason,
    String? refundMethod,
    String? refundReference,
  }) {
    return UndoPaymentResult._(
      isSuccess: true,
      occurrenceId: occurrenceId,
      previousPaymentId: previousPaymentId,
      refundedAmount: refundedAmount,
      newStatus: newStatus,
      reason: reason,
      refundMethod: refundMethod,
      refundReference: refundReference,
      message: 'Pago deshecho exitosamente',
    );
  }

  factory UndoPaymentResult.error(String error) {
    return UndoPaymentResult._(
      isSuccess: false,
      message: error,
      error: error,
    );
  }
}

class BatchUndoResult {
  final List<UndoPaymentResult> results;
  final int totalProcessed;
  final List<String> successfulUndos;
  final List<String> failedUndos;

  BatchUndoResult({
    required this.results,
    required this.totalProcessed,
    required this.successfulUndos,
    required this.failedUndos,
  });

  int get successCount => successfulUndos.length;
  int get failureCount => failedUndos.length;
  double get successRate => totalProcessed > 0 ? (successCount / totalProcessed) : 0.0;
  bool get hasFailures => failedUndos.isNotEmpty;
  
  double get totalRefundedAmount => results
      .where((r) => r.isSuccess && r.refundedAmount != null)
      .fold<double>(0.0, (sum, r) => sum + r.refundedAmount!);
}

class UndoEligibility {
  final bool isEligible;
  final String reason;
  final String? paymentId;
  final DateTime? paymentDate;
  final Duration? timeSincePayment;
  final double? refundableAmount;

  UndoEligibility({
    required this.isEligible,
    required this.reason,
    this.paymentId,
    this.paymentDate,
    this.timeSincePayment,
    this.refundableAmount,
  });

  bool get isRecentPayment => timeSincePayment != null && timeSincePayment!.inHours < 24;
  bool get requiresApproval => refundableAmount != null && refundableAmount! > 1000.0;
}

class UndoAnalytics {
  final int totalPayments;
  final int eligibleForUndo;
  final int undosPerformed;
  final Duration averageUndoTime;
  final String mostCommonUndoReason;

  UndoAnalytics({
    required this.totalPayments,
    required this.eligibleForUndo,
    required this.undosPerformed,
    required this.averageUndoTime,
    required this.mostCommonUndoReason,
  });

  double get undoRate => totalPayments > 0 ? (undosPerformed / totalPayments) : 0.0;
  double get eligibilityRate => totalPayments > 0 ? (eligibleForUndo / totalPayments) : 0.0;
}