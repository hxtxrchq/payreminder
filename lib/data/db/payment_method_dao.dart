import 'package:drift/drift.dart';
import '../db/app_database.dart';

part 'payment_method_dao.g.dart';

@DriftAccessor(tables: [PaymentMethods])
class PaymentMethodDao extends DatabaseAccessor<AppDatabase>
    with _$PaymentMethodDaoMixin {
  PaymentMethodDao(AppDatabase db) : super(db);

  Future<String> insertPaymentMethod(PaymentMethodsCompanion method) async {
    await into(paymentMethods).insert(method);
    return method.id.value;
  }

  Future<bool> updatePaymentMethod(PaymentMethodsCompanion method) async {
    final result = await (update(paymentMethods)
          ..where((t) => t.id.equals(method.id.value)))
        .write(method);
    return result > 0;
  }

  Future<bool> deletePaymentMethod(String id) async {
    final result =
        await (delete(paymentMethods)..where((t) => t.id.equals(id))).go();
    return result > 0;
  }

  Future<PaymentMethod?> getById(String id) async {
    return await (select(paymentMethods)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<PaymentMethod>> getAll() async {
    return await (select(paymentMethods)
          ..orderBy([
            (t) => OrderingTerm.desc(t.isDefault),
            (t) => OrderingTerm.asc(t.alias),
          ]))
        .get();
  }

  Stream<List<PaymentMethod>> watchAll() {
    return (select(paymentMethods)
          ..orderBy([
            (t) => OrderingTerm.desc(t.isDefault),
            (t) => OrderingTerm.asc(t.alias),
          ]))
        .watch();
  }

  Future<void> setDefault(String id) async {
    await customStatement('UPDATE payment_methods SET is_default = 0');
    await (update(paymentMethods)..where((t) => t.id.equals(id))).write(
      const PaymentMethodsCompanion(isDefault: Value(true)),
    );
  }
}
