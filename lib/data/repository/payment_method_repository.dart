import 'package:drift/drift.dart';
import '../db/app_database.dart';
import '../db/payment_method_dao.dart';

class PaymentMethodRepository {
  final PaymentMethodDao _dao;
  PaymentMethodRepository(this._dao);

  Future<String> create({
    required String id,
    required String type,
    required String alias,
    String? last4,
    String? issuer,
    bool isDefault = false,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final companion = PaymentMethodsCompanion(
      id: Value(id),
      type: Value(type),
      alias: Value(alias),
      last4: Value(last4),
      issuer: Value(issuer),
      isDefault: Value(isDefault),
      createdAt: Value(now),
    );
    return _dao.insertPaymentMethod(companion);
  }

  Future<bool> update({
    required String id,
    String? type,
    String? alias,
    String? last4,
    String? issuer,
    bool? isDefault,
  }) async {
    final companion = PaymentMethodsCompanion(
      id: Value(id),
      type: type != null ? Value(type) : const Value.absent(),
      alias: alias != null ? Value(alias) : const Value.absent(),
      last4: last4 != null ? Value(last4) : const Value.absent(),
      issuer: issuer != null ? Value(issuer) : const Value.absent(),
      isDefault: isDefault != null ? Value(isDefault) : const Value.absent(),
    );
    return _dao.updatePaymentMethod(companion);
  }

  Future<bool> delete(String id) => _dao.deletePaymentMethod(id);

  Future<PaymentMethod?> getById(String id) => _dao.getById(id);

  Future<List<PaymentMethod>> getAll() => _dao.getAll();

  Stream<List<PaymentMethod>> watchAll() => _dao.watchAll();

  Future<void> setDefault(String id) => _dao.setDefault(id);
}
