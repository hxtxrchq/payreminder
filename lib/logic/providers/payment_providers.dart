import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/db/app_database.dart';
import '../../data/repos/payment_repository.dart';
import '../../app/formatters/money.dart';
import 'repository_providers.dart';

// Provider para obtener todos los pagos
final paymentsProvider = StreamProvider<List<Payment>>((ref) {
  final paymentRepository = ref.watch(paymentRepositoryProvider);
  return paymentRepository.watchAllPayments();
});

// Provider para pagos por ocurrencia
final paymentsByOccurrenceProvider =
    StreamProviderFamily<List<Payment>, String>((ref, occurrenceId) {
  final paymentRepository = ref.watch(paymentRepositoryProvider);
  return paymentRepository.watchAllPayments().map((payments) =>
      payments.where((p) => p.occurrenceId == occurrenceId).toList());
});

// Provider para pagos de este mes
final thisMonthPaymentsProvider = StreamProvider<List<Payment>>((ref) {
  final paymentRepository = ref.watch(paymentRepositoryProvider);
  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month, 1).millisecondsSinceEpoch;
  final endOfMonth =
      DateTime(now.year, now.month + 1, 0, 23, 59, 59).millisecondsSinceEpoch;
  return paymentRepository.watchAllPayments().map((payments) => payments
      .where((p) => p.fechaPago >= startOfMonth && p.fechaPago <= endOfMonth)
      .toList());
});

// Provider para un pago específico
final paymentProvider =
    StreamProviderFamily<Payment?, String>((ref, paymentId) {
  final paymentRepository = ref.watch(paymentRepositoryProvider);
  return paymentRepository.watchPayment(paymentId);
});

// Provider para estadísticas de pagos
final paymentStatsProvider = FutureProvider<PaymentStats>((ref) async {
  final paymentRepository = ref.watch(paymentRepositoryProvider);

  // Obtener pagos de este mes
  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month, 1);
  final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

  final thisMonthPayments =
      await paymentRepository.getPaymentsByDateRange(startOfMonth, endOfMonth);
  final allPayments = await paymentRepository.getAllPayments();

  // Calcular estadísticas
  final totalAmountThisMonth =
      thisMonthPayments.fold<double>(0.0, (sum, p) => sum + p.montoPagado);
  final totalAmountAllTime =
      allPayments.fold<double>(0.0, (sum, p) => sum + p.montoPagado);

  // Obtener pagos del mes anterior para comparación
  final lastMonth = DateTime(now.year, now.month - 1, 1);
  final endOfLastMonth = DateTime(now.year, now.month, 0, 23, 59, 59);
  final lastMonthPayments =
      await paymentRepository.getPaymentsByDateRange(lastMonth, endOfLastMonth);
  final totalAmountLastMonth =
      lastMonthPayments.fold<double>(0.0, (sum, p) => sum + p.montoPagado);

  // Agrupar por método de pago
  final Map<String, PaymentMethodStats> byMethod = {};
  for (final payment in thisMonthPayments) {
    final method = payment.metodoPago ?? 'EFECTIVO';
    if (byMethod[method] == null) {
      byMethod[method] =
          PaymentMethodStats(method: method, count: 0, totalAmount: 0.0);
    }
    byMethod[method] = byMethod[method]!.copyWith(
      count: byMethod[method]!.count + 1,
      totalAmount: byMethod[method]!.totalAmount + payment.montoPagado,
    );
  }

  // Agrupar por día del mes (para gráficos)
  final Map<int, double> dailyAmounts = {};
  for (int day = 1; day <= DateTime(now.year, now.month + 1, 0).day; day++) {
    dailyAmounts[day] = 0.0;
  }

  for (final payment in thisMonthPayments) {
    final paymentDate = DateTime.fromMillisecondsSinceEpoch(payment.fechaPago);
    dailyAmounts[paymentDate.day] =
        (dailyAmounts[paymentDate.day] ?? 0.0) + payment.montoPagado;
  }

  return PaymentStats(
    totalPaymentsThisMonth: thisMonthPayments.length,
    totalAmountThisMonth: totalAmountThisMonth,
    totalPaymentsLastMonth: lastMonthPayments.length,
    totalAmountLastMonth: totalAmountLastMonth,
    totalPaymentsAllTime: allPayments.length,
    totalAmountAllTime: totalAmountAllTime,
    averagePaymentAmount: thisMonthPayments.isNotEmpty
        ? totalAmountThisMonth / thisMonthPayments.length
        : 0.0,
    paymentMethodStats: byMethod.values.toList(),
    dailyAmounts: dailyAmounts,
  );
});

// Provider para el formulario de pagos
final paymentFormProvider =
    StateNotifierProvider<PaymentFormNotifier, PaymentFormState>((ref) {
  final paymentRepository = ref.watch(paymentRepositoryProvider);
  return PaymentFormNotifier(paymentRepository);
});

// Estado del formulario de pago
class PaymentFormState {
  final String? id;
  final String? occurrenceId;
  final double monto;
  final DateTime fechaPago;
  final String metodoPago;
  final String? notas;
  final bool isLoading;
  final String? error;
  final bool isEditing;

  PaymentFormState({
    this.id,
    this.occurrenceId,
    this.monto = 0.0,
    DateTime? fechaPago,
    this.metodoPago = 'EFECTIVO',
    this.notas,
    this.isLoading = false,
    this.error,
    this.isEditing = false,
  }) : fechaPago = fechaPago ?? DateTime.now();

  PaymentFormState copyWith({
    String? id,
    String? occurrenceId,
    double? monto,
    DateTime? fechaPago,
    String? metodoPago,
    String? notas,
    bool? isLoading,
    String? error,
    bool? isEditing,
  }) {
    return PaymentFormState(
      id: id ?? this.id,
      occurrenceId: occurrenceId ?? this.occurrenceId,
      monto: monto ?? this.monto,
      fechaPago: fechaPago ?? this.fechaPago,
      metodoPago: metodoPago ?? this.metodoPago,
      notas: notas ?? this.notas,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isEditing: isEditing ?? this.isEditing,
    );
  }

  bool get isValid =>
      occurrenceId != null && occurrenceId!.isNotEmpty && monto > 0;
  bool get canSave => isValid && !isLoading;
}

// Notifier para el formulario de pagos
class PaymentFormNotifier extends StateNotifier<PaymentFormState> {
  final PaymentRepository _paymentRepository;

  PaymentFormNotifier(this._paymentRepository) : super(PaymentFormState());

  void updateOccurrenceId(String? occurrenceId) {
    state = state.copyWith(occurrenceId: occurrenceId, error: null);
  }

  void updateMonto(double monto) {
    state = state.copyWith(monto: monto, error: null);
  }

  void updateFechaPago(DateTime fechaPago) {
    state = state.copyWith(fechaPago: fechaPago, error: null);
  }

  void updateMetodoPago(String metodoPago) {
    state = state.copyWith(metodoPago: metodoPago, error: null);
  }

  void updateNotas(String? notas) {
    state = state.copyWith(notas: notas, error: null);
  }

  void loadPayment(Payment payment) {
    state = PaymentFormState(
      id: payment.id,
      occurrenceId: payment.occurrenceId,
      monto: payment.montoPagado,
      fechaPago: DateTime.fromMillisecondsSinceEpoch(payment.fechaPago),
      metodoPago: payment.metodoPago ?? 'EFECTIVO',
      notas: payment.notas,
      isEditing: true,
    );
  }

  void loadFromOccurrence(String occurrenceId, double suggestedAmount) {
    state = PaymentFormState(
      occurrenceId: occurrenceId,
      monto: suggestedAmount,
      fechaPago: DateTime.now(),
      metodoPago: 'EFECTIVO',
    );
  }

  void clearForm() {
    state = PaymentFormState();
  }

  Future<bool> savePayment() async {
    if (!state.canSave) return false;

    state = state.copyWith(isLoading: true, error: null);

    try {
      if (state.isEditing && state.id != null) {
        // Actualizar pago existente
        final success = await _paymentRepository.updatePayment(
          id: state.id!,
          montoPagado: state.monto,
          fechaPago: state.fechaPago,
        );

        if (success) {
          clearForm();
          return true;
        } else {
          state = state.copyWith(
              isLoading: false, error: 'Error actualizando el pago');
          return false;
        }
      } else {
        // Crear nuevo pago
        final paymentId = await _paymentRepository.createPayment(
          id: 'payment_${DateTime.now().millisecondsSinceEpoch}',
          occurrenceId: state.occurrenceId!,
          montoPagado: state.monto,
          fechaPago: state.fechaPago,
        );

        if (paymentId.isNotEmpty) {
          clearForm();
          return true;
        } else {
          state =
              state.copyWith(isLoading: false, error: 'Error creando el pago');
          return false;
        }
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Error: $e');
      return false;
    }
  }

  Future<bool> deletePayment(String paymentId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final success = await _paymentRepository.deletePayment(paymentId);

      if (success) {
        clearForm();
        return true;
      } else {
        state =
            state.copyWith(isLoading: false, error: 'Error eliminando el pago');
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Error: $e');
      return false;
    }
  }

  // Validaciones
  String? validateMonto(double? value) {
    if (value == null || value <= 0) {
      return 'El monto debe ser mayor a 0';
    }
    if (value > 999999) {
      return 'El monto es demasiado alto';
    }
    return null;
  }

  String? validateOccurrenceId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Debe seleccionar una ocurrencia';
    }
    return null;
  }

  // Métodos de utilidad
  List<String> getPaymentMethods() {
    return [
      'EFECTIVO',
      'TARJETA_DEBITO',
      'TARJETA_CREDITO',
      'TRANSFERENCIA',
      'BILLETERA_DIGITAL',
      'CHEQUE',
      'OTRO',
    ];
  }

  String getPaymentMethodDisplayName(String method) {
    switch (method) {
      case 'EFECTIVO':
        return 'Efectivo';
      case 'TARJETA_DEBITO':
        return 'Tarjeta de Débito';
      case 'TARJETA_CREDITO':
        return 'Tarjeta de Crédito';
      case 'TRANSFERENCIA':
        return 'Transferencia';
      case 'BILLETERA_DIGITAL':
        return 'Billetera Digital';
      case 'CHEQUE':
        return 'Cheque';
      case 'OTRO':
        return 'Otro';
      default:
        return method;
    }
  }

  String formatMonto(double monto) {
    return formatMoney(monto);
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

// Clase para estadísticas de pagos
class PaymentStats {
  final int totalPaymentsThisMonth;
  final double totalAmountThisMonth;
  final int totalPaymentsLastMonth;
  final double totalAmountLastMonth;
  final int totalPaymentsAllTime;
  final double totalAmountAllTime;
  final double averagePaymentAmount;
  final List<PaymentMethodStats> paymentMethodStats;
  final Map<int, double> dailyAmounts;

  PaymentStats({
    required this.totalPaymentsThisMonth,
    required this.totalAmountThisMonth,
    required this.totalPaymentsLastMonth,
    required this.totalAmountLastMonth,
    required this.totalPaymentsAllTime,
    required this.totalAmountAllTime,
    required this.averagePaymentAmount,
    required this.paymentMethodStats,
    required this.dailyAmounts,
  });

  double get monthOverMonthGrowth {
    if (totalAmountLastMonth == 0) return 0.0;
    return ((totalAmountThisMonth - totalAmountLastMonth) /
            totalAmountLastMonth) *
        100;
  }

  PaymentMethodStats? get mostUsedPaymentMethod {
    if (paymentMethodStats.isEmpty) return null;
    return paymentMethodStats.reduce((a, b) => a.count > b.count ? a : b);
  }

  double get maxDailyAmount => dailyAmounts.values.isNotEmpty
      ? dailyAmounts.values.reduce((a, b) => a > b ? a : b)
      : 0.0;
}

// Clase para estadísticas por método de pago
class PaymentMethodStats {
  final String method;
  final int count;
  final double totalAmount;

  PaymentMethodStats({
    required this.method,
    required this.count,
    required this.totalAmount,
  });

  PaymentMethodStats copyWith({
    String? method,
    int? count,
    double? totalAmount,
  }) {
    return PaymentMethodStats(
      method: method ?? this.method,
      count: count ?? this.count,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }

  double get averageAmount => count > 0 ? totalAmount / count : 0.0;
  double get percentage => 0.0; // Se calculará en el contexto del total
}
