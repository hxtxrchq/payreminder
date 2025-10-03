import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../data/db/app_database.dart';
import '../../data/db/occurrence_dao.dart';
import '../../domain/usecases/mark_paid_usecase.dart';
import '../../domain/usecases/update_occurrence_statuses_usecase.dart';
import 'repository_providers.dart';
import 'usecase_providers.dart';
import '../../domain/models/month_kpis.dart';

// Provider para obtener todas las ocurrencias
final occurrencesProvider = StreamProvider<List<Occurrence>>((ref) {
  final occurrenceRepository = ref.watch(occurrenceRepositoryProvider);
  return occurrenceRepository.watchAllOccurrences();
});

// Provider para ocurrencias por estado
final occurrencesByStatusProvider =
    StreamProviderFamily<List<Occurrence>, String>((ref, status) {
  final occurrenceRepository = ref.watch(occurrenceRepositoryProvider);
  return occurrenceRepository.watchOccurrencesByStatus(status);
});

// Provider para ocurrencias pendientes
final pendingOccurrencesProvider = StreamProvider<List<Occurrence>>((ref) {
  final occurrenceRepository = ref.watch(occurrenceRepositoryProvider);
  return occurrenceRepository.watchOccurrencesByStatus('PENDING');
});

// Provider para ocurrencias vencidas
final overdueOccurrencesProvider = StreamProvider<List<Occurrence>>((ref) {
  final occurrenceRepository = ref.watch(occurrenceRepositoryProvider);
  return occurrenceRepository.watchOccurrencesByStatus('OVERDUE');
});

// Provider para ocurrencias de hoy
final todayOccurrencesProvider =
    StreamProvider<List<OccurrenceWithDetails>>((ref) {
  final occurrenceRepository = ref.watch(occurrenceRepositoryProvider);
  final today = DateTime.now();
  final startOfDay = DateTime(today.year, today.month, today.day);
  final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);
  return occurrenceRepository.watchOccurrencesWithDetailsByDateRange(
      startOfDay, endOfDay);
});

// Provider para ocurrencias de esta semana
final thisWeekOccurrencesProvider =
    StreamProvider<List<OccurrenceWithDetails>>((ref) {
  final occurrenceRepository = ref.watch(occurrenceRepositoryProvider);
  final now = DateTime.now();
  final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
  final endOfWeek = startOfWeek
      .add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
  return occurrenceRepository.watchOccurrencesWithDetailsByDateRange(
      startOfWeek, endOfWeek);
});

// Provider para ocurrencias de este mes
final thisMonthOccurrencesProvider =
    StreamProvider<List<OccurrenceWithDetails>>((ref) {
  final occurrenceRepository = ref.watch(occurrenceRepositoryProvider);
  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month, 1);
  final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
  return occurrenceRepository.watchOccurrencesWithDetailsByDateRange(
      startOfMonth, endOfMonth);
});

// Focused month used by calendar or any month-scoped views
final focusedMonthProvider = StateProvider<DateTime>(
    (ref) => DateTime(DateTime.now().year, DateTime.now().month, 1));

// Occurrences for a given visible month (1st day key)
final occurrencesForMonthProvider =
    StreamProvider.family<List<OccurrenceWithDetails>, DateTime>(
        (ref, monthStart) {
  final occurrenceRepository = ref.watch(occurrenceRepositoryProvider);
  final start = DateTime(monthStart.year, monthStart.month, 1);
  final end = DateTime(monthStart.year, monthStart.month + 1, 0, 23, 59, 59);
  return occurrenceRepository.watchOccurrencesWithDetailsByDateRange(
      start, end);
});

// Unified Month KPIs for a given month
final monthKpisProvider =
    StreamProvider.family.autoDispose<MonthKpis, DateTime>((ref, monthStart) {
  final occRepo = ref.watch(occurrenceRepositoryProvider);
  final payRepo = ref.watch(paymentRepositoryProvider);

  final start = DateTime(monthStart.year, monthStart.month, 1);
  final end = DateTime(monthStart.year, monthStart.month + 1, 0);

  const kPendingLike = ['PENDING', 'NEAR', 'DUE_TODAY'];
  const kOverdue = ['OVERDUE'];
  const kPaid = ['PAID'];

  final pendingAmount$ = occRepo.watchSumOccurrencesBetween(start, end,
      whereEstadoIn: kPendingLike);
  final overdueAmount$ =
      occRepo.watchSumOccurrencesBetween(start, end, whereEstadoIn: kOverdue);
  final paidAmount$ = payRepo.watchSumPaidBetween(start, end);

  final pendingCount$ = occRepo.watchCountOccurrencesBetween(start, end,
      whereEstadoIn: kPendingLike);
  final overdueCount$ =
      occRepo.watchCountOccurrencesBetween(start, end, whereEstadoIn: kOverdue);
  final paidCount$ =
      occRepo.watchCountOccurrencesBetween(start, end, whereEstadoIn: kPaid);

  late final StreamController<MonthKpis> controller;
  controller = StreamController<MonthKpis>();

  int pCount = 0, oCount = 0, pdCount = 0;
  double pAmt = 0, oAmt = 0, pdAmt = 0;

  void emit() {
    if (!controller.isClosed) {
      controller.add(MonthKpis(
        pendingCount: pCount,
        paidCount: pdCount,
        overdueCount: oCount,
        pendingAmount: pAmt,
        paidAmount: pdAmt,
        overdueAmount: oAmt,
      ));
    }
  }

  final s = <StreamSubscription>[];
  s.add(pendingAmount$.listen((v) {
    pAmt = v;
    emit();
  }));
  s.add(overdueAmount$.listen((v) {
    oAmt = v;
    emit();
  }));
  s.add(paidAmount$.listen((v) {
    pdAmt = v;
    emit();
  }));
  s.add(pendingCount$.listen((v) {
    pCount = v;
    emit();
  }));
  s.add(overdueCount$.listen((v) {
    oCount = v;
    emit();
  }));
  s.add(paidCount$.listen((v) {
    pdCount = v;
    emit();
  }));

  controller.onCancel = () {
    for (final sub in s) {
      sub.cancel();
    }
  };

  return controller.stream;
});

// Provider para próximos pagos con detalles (a partir de hoy, límite 5)
final upcomingOccurrencesWithDetailsProvider =
    StreamProvider<List<OccurrenceWithDetails>>((ref) {
  final occurrenceRepository = ref.watch(occurrenceRepositoryProvider);
  final now = DateTime.now();
  final startOfToday = DateTime(now.year, now.month, now.day);
  return occurrenceRepository.watchUpcoming(startOfToday, limit: 5);
});

// Provider para ocurrencias por fecha específica
final occurrencesByDateProvider =
    StreamProviderFamily<List<OccurrenceWithDetails>, DateTime>((ref, date) {
  final occurrenceRepository = ref.watch(occurrenceRepositoryProvider);
  final startOfDay = DateTime(date.year, date.month, date.day);
  final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
  return occurrenceRepository.watchOccurrencesWithDetailsByDateRange(
      startOfDay, endOfDay);
});

// Provider para una ocurrencia específica
final occurrenceProvider =
    StreamProviderFamily<Occurrence?, String>((ref, occurrenceId) {
  final occurrenceRepository = ref.watch(occurrenceRepositoryProvider);
  return occurrenceRepository.watchOccurrence(occurrenceId);
});

// Provider para estadísticas del dashboard
final dashboardStatsProvider = FutureProvider<DashboardStats>((ref) async {
  final occurrenceRepository = ref.watch(occurrenceRepositoryProvider);

  // Obtener ocurrencias de este mes
  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month, 1);
  final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

  final thisMonthOccurrences = await occurrenceRepository
      .getOccurrencesByDateRange(startOfMonth, endOfMonth);
  final pendingOccurrences = await occurrenceRepository.getPendingOccurrences();
  final paidOccurrences = await occurrenceRepository.getPaidOccurrences();
  final overdueOccurrences = await occurrenceRepository.getOverdueOccurrences();

  // Calcular montos
  final totalPendingAmount =
      pendingOccurrences.fold<double>(0.0, (sum, o) => sum + o.monto);
  final totalPaidAmount =
      paidOccurrences.fold<double>(0.0, (sum, o) => sum + o.monto);
  final totalOverdueAmount =
      overdueOccurrences.fold<double>(0.0, (sum, o) => sum + o.monto);

  // Ocurrencias que vencen hoy
  final dueTodayOccurrences =
      await occurrenceRepository.getDueTodayOccurrences();

  // Próximas en 7 días (usar método near)
  final upcomingOccurrences = await occurrenceRepository.getNearOccurrences();

  return DashboardStats(
    totalOccurrencesThisMonth: thisMonthOccurrences.length,
    pendingCount: pendingOccurrences.length,
    paidCount: paidOccurrences.length,
    overdueCount: overdueOccurrences.length,
    dueTodayCount: dueTodayOccurrences.length,
    upcomingWeekCount: upcomingOccurrences.length,
    totalPendingAmount: totalPendingAmount,
    totalPaidAmount: totalPaidAmount,
    totalOverdueAmount: totalOverdueAmount,
    paymentRate: thisMonthOccurrences.isNotEmpty
        ? (paidOccurrences.length / thisMonthOccurrences.length)
        : 0.0,
  );
});

// Provider para el estado de acciones rápidas
final quickActionsProvider =
    StateNotifierProvider<QuickActionsNotifier, QuickActionsState>((ref) {
  final markPaidUseCase = ref.watch(markPaidUseCaseProvider);
  final updateStatusesUseCase =
      ref.watch(updateOccurrenceStatusesUseCaseProvider);
  return QuickActionsNotifier(markPaidUseCase, updateStatusesUseCase);
});

// Estado para acciones rápidas
class QuickActionsState {
  final bool isLoading;
  final String? error;
  final String? successMessage;

  QuickActionsState({
    this.isLoading = false,
    this.error,
    this.successMessage,
  });

  QuickActionsState copyWith({
    bool? isLoading,
    String? error,
    String? successMessage,
  }) {
    return QuickActionsState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      successMessage: successMessage,
    );
  }
}

// Notifier para acciones rápidas
class QuickActionsNotifier extends StateNotifier<QuickActionsState> {
  final MarkPaidUseCase _markPaidUseCase;
  final UpdateOccurrenceStatusesUseCase _updateStatusesUseCase;

  QuickActionsNotifier(this._markPaidUseCase, this._updateStatusesUseCase)
      : super(QuickActionsState());

  Future<bool> markAsPaid(String occurrenceId, {double? amount}) async {
    state = state.copyWith(isLoading: true, error: null, successMessage: null);

    try {
      final result = await _markPaidUseCase.execute(
        occurrenceId: occurrenceId,
        amountPaid: amount,
      );

      if (result.isSuccess) {
        state = state.copyWith(
          isLoading: false,
          successMessage: 'Pago registrado exitosamente',
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result.error ?? 'Error marcando como pagado',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error inesperado: $e',
      );
      return false;
    }
  }

  Future<bool> markAsOverdue(List<String> occurrenceIds) async {
    state = state.copyWith(isLoading: true, error: null, successMessage: null);

    try {
      final result = await _updateStatusesUseCase.markAsOverdue(occurrenceIds);

      if (result.isSuccess) {
        state = state.copyWith(
          isLoading: false,
          successMessage: 'Estados actualizados exitosamente',
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result.generalError ?? 'Error actualizando estados',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error inesperado: $e',
      );
      return false;
    }
  }

  Future<bool> cancelOccurrence(String occurrenceId, String reason) async {
    state = state.copyWith(isLoading: true, error: null, successMessage: null);

    try {
      final result =
          await _updateStatusesUseCase.cancelOccurrence(occurrenceId, reason);

      if (result.isSuccess) {
        state = state.copyWith(
          isLoading: false,
          successMessage: 'Ocurrencia cancelada exitosamente',
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result.generalError ?? 'Error cancelando ocurrencia',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error inesperado: $e',
      );
      return false;
    }
  }

  void clearMessages() {
    state = state.copyWith(error: null, successMessage: null);
  }
}

// Clase para estadísticas del dashboard
class DashboardStats {
  final int totalOccurrencesThisMonth;
  final int pendingCount;
  final int paidCount;
  final int overdueCount;
  final int dueTodayCount;
  final int upcomingWeekCount;
  final double totalPendingAmount;
  final double totalPaidAmount;
  final double totalOverdueAmount;
  final double paymentRate;

  DashboardStats({
    required this.totalOccurrencesThisMonth,
    required this.pendingCount,
    required this.paidCount,
    required this.overdueCount,
    required this.dueTodayCount,
    required this.upcomingWeekCount,
    required this.totalPendingAmount,
    required this.totalPaidAmount,
    required this.totalOverdueAmount,
    required this.paymentRate,
  });

  double get totalAmount =>
      totalPendingAmount + totalPaidAmount + totalOverdueAmount;

  String get paymentRatePercentage =>
      '${(paymentRate * 100).toStringAsFixed(1)}%';

  bool get hasOverduePayments => overdueCount > 0;
  bool get hasPaymentsDueToday => dueTodayCount > 0;

  String get statusSummary {
    if (hasOverduePayments) return 'Tienes pagos vencidos';
    if (hasPaymentsDueToday) return 'Tienes pagos que vencen hoy';
    if (upcomingWeekCount > 0) return 'Tienes pagos próximos esta semana';
    return 'Todo al día';
  }
}
