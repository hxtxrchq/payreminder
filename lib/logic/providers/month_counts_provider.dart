import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'repository_providers.dart';

class MonthCounts {
  final int pendientes; // PENDING + NEAR + DUE_TODAY
  final int vencidos; // OVERDUE
  final int pagados; // PAID (count by occurrences marked PAID in month)
  const MonthCounts(
      {required this.pendientes,
      required this.vencidos,
      required this.pagados});
}

const kPendingLike = ['PENDING', 'NEAR', 'DUE_TODAY'];
const kOverdue = ['OVERDUE'];
const kPaid = ['PAID'];

final monthCountsProvider = StreamProvider.autoDispose<MonthCounts>((ref) {
  final occRepo = ref.watch(occurrenceRepositoryProvider);
  final now = DateTime.now();
  final start = DateTime(now.year, now.month, 1);
  final end = DateTime(now.year, now.month + 1, 1);

  final pending$ = occRepo.watchCountOccurrencesBetween(start, end,
      whereEstadoIn: kPendingLike);
  final overdue$ =
      occRepo.watchCountOccurrencesBetween(start, end, whereEstadoIn: kOverdue);
  final paid$ =
      occRepo.watchCountOccurrencesBetween(start, end, whereEstadoIn: kPaid);

  late final StreamController<MonthCounts> controller;
  controller = StreamController<MonthCounts>();

  int p = 0, v = 0, pg = 0;
  StreamSubscription? s1, s2, s3;

  void emit() {
    if (!controller.isClosed)
      controller.add(MonthCounts(pendientes: p, vencidos: v, pagados: pg));
  }

  s1 = pending$.listen((x) {
    p = x;
    emit();
  });
  s2 = overdue$.listen((x) {
    v = x;
    emit();
  });
  s3 = paid$.listen((x) {
    pg = x;
    emit();
  });

  controller.onCancel = () {
    s1?.cancel();
    s2?.cancel();
    s3?.cancel();
  };

  return controller.stream;
});
