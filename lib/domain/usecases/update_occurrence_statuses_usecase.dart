import '../../../data/repos/occurrence_repository.dart';
import '../../../data/repos/payment_repository.dart';

class UpdateOccurrenceStatusesUseCase {
  final OccurrenceRepository _occurrenceRepository;
  final PaymentRepository _paymentRepository;

  UpdateOccurrenceStatusesUseCase(
    this._occurrenceRepository,
    this._paymentRepository,
  );

  Future<UpdateStatusResult> execute(
    List<String> occurrenceIds, 
    String newStatus, {
    String? reason,
  }) async {
    try {
      // Validar el estado
      final validationError = _validateStatus(newStatus);
      if (validationError != null) {
        return UpdateStatusResult.error(validationError);
      }

      final List<String> successfulUpdates = [];
      final List<StatusUpdateError> errors = [];

      for (final occurrenceId in occurrenceIds) {
        try {
          // Obtener la ocurrencia actual
          final occurrence = await _occurrenceRepository.getOccurrence(occurrenceId);
          if (occurrence == null) {
            errors.add(StatusUpdateError(
              occurrenceId: occurrenceId,
              error: 'Ocurrencia no encontrada',
            ));
            continue;
          }

          // Validar transición de estado
          final transitionError = _validateStatusTransition(occurrence.estado, newStatus);
          if (transitionError != null) {
            errors.add(StatusUpdateError(
              occurrenceId: occurrenceId,
              error: transitionError,
            ));
            continue;
          }

          // Actualizar el estado
          final success = await _occurrenceRepository.updateOccurrenceStatus(occurrenceId, newStatus);

          if (success) {
            successfulUpdates.add(occurrenceId);
          } else {
            errors.add(StatusUpdateError(
              occurrenceId: occurrenceId,
              error: 'Error actualizando en la base de datos',
            ));
          }

        } catch (e) {
          errors.add(StatusUpdateError(
            occurrenceId: occurrenceId,
            error: 'Error inesperado: $e',
          ));
        }
      }

      return UpdateStatusResult(
        successfulUpdates: successfulUpdates,
        errors: errors,
        totalProcessed: occurrenceIds.length,
      );

    } catch (e) {
      return UpdateStatusResult.error('Error general: $e');
    }
  }

  Future<UpdateStatusResult> markAsPaid(
    String occurrenceId, {
    double? paidAmount,
    DateTime? paidDate,
    String? paymentMethod,
    String? notes,
  }) async {
    try {
      final occurrence = await _occurrenceRepository.getOccurrence(occurrenceId);
      if (occurrence == null) {
        return UpdateStatusResult.error('Ocurrencia no encontrada');
      }

      // Validar que se pueda marcar como pagado
      if (occurrence.estado == 'PAID') {
        return UpdateStatusResult.error('La ocurrencia ya está marcada como pagada');
      }

      if (occurrence.estado == 'CANCELLED') {
        return UpdateStatusResult.error('No se puede marcar como pagada una ocurrencia cancelada');
      }

      // Actualizar estado a PAID
      final statusSuccess = await _occurrenceRepository.updateOccurrenceStatus(occurrenceId, 'PAID');
      if (!statusSuccess) {
        return UpdateStatusResult.error('Error actualizando el estado de la ocurrencia');
      }

      // Crear registro de pago
      final paymentId = await _paymentRepository.createPayment(
        id: 'payment_$occurrenceId',
        occurrenceId: occurrenceId,
        fechaPago: paidDate ?? DateTime.now(),
        montoPagado: paidAmount ?? occurrence.monto,
      );

      final success = paymentId.isNotEmpty;

      if (success) {
        return UpdateStatusResult(
          successfulUpdates: [occurrenceId],
          errors: [],
          totalProcessed: 1,
        );
      } else {
        return UpdateStatusResult.error('Error creando el registro de pago');
      }

    } catch (e) {
      return UpdateStatusResult.error('Error marcando como pagado: $e');
    }
  }

  Future<UpdateStatusResult> markAsOverdue(List<String> occurrenceIds) async {
    return await execute(occurrenceIds, 'OVERDUE', reason: 'Marcado automáticamente como vencido');
  }

  Future<UpdateStatusResult> cancelOccurrence(String occurrenceId, String reason) async {
    try {
      final occurrence = await _occurrenceRepository.getOccurrence(occurrenceId);
      if (occurrence == null) {
        return UpdateStatusResult.error('Ocurrencia no encontrada');
      }

      if (occurrence.estado == 'PAID') {
        return UpdateStatusResult.error('No se puede cancelar una ocurrencia pagada');
      }

      final success = await _occurrenceRepository.updateOccurrenceStatus(occurrenceId, 'CANCELLED');

      if (success) {
        return UpdateStatusResult(
          successfulUpdates: [occurrenceId],
          errors: [],
          totalProcessed: 1,
        );
      } else {
        return UpdateStatusResult.error('Error cancelando la ocurrencia');
      }

    } catch (e) {
      return UpdateStatusResult.error('Error cancelando: $e');
    }
  }

  Future<UpdateStatusResult> undoPayment(String occurrenceId, String reason) async {
    try {
      final occurrence = await _occurrenceRepository.getOccurrence(occurrenceId);
      if (occurrence == null) {
        return UpdateStatusResult.error('Ocurrencia no encontrada');
      }

      if (occurrence.estado != 'PAID') {
        return UpdateStatusResult.error('La ocurrencia no está marcada como pagada');
      }

      // Eliminar el registro de pago
      final payment = await _paymentRepository.getPaymentByOccurrence(occurrenceId);
      if (payment != null) {
        await _paymentRepository.deletePayment(payment.id);
      }

      // Determinar el nuevo estado basado en la fecha de vencimiento
      final now = DateTime.now();
      final dueDate = DateTime.fromMillisecondsSinceEpoch(occurrence.fechaDue);
      final newStatus = now.isAfter(dueDate) ? 'OVERDUE' : 'PENDING';

      final success = await _occurrenceRepository.updateOccurrenceStatus(occurrenceId, newStatus);

      if (success) {
        return UpdateStatusResult(
          successfulUpdates: [occurrenceId],
          errors: [],
          totalProcessed: 1,
        );
      } else {
        return UpdateStatusResult.error('Error deshaciendo el pago');
      }

    } catch (e) {
      return UpdateStatusResult.error('Error deshaciendo pago: $e');
    }
  }

  Future<BatchUpdateResult> updateOverdueOccurrences([DateTime? asOfDate]) async {
    try {
      final cutoffDate = asOfDate ?? DateTime.now();
      
      // Obtener ocurrencias pendientes que ya vencieron
      final overdueOccurrences = await _occurrenceRepository.getOverdueOccurrences();
      
      if (overdueOccurrences.isEmpty) {
        return BatchUpdateResult(
          processedCount: 0,
          updatedCount: 0,
          errors: [],
          message: 'No se encontraron ocurrencias vencidas',
        );
      }

      // Filtrar por fecha si se especifica
      final filteredOccurrences = overdueOccurrences.where((o) {
        final dueDate = DateTime.fromMillisecondsSinceEpoch(o.fechaDue);
        return dueDate.isBefore(cutoffDate);
      }).toList();

      // Actualizar estado a OVERDUE
      final occurrenceIds = filteredOccurrences.map((o) => o.id).toList();
      final result = await execute(
        occurrenceIds, 
        'OVERDUE',
        reason: 'Vencimiento automático - ${cutoffDate.toIso8601String().split('T')[0]}',
      );

      return BatchUpdateResult(
        processedCount: result.totalProcessed,
        updatedCount: result.successfulUpdates.length,
        errors: result.errors.map((e) => e.error).toList(),
        message: 'Procesadas ${result.totalProcessed} ocurrencias, ${result.successfulUpdates.length} actualizadas a vencidas',
      );

    } catch (e) {
      return BatchUpdateResult(
        processedCount: 0,
        updatedCount: 0,
        errors: ['Error actualizando vencidas: $e'],
        message: 'Error en la actualización masiva',
      );
    }
  }

  // Métodos de validación
  String? _validateStatus(String status) {
    const validStatuses = ['PENDING', 'PAID', 'OVERDUE', 'CANCELLED'];
    if (!validStatuses.contains(status)) {
      return 'Estado inválido: $status. Estados válidos: ${validStatuses.join(', ')}';
    }
    return null;
  }

  String? _validateStatusTransition(String currentStatus, String newStatus) {
    // Definir transiciones válidas
    const validTransitions = {
      'PENDING': ['PAID', 'OVERDUE', 'CANCELLED'],
      'OVERDUE': ['PAID', 'CANCELLED'],
      'PAID': [], // Los pagos no se pueden cambiar directamente (usar undoPayment)
      'CANCELLED': [], // Las cancelaciones son finales
    };

    final allowedTransitions = validTransitions[currentStatus] ?? [];
    if (!allowedTransitions.contains(newStatus)) {
      return 'Transición inválida: $currentStatus -> $newStatus';
    }

    return null;
  }

  // Métodos de utilidad
  List<String> getValidStatuses() {
    return ['PENDING', 'PAID', 'OVERDUE', 'CANCELLED'];
  }

  String getStatusDisplayName(String status) {
    switch (status) {
      case 'PENDING':
        return 'Pendiente';
      case 'PAID':
        return 'Pagado';
      case 'OVERDUE':
        return 'Vencido';
      case 'CANCELLED':
        return 'Cancelado';
      default:
        return status;
    }
  }

  bool canTransitionTo(String currentStatus, String newStatus) {
    return _validateStatusTransition(currentStatus, newStatus) == null;
  }
}

class UpdateStatusResult {
  final List<String> successfulUpdates;
  final List<StatusUpdateError> errors;
  final int totalProcessed;
  final String? generalError;

  UpdateStatusResult({
    required this.successfulUpdates,
    required this.errors,
    required this.totalProcessed,
    this.generalError,
  });

  factory UpdateStatusResult.error(String error) {
    return UpdateStatusResult(
      successfulUpdates: [],
      errors: [],
      totalProcessed: 0,
      generalError: error,
    );
  }

  bool get isSuccess => generalError == null && errors.isEmpty;
  bool get hasPartialSuccess => generalError == null && successfulUpdates.isNotEmpty && errors.isNotEmpty;
  int get successCount => successfulUpdates.length;
  int get errorCount => errors.length;
}

class StatusUpdateError {
  final String occurrenceId;
  final String error;

  StatusUpdateError({
    required this.occurrenceId,
    required this.error,
  });
}

class BatchUpdateResult {
  final int processedCount;
  final int updatedCount;
  final List<String> errors;
  final String message;

  BatchUpdateResult({
    required this.processedCount,
    required this.updatedCount,
    required this.errors,
    required this.message,
  });

  bool get isSuccess => errors.isEmpty;
  bool get hasErrors => errors.isNotEmpty;
}