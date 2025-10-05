import 'package:drift/drift.dart';
import '../db/app_database.dart';
import '../db/category_dao.dart';

class CategoryRepository {
  final CategoryDao _dao;

  CategoryRepository(this._dao);

  Future<String?> create({
    required String id,
    required String name,
  }) async {
    // Validación de unicidad case-insensitive
    if (await _dao.existsByNameCi(name)) {
      return null;
    }
    final now = DateTime.now().millisecondsSinceEpoch;
    final companion = CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(now),
    );
    return _dao.insertCategory(companion);
  }

  Future<bool> update({
    required String id,
    String? name,
  }) async {
    if (name != null) {
      final exists =
          await _dao.existsByNameCiExcludingId(name: name, excludeId: id);
      if (exists) return false;
    }
    final companion = CategoriesCompanion(
      id: Value(id),
      name: name != null ? Value(name) : const Value.absent(),
    );
    return _dao.updateCategory(companion);
  }

  Future<bool> delete(String id) => _dao.deleteCategory(id);

  Future<List<Category>> getAll() => _dao.getAll();

  Stream<List<Category>> watchAll() => _dao.watchAll();
}
