import 'package:drift/drift.dart';
import '../db/app_database.dart';
import '../db/recurrence_dao.dart';

class RecurrenceRepository {
  final RecurrenceDao _recurrenceDao;

  RecurrenceRepository(this._recurrenceDao);

  // Basic CRUD operations
  Future<String> createRecurrence({
    required String id,
    required String templateId,
    required String tipo,
    int? diaMes,
    int? dow,
    int? everyNDays,
    required DateTime fechaInicio,
    DateTime? fechaFin,
    int? totalCiclos,
    int? ciclosRestantes,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final recurrence = RecurrencesCompanion(
      id: Value(id),
      templateId: Value(templateId),
      tipo: Value(tipo),
      diaMes: Value(diaMes),
      dow: Value(dow),
      everyNDays: Value(everyNDays),
      fechaInicio: Value(fechaInicio.millisecondsSinceEpoch),
      fechaFin: Value(fechaFin?.millisecondsSinceEpoch),
      totalCiclos: Value(totalCiclos),
      ciclosRestantes: Value(ciclosRestantes),
      createdAt: Value(now),
      updatedAt: Value(now),
    );
    return await _recurrenceDao.insertRecurrence(recurrence);
  }

  Future<Recurrence?> getRecurrence(String id) async {
    return await _recurrenceDao.getRecurrenceById(id);
  }

  Future<RecurrenceWithTemplate?> getRecurrenceWithTemplate(String id) async {
    return await _recurrenceDao.getRecurrenceWithTemplateById(id);
  }

  Future<List<Recurrence>> getAllRecurrences() async {
    return await _recurrenceDao.getAllRecurrences();
  }

  Future<List<RecurrenceWithTemplate>> getRecurrencesWithTemplates() async {
    return await _recurrenceDao.getRecurrencesWithTemplates();
  }

  Future<bool> updateRecurrence({
    required String id,
    String? templateId,
    String? tipo,
    int? diaMes,
    int? dow,
    int? everyNDays,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    int? totalCiclos,
    int? ciclosRestantes,
  }) async {
    final updates = RecurrencesCompanion(
      id: Value(id),
      templateId: templateId != null ? Value(templateId) : Value.absent(),
      tipo: tipo != null ? Value(tipo) : Value.absent(),
      diaMes: diaMes != null ? Value(diaMes) : Value.absent(),
      dow: dow != null ? Value(dow) : Value.absent(),
      everyNDays: everyNDays != null ? Value(everyNDays) : Value.absent(),
      fechaInicio: fechaInicio != null ? Value(fechaInicio.millisecondsSinceEpoch) : Value.absent(),
      fechaFin: fechaFin != null ? Value(fechaFin.millisecondsSinceEpoch) : Value.absent(),
      totalCiclos: totalCiclos != null ? Value(totalCiclos) : Value.absent(),
      ciclosRestantes: ciclosRestantes != null ? Value(ciclosRestantes) : Value.absent(),
      updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
    );
    return await _recurrenceDao.updateRecurrence(updates);
  }

  Future<bool> deleteRecurrence(String id) async {
    return await _recurrenceDao.deleteRecurrence(id);
  }

  // Template-specific operations
  Future<List<Recurrence>> getRecurrencesByTemplate(String templateId) async {
    return await _recurrenceDao.getRecurrencesByTemplate(templateId);
  }

  Future<Recurrence?> getActiveRecurrenceForTemplate(String templateId) async {
    return await _recurrenceDao.getActiveRecurrenceForTemplate(templateId);
  }

  Future<bool> deleteRecurrencesByTemplate(String templateId) async {
    return await _recurrenceDao.deleteRecurrencesByTemplate(templateId);
  }

  // Filter by type and status
  Future<List<Recurrence>> getRecurrencesByType(String tipo) async {
    return await _recurrenceDao.getRecurrencesByType(tipo);
  }

  Future<List<Recurrence>> getActiveRecurrences([DateTime? asOfDate]) async {
    final timestamp = asOfDate?.millisecondsSinceEpoch;
    return await _recurrenceDao.getActiveRecurrences(timestamp);
  }

  Future<List<Recurrence>> getExpiredRecurrences([DateTime? asOfDate]) async {
    final timestamp = asOfDate?.millisecondsSinceEpoch;
    return await _recurrenceDao.getExpiredRecurrences(timestamp);
  }

  Future<List<Recurrence>> getRecurrencesEndingSoon(int daysAhead) async {
    return await _recurrenceDao.getRecurrencesEndingSoon(daysAhead);
  }

  // Cycle management
  Future<bool> updateRemainingCycles(String id, int remainingCycles) async {
    return await _recurrenceDao.updateRemainingCycles(id, remainingCycles);
  }

  Future<bool> decrementRemainingCycles(String id) async {
    return await _recurrenceDao.decrementRemainingCycles(id);
  }

  // Statistics
  Future<int> getRecurrenceCount() async {
    return await _recurrenceDao.getRecurrenceCount();
  }

  Future<int> getActiveRecurrenceCount() async {
    return await _recurrenceDao.getActiveRecurrenceCount();
  }

  Future<Map<String, int>> getRecurrenceCountByType() async {
    final recurrences = await getAllRecurrences();
    final Map<String, int> typeCounts = {};
    
    for (final recurrence in recurrences) {
      typeCounts[recurrence.tipo] = (typeCounts[recurrence.tipo] ?? 0) + 1;
    }
    
    return typeCounts;
  }

  // Stream operations for real-time updates
  Stream<List<Recurrence>> watchAllRecurrences() {
    return _recurrenceDao.watchAllRecurrences();
  }

  Stream<Recurrence?> watchRecurrence(String id) {
    return _recurrenceDao.watchRecurrence(id);
  }

  Stream<List<Recurrence>> watchRecurrencesByTemplate(String templateId) {
    return _recurrenceDao.watchRecurrencesByTemplate(templateId);
  }

  Stream<List<RecurrenceWithTemplate>> watchRecurrencesWithTemplates() {
    return _recurrenceDao.watchRecurrencesWithTemplates();
  }

  // Validation methods
  String? validateRecurrenceType(String? tipo) {
    const validTypes = ['MONTHLY_BY_DOM', 'WEEKLY_BY_DOW', 'YEARLY_BY_DOM', 'EVERY_N_DAYS'];
    if (tipo == null || !validTypes.contains(tipo)) {
      return 'Tipo de recurrencia inválido';
    }
    return null;
  }

  String? validateDayOfMonth(int? day, String? tipo) {
    if (tipo == 'MONTHLY_BY_DOM' || tipo == 'YEARLY_BY_DOM') {
      if (day == null) return 'Día del mes es requerido para este tipo de recurrencia';
      if (day < 1 || day > 31) return 'Día del mes debe estar entre 1 y 31';
    }
    return null;
  }

  String? validateDayOfWeek(int? dow, String? tipo) {
    if (tipo == 'WEEKLY_BY_DOW') {
      if (dow == null) return 'Día de la semana es requerido para recurrencia semanal';
      if (dow < 1 || dow > 7) return 'Día de la semana debe estar entre 1 y 7';
    }
    return null;
  }

  String? validateEveryNDays(int? days, String? tipo) {
    if (tipo == 'EVERY_N_DAYS') {
      if (days == null) return 'Número de días es requerido para este tipo de recurrencia';
      if (days < 1 || days > 365) return 'Número de días debe estar entre 1 y 365';
    }
    return null;
  }

  String? validateDateRange(DateTime? fechaInicio, DateTime? fechaFin) {
    if (fechaInicio == null) return 'Fecha de inicio es requerida';
    
    if (fechaFin != null && fechaFin.isBefore(fechaInicio)) {
      return 'Fecha de fin no puede ser anterior a la fecha de inicio';
    }
    
    return null;
  }

  String? validateCycles(int? totalCiclos, int? ciclosRestantes) {
    if (totalCiclos != null) {
      if (totalCiclos < 1) return 'Total de ciclos debe ser mayor a 0';
      if (totalCiclos > 1000) return 'Total de ciclos no puede exceder 1000';
      
      if (ciclosRestantes != null && ciclosRestantes > totalCiclos) {
        return 'Ciclos restantes no puede ser mayor al total';
      }
    }
    
    if (ciclosRestantes != null && ciclosRestantes < 0) {
      return 'Ciclos restantes no puede ser negativo';
    }
    
    return null;
  }

  // Utility methods
  List<String> getRecurrenceTypes() {
    return ['MONTHLY_BY_DOM', 'WEEKLY_BY_DOW', 'YEARLY_BY_DOM', 'EVERY_N_DAYS'];
  }

  String getRecurrenceTypeDescription(String tipo) {
    switch (tipo) {
      case 'MONTHLY_BY_DOM':
        return 'Mensual por día del mes';
      case 'WEEKLY_BY_DOW':
        return 'Semanal por día de la semana';
      case 'YEARLY_BY_DOM':
        return 'Anual por día del mes';
      case 'EVERY_N_DAYS':
        return 'Cada N días';
      default:
        return 'Tipo desconocido';
    }
  }

  List<String> getDayNames() {
    return ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
  }

  String getDayName(int dow) {
    final dayNames = getDayNames();
    if (dow >= 1 && dow <= 7) {
      return dayNames[dow - 1];
    }
    return 'Día inválido';
  }

  Future<bool> isRecurrenceActive(String id) async {
    final recurrence = await getRecurrence(id);
    if (recurrence == null) return false;
    
    final now = DateTime.now().millisecondsSinceEpoch;
    final isStarted = recurrence.fechaInicio <= now;
    final notExpired = recurrence.fechaFin == null || recurrence.fechaFin! >= now;
    final hasCycles = recurrence.ciclosRestantes == null || recurrence.ciclosRestantes! > 0;
    
    return isStarted && notExpired && hasCycles;
  }

  // Recurrence calculation helpers
  DateTime? getNextOccurrenceDate(Recurrence recurrence, {DateTime? fromDate}) {
    final baseDate = fromDate ?? DateTime.fromMillisecondsSinceEpoch(recurrence.fechaInicio);
    
    switch (recurrence.tipo) {
      case 'MONTHLY_BY_DOM':
        if (recurrence.diaMes == null) return null;
        var nextDate = DateTime(baseDate.year, baseDate.month + 1, recurrence.diaMes!);
        // Handle end of month cases
        if (nextDate.month != baseDate.month + 1) {
          nextDate = DateTime(baseDate.year, baseDate.month + 2, 0); // Last day of previous month
        }
        return nextDate;
        
      case 'WEEKLY_BY_DOW':
        if (recurrence.dow == null) return null;
        final daysToAdd = (recurrence.dow! - baseDate.weekday + 7) % 7;
        return baseDate.add(Duration(days: daysToAdd == 0 ? 7 : daysToAdd));
        
      case 'YEARLY_BY_DOM':
        if (recurrence.diaMes == null) return null;
        return DateTime(baseDate.year + 1, baseDate.month, recurrence.diaMes!);
        
      case 'EVERY_N_DAYS':
        if (recurrence.everyNDays == null) return null;
        return baseDate.add(Duration(days: recurrence.everyNDays!));
        
      default:
        return null;
    }
  }

  List<DateTime> generateOccurrenceDates(
    Recurrence recurrence, 
    {int maxOccurrences = 100, DateTime? endDate}
  ) {
    final List<DateTime> dates = [];
    var currentDate = DateTime.fromMillisecondsSinceEpoch(recurrence.fechaInicio);
    final finalEndDate = endDate ?? (recurrence.fechaFin != null 
        ? DateTime.fromMillisecondsSinceEpoch(recurrence.fechaFin!) 
        : DateTime.now().add(const Duration(days: 365)));
    
    int cyclesGenerated = 0;
    final maxCycles = recurrence.totalCiclos ?? maxOccurrences;
    
    while (dates.length < maxOccurrences && 
           currentDate.isBefore(finalEndDate) && 
           cyclesGenerated < maxCycles) {
      
      dates.add(currentDate);
      cyclesGenerated++;
      
      final nextDate = getNextOccurrenceDate(recurrence, fromDate: currentDate);
      if (nextDate == null) break;
      
      currentDate = nextDate;
    }
    
    return dates;
  }
}