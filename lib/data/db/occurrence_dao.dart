import 'package:drift/drift.dart';
import '../db/app_database.dart';

part 'occurrence_dao.g.dart';

@DriftAccessor(
    tables: [Occurrences, DebtTemplates, Cards, Payments, PaymentMethods])
class OccurrenceDao extends DatabaseAccessor<AppDatabase>
    with _$OccurrenceDaoMixin {
  OccurrenceDao(AppDatabase db) : super(db);

  // CRUD Operations
  Future<String> insertOccurrence(OccurrencesCompanion occurrence) async {
    await into(occurrences).insert(occurrence);
    return occurrence.id.value;
  }

  Future<Occurrence?> getOccurrenceById(String id) async {
    return await (select(occurrences)..where((o) => o.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<Occurrence>> getAllOccurrences() async {
    return await (select(occurrences)
          ..orderBy([(o) => OrderingTerm.asc(o.fechaDue)]))
        .get();
  }

  Future<bool> updateOccurrence(OccurrencesCompanion occurrence) async {
    final result = await (update(occurrences)
          ..where((o) => o.id.equals(occurrence.id.value)))
        .write(occurrence);
    return result > 0;
  }

  Future<bool> deleteOccurrence(String id) async {
    final result =
        await (delete(occurrences)..where((o) => o.id.equals(id))).go();
    return result > 0;
  }

  // Status updates
  Future<bool> updateOccurrenceStatus(String id, String status) async {
    final result = await (update(occurrences)..where((o) => o.id.equals(id)))
        .write(OccurrencesCompanion(
      estado: Value(status),
      updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
    ));
    return result > 0;
  }

  Future<bool> markAsPaid(String id) async {
    return await updateOccurrenceStatus(id, 'PAID');
  }

  Future<bool> markAsPending(String id) async {
    return await updateOccurrenceStatus(id, 'PENDING');
  }

  // Filter by status
  Future<List<Occurrence>> getOccurrencesByStatus(String status) async {
    return await (select(occurrences)
          ..where((o) => o.estado.equals(status))
          ..orderBy([(o) => OrderingTerm.asc(o.fechaDue)]))
        .get();
  }

  Future<List<Occurrence>> getPendingOccurrences() async {
    return await getOccurrencesByStatus('PENDING');
  }

  Future<List<Occurrence>> getPaidOccurrences() async {
    return await getOccurrencesByStatus('PAID');
  }

  Future<List<Occurrence>> getOverdueOccurrences() async {
    return await getOccurrencesByStatus('OVERDUE');
  }

  Future<List<Occurrence>> getDueTodayOccurrences() async {
    return await getOccurrencesByStatus('DUE_TODAY');
  }

  Future<List<Occurrence>> getNearOccurrences() async {
    return await getOccurrencesByStatus('NEAR');
  }

  // Filter by date range
  Future<List<Occurrence>> getOccurrencesByDateRange(
      DateTime startDate, DateTime endDate) async {
    final startTimestamp = _getStartOfDay(startDate).millisecondsSinceEpoch;
    final endTimestamp = _getEndOfDay(endDate).millisecondsSinceEpoch;

    return await (select(occurrences)
          ..where(
              (o) => o.fechaDue.isBetweenValues(startTimestamp, endTimestamp))
          ..orderBy([(o) => OrderingTerm.asc(o.fechaDue)]))
        .get();
  }

  Future<List<Occurrence>> getOccurrencesForMonth(int year, int month) async {
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 0); // Last day of month
    return await getOccurrencesByDateRange(startDate, endDate);
  }

  Future<List<Occurrence>> getOccurrencesForToday() async {
    final today = DateTime.now();
    return await getOccurrencesByDateRange(today, today);
  }

  Future<List<Occurrence>> getOccurrencesForWeek(DateTime weekStart) async {
    final weekEnd = weekStart.add(const Duration(days: 6));
    return await getOccurrencesByDateRange(weekStart, weekEnd);
  }

  // Filter by template
  Future<List<Occurrence>> getOccurrencesByTemplate(String templateId) async {
    return await (select(occurrences)
          ..where((o) => o.templateId.equals(templateId))
          ..orderBy([(o) => OrderingTerm.asc(o.fechaDue)]))
        .get();
  }

  Future<List<Occurrence>> getUpcomingOccurrencesForTemplate(
      String templateId, int daysAhead) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final futureDate =
        DateTime.now().add(Duration(days: daysAhead)).millisecondsSinceEpoch;

    return await (select(occurrences)
          ..where((o) =>
              o.templateId.equals(templateId) &
              o.fechaDue.isBiggerOrEqualValue(now) &
              o.fechaDue.isSmallerOrEqualValue(futureDate))
          ..orderBy([(o) => OrderingTerm.asc(o.fechaDue)]))
        .get();
  }

  // Join operations
  Future<List<OccurrenceWithDetails>> getOccurrencesWithDetails() async {
    final query = select(occurrences).join([
      innerJoin(
          debtTemplates, debtTemplates.id.equalsExp(occurrences.templateId)),
      leftOuterJoin(cards, cards.id.equalsExp(occurrences.cardId)),
      leftOuterJoin(payments, payments.occurrenceId.equalsExp(occurrences.id)),
      leftOuterJoin(paymentMethods,
          paymentMethods.id.equalsExp(debtTemplates.paymentMethodId)),
    ])
      ..orderBy([OrderingTerm.asc(occurrences.fechaDue)]);

    final result = await query.get();
    return result
        .map((row) => OccurrenceWithDetails(
              occurrence: row.readTable(occurrences),
              template: row.readTable(debtTemplates),
              card: row.readTableOrNull(cards),
              payment: row.readTableOrNull(payments),
              paymentMethod: row.readTableOrNull(paymentMethods),
            ))
        .toList();
  }

  Future<OccurrenceWithDetails?> getOccurrenceWithDetailsById(String id) async {
    final query = select(occurrences).join([
      innerJoin(
          debtTemplates, debtTemplates.id.equalsExp(occurrences.templateId)),
      leftOuterJoin(cards, cards.id.equalsExp(occurrences.cardId)),
      leftOuterJoin(payments, payments.occurrenceId.equalsExp(occurrences.id)),
      leftOuterJoin(paymentMethods,
          paymentMethods.id.equalsExp(debtTemplates.paymentMethodId))
    ])
      ..where(occurrences.id.equals(id));

    final result = await query.getSingleOrNull();
    if (result == null) return null;

    return OccurrenceWithDetails(
      occurrence: result.readTable(occurrences),
      template: result.readTable(debtTemplates),
      card: result.readTableOrNull(cards),
      payment: result.readTableOrNull(payments),
      paymentMethod: result.readTableOrNull(paymentMethods),
    );
  }

  Future<List<OccurrenceWithDetails>> getOccurrencesWithDetailsByDateRange(
      DateTime startDate, DateTime endDate) async {
    final startTimestamp = _getStartOfDay(startDate).millisecondsSinceEpoch;
    final endTimestamp = _getEndOfDay(endDate).millisecondsSinceEpoch;

    final query = select(occurrences).join([
      innerJoin(
          debtTemplates, debtTemplates.id.equalsExp(occurrences.templateId)),
      leftOuterJoin(cards, cards.id.equalsExp(occurrences.cardId)),
      leftOuterJoin(payments, payments.occurrenceId.equalsExp(occurrences.id)),
      leftOuterJoin(paymentMethods,
          paymentMethods.id.equalsExp(debtTemplates.paymentMethodId))
    ])
      ..where(
          occurrences.fechaDue.isBetweenValues(startTimestamp, endTimestamp))
      ..orderBy([OrderingTerm.asc(occurrences.fechaDue)]);

    final result = await query.get();
    return result
        .map((row) => OccurrenceWithDetails(
              occurrence: row.readTable(occurrences),
              template: row.readTable(debtTemplates),
              card: row.readTableOrNull(cards),
              payment: row.readTableOrNull(payments),
              paymentMethod: row.readTableOrNull(paymentMethods),
            ))
        .toList();
  }

  // Bulk operations
  Future<void> insertOccurrences(
      List<OccurrencesCompanion> occurrenceList) async {
    await batch((batch) {
      batch.insertAll(occurrences, occurrenceList);
    });
  }

  Future<int> updateOccurrenceStatuses(List<String> ids, String status) async {
    final updatedAt = DateTime.now().millisecondsSinceEpoch;
    int totalUpdated = 0;

    for (final id in ids) {
      final result = await (update(occurrences)..where((o) => o.id.equals(id)))
          .write(OccurrencesCompanion(
        estado: Value(status),
        updatedAt: Value(updatedAt),
      ));
      totalUpdated += result;
    }

    return totalUpdated;
  }

  Future<int> deleteOccurrencesByTemplate(String templateId) async {
    return await (delete(occurrences)
          ..where((o) => o.templateId.equals(templateId)))
        .go();
  }

  // Statistics
  Future<int> getOccurrenceCount() async {
    final countExp = occurrences.id.count();
    final query = selectOnly(occurrences)..addColumns([countExp]);
    final result = await query.getSingle();
    return result.read(countExp) ?? 0;
  }

  Future<int> getOccurrenceCountByStatus(String status) async {
    final countExp = occurrences.id.count();
    final query = selectOnly(occurrences)
      ..addColumns([countExp])
      ..where(occurrences.estado.equals(status));
    final result = await query.getSingle();
    return result.read(countExp) ?? 0;
  }

  Future<double> getTotalAmountByStatus(String status) async {
    final sumExp = occurrences.monto.sum();
    final query = selectOnly(occurrences)
      ..addColumns([sumExp])
      ..where(occurrences.estado.equals(status));
    final result = await query.getSingle();
    return result.read(sumExp) ?? 0.0;
  }

  // Watch for real-time updates
  Stream<List<Occurrence>> watchAllOccurrences() {
    return (select(occurrences)..orderBy([(o) => OrderingTerm.asc(o.fechaDue)]))
        .watch();
  }

  Stream<Occurrence?> watchOccurrence(String id) {
    return (select(occurrences)..where((o) => o.id.equals(id)))
        .watchSingleOrNull();
  }

  Stream<List<Occurrence>> watchOccurrencesByStatus(String status) {
    return (select(occurrences)
          ..where((o) => o.estado.equals(status))
          ..orderBy([(o) => OrderingTerm.asc(o.fechaDue)]))
        .watch();
  }

  Stream<List<OccurrenceWithDetails>> watchOccurrencesWithDetailsByDateRange(
      DateTime startDate, DateTime endDate) {
    final startTimestamp = _getStartOfDay(startDate).millisecondsSinceEpoch;
    final endTimestamp = _getEndOfDay(endDate).millisecondsSinceEpoch;

    final query = select(occurrences).join([
      innerJoin(
          debtTemplates, debtTemplates.id.equalsExp(occurrences.templateId)),
      leftOuterJoin(cards, cards.id.equalsExp(occurrences.cardId)),
      leftOuterJoin(payments, payments.occurrenceId.equalsExp(occurrences.id)),
      leftOuterJoin(paymentMethods,
          paymentMethods.id.equalsExp(debtTemplates.paymentMethodId))
    ])
      ..where(
          occurrences.fechaDue.isBetweenValues(startTimestamp, endTimestamp))
      ..orderBy([OrderingTerm.asc(occurrences.fechaDue)]);

    return query.watch().map((rows) => rows
        .map((row) => OccurrenceWithDetails(
              occurrence: row.readTable(occurrences),
              template: row.readTable(debtTemplates),
              card: row.readTableOrNull(cards),
              payment: row.readTableOrNull(payments),
              paymentMethod: row.readTableOrNull(paymentMethods),
            ))
        .toList());
  }

  // Sum watchers for occurrences between dates filtered by states
  Stream<double> watchSumOccurrencesBetween(
      DateTime startDate, DateTime endDate,
      {required List<String> estados}) {
    final start = _getStartOfDay(startDate).millisecondsSinceEpoch;
    final end = _getEndOfDay(endDate).millisecondsSinceEpoch;
    final sumExp = occurrences.monto.sum();

    final query = selectOnly(occurrences)
      ..addColumns([sumExp])
      ..where(occurrences.fechaDue.isBetweenValues(start, end) &
          occurrences.estado.isIn(estados));

    return query.watchSingleOrNull().map((row) => row?.read(sumExp) ?? 0.0);
  }

  // Count watchers for occurrences between dates filtered by states
  Stream<int> watchCountOccurrencesBetween(DateTime startDate, DateTime endDate,
      {required List<String> estados}) {
    final start = _getStartOfDay(startDate).millisecondsSinceEpoch;
    final end = _getEndOfDay(endDate).millisecondsSinceEpoch;
    final countExp = occurrences.id.count();

    final query = selectOnly(occurrences)
      ..addColumns([countExp])
      ..where(occurrences.fechaDue.isBetweenValues(start, end) &
          occurrences.estado.isIn(estados));

    return query.watchSingleOrNull().map((row) => row?.read(countExp) ?? 0);
  }

  // Upcoming with details
  Stream<List<OccurrenceWithDetails>> watchUpcomingWithDetails(DateTime from,
      {int limit = 5}) {
    final start =
        DateTime(from.year, from.month, from.day).millisecondsSinceEpoch;
    final query = select(occurrences).join([
      innerJoin(
          debtTemplates, debtTemplates.id.equalsExp(occurrences.templateId)),
      leftOuterJoin(cards, cards.id.equalsExp(occurrences.cardId)),
      leftOuterJoin(payments, payments.occurrenceId.equalsExp(occurrences.id)),
      leftOuterJoin(paymentMethods,
          paymentMethods.id.equalsExp(debtTemplates.paymentMethodId))
    ])
      ..where(occurrences.estado.isIn(['PENDING', 'NEAR', 'DUE_TODAY']) &
          occurrences.fechaDue.isBiggerOrEqualValue(start))
      ..orderBy([OrderingTerm.asc(occurrences.fechaDue)])
      ..limit(limit);

    return query.watch().map((rows) => rows
        .map((row) => OccurrenceWithDetails(
              occurrence: row.readTable(occurrences),
              template: row.readTable(debtTemplates),
              card: row.readTableOrNull(cards),
              payment: row.readTableOrNull(payments),
              paymentMethod: row.readTableOrNull(paymentMethods),
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
class OccurrenceWithDetails {
  final Occurrence occurrence;
  final DebtTemplate template;
  final Card? card;
  final Payment? payment;
  final PaymentMethod? paymentMethod;

  OccurrenceWithDetails({
    required this.occurrence,
    required this.template,
    this.card,
    this.payment,
    this.paymentMethod,
  });

  bool get isPaid => payment != null;
  String get templateName => template.nombre;
  String? get cardName => card?.nombre;
  double get paidAmount => payment?.montoPagado ?? 0.0;
  String? get paymentMethodAlias => paymentMethod?.alias;
}
