import '../../../data/repos/occurrence_repository.dart';
import '../../../data/repos/recurrence_repository.dart';
import '../../../data/repos/template_repository.dart';
import '../../../services/notifications/i_notification_service.dart';

class GenerateOccurrencesForTemplateUseCase {
  final OccurrenceRepository _occurrenceRepository;
  final RecurrenceRepository _recurrenceRepository;
  final TemplateRepository _templateRepository;
  final INotificationService _notificationService;

  GenerateOccurrencesForTemplateUseCase(
    this._occurrenceRepository,
    this._recurrenceRepository,
    this._templateRepository,
    this._notificationService,
  );

  Future<GenerationResult> execute(
    String templateId, {
    DateTime? fromDate,
    DateTime? toDate,
    int? maxOccurrences,
  }) async {
    try {
      // 1. Obtener la plantilla
      final template = await _templateRepository.getTemplate(templateId);
      if (template == null) {
        return GenerationResult.error('Plantilla no encontrada');
      }

      if (template.isArchived) {
        return GenerationResult.error('La plantilla está archivada');
      }

      // 2. Obtener la recurrencia activa
      final recurrence = await _recurrenceRepository
          .getActiveRecurrenceForTemplate(templateId);
      if (recurrence == null) {
        return GenerationResult.error(
            'No hay recurrencia activa para esta plantilla');
      }

      // 3. Verificar si la recurrencia sigue siendo válida
      final isActive =
          await _recurrenceRepository.isRecurrenceActive(recurrence.id);
      if (!isActive) {
        return GenerationResult.error(
            'La recurrencia ha expirado o no está activa');
      }

      // 4. Definir el rango de fechas
      final now = DateTime.now();
      DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
      final startDate = _dateOnly(fromDate ?? now);
      final endDate = toDate ??
          startDate.add(const Duration(days: 365)); // Por defecto, próximo año
      final maxOccs = maxOccurrences ?? 50; // Límite por defecto

      // 5. Generar fechas de ocurrencia
      final occurrenceDates = _recurrenceRepository.generateOccurrenceDates(
        recurrence,
        maxOccurrences: maxOccs,
        endDate: endDate,
      );

      // Filtrar fechas dentro del rango deseado
      final filteredDates = occurrenceDates.where((date) {
        final dOnly = _dateOnly(date);
        // Incluir si dOnly >= startDate y <= endDate (ambos normalizados)
        return !dOnly.isBefore(startDate) && !dOnly.isAfter(_dateOnly(endDate));
      }).toList();

      if (filteredDates.isEmpty) {
        return GenerationResult.success(
          generatedCount: 0,
          message: 'No hay fechas de ocurrencia en el rango especificado',
        );
      }

      // 6. Verificar ocurrencias existentes para evitar duplicados
      final existingOccurrences =
          await _occurrenceRepository.getOccurrencesByTemplate(templateId);
      final existingDates = existingOccurrences
          .map((occ) =>
              _dateOnly(DateTime.fromMillisecondsSinceEpoch(occ.fechaDue)))
          .toSet();

      // 7. Filtrar fechas que no existen aún
      final newDates = filteredDates.where((date) {
        final dateOnly = _dateOnly(date);
        return !existingDates.contains(dateOnly);
      }).toList();

      if (newDates.isEmpty) {
        return GenerationResult.success(
          generatedCount: 0,
          message: 'Todas las ocurrencias ya existen para este periodo',
        );
      }

      // 8. Crear las nuevas ocurrencias
      int generatedCount = 0;
      final List<String> createdOccurrenceIds = [];

      for (final date in newDates) {
        try {
          final occurrenceId = await _occurrenceRepository.createOccurrence(
            id: _generateOccurrenceId(templateId, date),
            templateId: templateId,
            fechaDue: date,
            monto: template.monto,
            estado: 'PENDING',
          );

          createdOccurrenceIds.add(occurrenceId);
          generatedCount++;

          // Programar recordatorios para esta ocurrencia
          await _scheduleRemindersForOccurrence(occurrenceId, date);
        } catch (e) {
          // Log el error pero continúa con las demás ocurrencias
          print('Error creando ocurrencia para fecha $date: $e');
        }
      }

      // 9. Actualizar ciclos restantes en la recurrencia
      if (recurrence.ciclosRestantes != null && generatedCount > 0) {
        final newRemainingCycles = recurrence.ciclosRestantes! - generatedCount;
        await _recurrenceRepository.updateRemainingCycles(recurrence.id,
            newRemainingCycles.clamp(0, recurrence.ciclosRestantes!));
      }

      // 10. Actualizar estadísticas de la plantilla
      // TODO: Implementar updateLastGenerated si es necesario
      // await _templateRepository.updateLastGenerated(templateId);

      return GenerationResult.success(
        generatedCount: generatedCount,
        createdOccurrenceIds: createdOccurrenceIds,
        message: 'Se generaron $generatedCount ocurrencias exitosamente',
      );
    } catch (e) {
      return GenerationResult.error('Error generando ocurrencias: $e');
    }
  }

  Future<void> _scheduleRemindersForOccurrence(
      String occurrenceId, DateTime dueDate) async {
    // Este método será implementado en ScheduleRemindersForOccurrenceUseCase
    // Por ahora, dejamos la lógica básica
    try {
      await _notificationService.schedulePaymentReminder(
        id: '${occurrenceId}_reminder',
        title: 'Recordatorio de Pago',
        body: 'Tienes un pago pendiente',
        scheduledDate: dueDate.subtract(const Duration(days: 1)),
        payload: occurrenceId,
      );
    } catch (e) {
      print('Error programando recordatorio para $occurrenceId: $e');
    }
  }

  String _generateOccurrenceId(String templateId, DateTime date) {
    final dateStr =
        '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}';
    return '${templateId}_$dateStr';
  }

  // Método para generar ocurrencias faltantes automáticamente
  Future<BatchGenerationResult> generateMissingOccurrences({
    DateTime? fromDate,
    int lookAheadDays = 90,
  }) async {
    final startDate = fromDate ?? DateTime.now();
    final endDate = startDate.add(Duration(days: lookAheadDays));

    // Obtener todas las plantillas activas
    final allTemplates = await _templateRepository.getAllTemplates();
    final activeTemplates = allTemplates.where((t) => !t.isArchived).toList();

    final List<GenerationResult> results = [];
    int totalGenerated = 0;

    for (final template in activeTemplates) {
      final result = await execute(
        template.id,
        fromDate: startDate,
        toDate: endDate,
        maxOccurrences: lookAheadDays ~/ 7, // Aproximadamente semanal
      );

      results.add(result);
      if (result.isSuccess) {
        totalGenerated += result.generatedCount;
      }
    }

    return BatchGenerationResult(
      results: results,
      totalGenerated: totalGenerated,
      processedTemplates: activeTemplates.length,
    );
  }
}

class GenerationResult {
  final bool isSuccess;
  final String message;
  final int generatedCount;
  final List<String> createdOccurrenceIds;
  final String? error;

  GenerationResult._({
    required this.isSuccess,
    required this.message,
    required this.generatedCount,
    required this.createdOccurrenceIds,
    this.error,
  });

  factory GenerationResult.success({
    required int generatedCount,
    String? message,
    List<String>? createdOccurrenceIds,
  }) {
    return GenerationResult._(
      isSuccess: true,
      message: message ?? 'Generación exitosa',
      generatedCount: generatedCount,
      createdOccurrenceIds: createdOccurrenceIds ?? [],
    );
  }

  factory GenerationResult.error(String error) {
    return GenerationResult._(
      isSuccess: false,
      message: error,
      generatedCount: 0,
      createdOccurrenceIds: [],
      error: error,
    );
  }
}

class BatchGenerationResult {
  final List<GenerationResult> results;
  final int totalGenerated;
  final int processedTemplates;

  BatchGenerationResult({
    required this.results,
    required this.totalGenerated,
    required this.processedTemplates,
  });

  int get successfulTemplates => results.where((r) => r.isSuccess).length;
  int get failedTemplates => results.where((r) => !r.isSuccess).length;

  List<String> get errors => results
      .where((r) => !r.isSuccess)
      .map((r) => r.error ?? r.message)
      .toList();
}
