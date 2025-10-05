import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/db/app_database.dart';
import '../../logic/providers/repository_providers.dart';

// StreamProvider para métodos de pago, útil para refresco automático en UI dependiente
final paymentMethodsProvider = StreamProvider<List<PaymentMethod>>((ref) {
  final repo = ref.watch(paymentMethodRepositoryProvider);
  return repo.watchAll();
});
