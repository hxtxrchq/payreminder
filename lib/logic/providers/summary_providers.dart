import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/month_summary.dart';
import 'repository_providers.dart';

// MonthSummary DTO moved to domain/models/month_summary.dart

final monthSummaryProvider = StreamProvider.autoDispose<MonthSummary>((ref) {
  final occRepo = ref.watch(occurrenceRepositoryProvider);
  final payRepo = ref.watch(paymentRepositoryProvider);

  final now = DateTime.now();
  final start = DateTime(now.year, now.month, 1);
  final end = DateTime(now.year, now.month + 1, 1);

  return occRepo.watchMonthSummary(start, end, payRepo);
});
