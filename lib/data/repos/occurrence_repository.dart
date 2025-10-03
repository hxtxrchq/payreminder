import 'package:drift/drift.dart';
import '../db/app_database.dart';
import '../db/occurrence_dao.dart';
import 'payment_repository.dart';
import 'dart:async';
import '../../domain/models/month_summary.dart';

class OccurrenceRepository {
  final OccurrenceDao _occurrenceDao;

  OccurrenceRepository(this._occurrenceDao);

  // Basic CRUD operations
  Future<String> createOccurrence({
    required String id,
    required String templateId,
    required DateTime fechaDue,
    required double monto,
    String estado = 'PENDING',
    String? cardId,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final occurrence = OccurrencesCompanion(
      id: Value(id),
      templateId: Value(templateId),
      fechaDue: Value(fechaDue.millisecondsSinceEpoch),
      monto: Value(monto),
      estado: Value(estado),
      cardId: Value(cardId),
      createdAt: Value(now),
      updatedAt: Value(now),
    );
    return await _occurrenceDao.insertOccurrence(occurrence);
  }

  Future<Occurrence?> getOccurrence(String id) async {
    return await _occurrenceDao.getOccurrenceById(id);
  }

  Future<OccurrenceWithDetails?> getOccurrenceWithDetails(String id) async {
    return await _occurrenceDao.getOccurrenceWithDetailsById(id);
  }

  Future<List<Occurrence>> getAllOccurrences() async {
    return await _occurrenceDao.getAllOccurrences();
  }

  Future<List<OccurrenceWithDetails>> getOccurrencesWithDetails() async {
    return await _occurrenceDao.getOccurrencesWithDetails();
  }

  Future<bool> updateOccurrence({
    required String id,
    String? templateId,
    DateTime? fechaDue,
    double? monto,
    String? estado,
    String? cardId,
  }) async {
    final updates = OccurrencesCompanion(
      id: Value(id),
      templateId: templateId != null ? Value(templateId) : Value.absent(),
      fechaDue: fechaDue != null
          ? Value(fechaDue.millisecondsSinceEpoch)
          : Value.absent(),
      monto: monto != null ? Value(monto) : Value.absent(),
      estado: estado != null ? Value(estado) : Value.absent(),
      cardId: cardId != null ? Value(cardId) : Value.absent(),
      updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
    );
    return await _occurrenceDao.updateOccurrence(updates);
  }

  Future<bool> deleteOccurrence(String id) async {
    return await _occurrenceDao.deleteOccurrence(id);
  }

  // Status management
  Future<bool> updateOccurrenceStatus(String id, String status) async {
    return await _occurrenceDao.updateOccurrenceStatus(id, status);
  }

  Future<bool> markAsPaid(String id) async {
    return await _occurrenceDao.markAsPaid(id);
  }

  Future<bool> markAsPending(String id) async {
    return await _occurrenceDao.markAsPending(id);
  }

  // Filter by status
  Future<List<Occurrence>> getOccurrencesByStatus(String status) async {
    return await _occurrenceDao.getOccurrencesByStatus(status);
  }

  Future<List<Occurrence>> getPendingOccurrences() async {
    return await _occurrenceDao.getPendingOccurrences();
  }

  Future<List<Occurrence>> getPaidOccurrences() async {
    return await _occurrenceDao.getPaidOccurrences();
  }

  Future<List<Occurrence>> getOverdueOccurrences() async {
    return await _occurrenceDao.getOverdueOccurrences();
  }

  Future<List<Occurrence>> getDueTodayOccurrences() async {
    return await _occurrenceDao.getDueTodayOccurrences();
  }

  Future<List<Occurrence>> getNearOccurrences() async {
    return await _occurrenceDao.getNearOccurrences();
  }

  // Date-based queries
  Future<List<Occurrence>> getOccurrencesByDateRange(
      DateTime startDate, DateTime endDate) async {
    return await _occurrenceDao.getOccurrencesByDateRange(startDate, endDate);
  }

  Future<List<OccurrenceWithDetails>> getOccurrencesWithDetailsByDateRange(
      DateTime startDate, DateTime endDate) async {
    return await _occurrenceDao.getOccurrencesWithDetailsByDateRange(
        startDate, endDate);
  }

  Future<List<Occurrence>> getOccurrencesForMonth(int year, int month) async {
    return await _occurrenceDao.getOccurrencesForMonth(year, month);
  }

  Future<List<Occurrence>> getOccurrencesForToday() async {
    return await _occurrenceDao.getOccurrencesForToday();
  }

  Future<List<Occurrence>> getOccurrencesForWeek(DateTime weekStart) async {
    return await _occurrenceDao.getOccurrencesForWeek(weekStart);
  }

  // Template-based queries
  Future<List<Occurrence>> getOccurrencesByTemplate(String templateId) async {
    return await _occurrenceDao.getOccurrencesByTemplate(templateId);
  }

  Future<List<Occurrence>> getUpcomingOccurrencesForTemplate(
      String templateId, int daysAhead) async {
    return await _occurrenceDao.getUpcomingOccurrencesForTemplate(
        templateId, daysAhead);
  }

  // Bulk operations
  Future<void> createOccurrences(List<OccurrenceData> occurrencesData) async {
    final companions = occurrencesData
        .map((data) => OccurrencesCompanion(
              id: Value(data.id),
              templateId: Value(data.templateId),
              fechaDue: Value(data.fechaDue.millisecondsSinceEpoch),
              monto: Value(data.monto),
              estado: Value(data.estado),
              cardId: Value(data.cardId),
              createdAt: Value(DateTime.now().millisecondsSinceEpoch),
              updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
            ))
        .toList();

    await _occurrenceDao.insertOccurrences(companions);
  }

  Future<int> updateMultipleStatuses(List<String> ids, String status) async {
    return await _occurrenceDao.updateOccurrenceStatuses(ids, status);
  }

  Future<int> deleteOccurrencesByTemplate(String templateId) async {
    return await _occurrenceDao.deleteOccurrencesByTemplate(templateId);
  }

  // Status calculation based on dates
  String calculateStatus(DateTime dueDate, {int nearThreshold = 3}) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDateOnly = DateTime(dueDate.year, dueDate.month, dueDate.day);

    final daysDifference = dueDateOnly.difference(today).inDays;

    if (daysDifference < 0) {
      return 'OVERDUE';
    } else if (daysDifference == 0) {
      return 'DUE_TODAY';
    } else if (daysDifference <= nearThreshold) {
      return 'NEAR';
    } else {
      return 'PENDING';
    }
  }

  Future<void> updateAllStatuses({int nearThreshold = 3}) async {
    final allOccurrences = await getAllOccurrences();

    for (final occurrence in allOccurrences) {
      if (occurrence.estado == 'PAID')
        continue; // Don't update paid occurrences

      final dueDate = DateTime.fromMillisecondsSinceEpoch(occurrence.fechaDue);
      final newStatus = calculateStatus(dueDate, nearThreshold: nearThreshold);

      if (occurrence.estado != newStatus) {
        await updateOccurrenceStatus(occurrence.id, newStatus);
      }
    }
  }

  // Calendar helpers
  Future<Map<DateTime, List<OccurrenceWithDetails>>> getCalendarData(
      int year, int month) async {
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 0);

    final occurrences =
        await getOccurrencesWithDetailsByDateRange(startDate, endDate);
    final Map<DateTime, List<OccurrenceWithDetails>> calendarData = {};

    for (final occurrence in occurrences) {
      final date =
          DateTime.fromMillisecondsSinceEpoch(occurrence.occurrence.fechaDue);
      final dateKey = DateTime(date.year, date.month, date.day);

      if (calendarData[dateKey] == null) {
        calendarData[dateKey] = [];
      }
      calendarData[dateKey]!.add(occurrence);
    }

    return calendarData;
  }

  // Statistics
  Future<int> getOccurrenceCount() async {
    return await _occurrenceDao.getOccurrenceCount();
  }

  Future<int> getOccurrenceCountByStatus(String status) async {
    return await _occurrenceDao.getOccurrenceCountByStatus(status);
  }

  Future<double> getTotalAmountByStatus(String status) async {
    return await _occurrenceDao.getTotalAmountByStatus(status);
  }

  Future<Map<String, int>> getStatusCounts() async {
    final statuses = ['PENDING', 'NEAR', 'DUE_TODAY', 'OVERDUE', 'PAID'];
    final Map<String, int> counts = {};

    for (final status in statuses) {
      counts[status] = await getOccurrenceCountByStatus(status);
    }

    return counts;
  }

  // Stream operations for real-time updates
  Stream<List<Occurrence>> watchAllOccurrences() {
    return _occurrenceDao.watchAllOccurrences();
  }

  Stream<Occurrence?> watchOccurrence(String id) {
    return _occurrenceDao.watchOccurrence(id);
  }

  Stream<List<Occurrence>> watchOccurrencesByStatus(String status) {
    return _occurrenceDao.watchOccurrencesByStatus(status);
  }

  Stream<List<OccurrenceWithDetails>> watchOccurrencesWithDetailsByDateRange(
      DateTime startDate, DateTime endDate) {
    return _occurrenceDao.watchOccurrencesWithDetailsByDateRange(
        startDate, endDate);
  }

  // Month summary watcher: pendientes, pagados, vencidos
  Stream<MonthSummary> watchMonthSummary(
      DateTime start, DateTime end, PaymentRepository payRepo) {
    // Paid amount in the month by payment date
    final paidStream = payRepo.watchSumPaidBetween(start, end);

    // Pending-like sum (PENDING, NEAR, DUE_TODAY) by due date in month
    final pendingStream = watchSumOccurrencesBetween(start, end,
        whereEstadoIn: const ['PENDING', 'NEAR', 'DUE_TODAY']);

    // Overdue sum by due date in month
    final overdueStream = watchSumOccurrencesBetween(start, end,
        whereEstadoIn: const ['OVERDUE']);

    late final StreamController<MonthSummary> controller;
    controller = StreamController<MonthSummary>();
    double _p = 0, _pg = 0, _v = 0;

    StreamSubscription? subP;
    StreamSubscription? subPg;
    StreamSubscription? subV;

    void emit() {
      if (!controller.isClosed) controller.add(MonthSummary(_p, _pg, _v));
    }

    subP = pendingStream.listen((value) {
      _p = value;
      emit();
    });
    subPg = paidStream.listen((value) {
      _pg = value;
      emit();
    });
    subV = overdueStream.listen((value) {
      _v = value;
      emit();
    });

    controller.onCancel = () {
      subP?.cancel();
      subPg?.cancel();
      subV?.cancel();
    };

    return controller.stream;
  }

  // Sum helpers
  Stream<double> watchSumOccurrencesBetween(DateTime start, DateTime end,
      {required List<String> whereEstadoIn}) {
    return _occurrenceDao.watchSumOccurrencesBetween(start, end,
        estados: whereEstadoIn);
  }

  // Count helpers
  Stream<int> watchCountOccurrencesBetween(DateTime start, DateTime end,
      {required List<String> whereEstadoIn}) {
    return _occurrenceDao.watchCountOccurrencesBetween(start, end,
        estados: whereEstadoIn);
  }

  // Upcoming items with details
  Stream<List<OccurrenceWithDetails>> watchUpcoming(DateTime startOfToday,
      {int limit = 5}) {
    return _occurrenceDao.watchUpcomingWithDetails(startOfToday, limit: limit);
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

    return null;
  }

  bool isValidStatus(String status) {
    const validStatuses = ['PENDING', 'NEAR', 'DUE_TODAY', 'OVERDUE', 'PAID'];
    return validStatuses.contains(status);
  }
}

// Helper class for bulk operations
class OccurrenceData {
  final String id;
  final String templateId;
  final DateTime fechaDue;
  final double monto;
  final String estado;
  final String? cardId;

  OccurrenceData({
    required this.id,
    required this.templateId,
    required this.fechaDue,
    required this.monto,
    this.estado = 'PENDING',
    this.cardId,
  });
}
