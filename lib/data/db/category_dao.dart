import 'package:drift/drift.dart';
import 'app_database.dart';

part 'category_dao.g.dart';

@DriftAccessor(tables: [Categories])
class CategoryDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryDaoMixin {
  CategoryDao(AppDatabase db) : super(db);

  Future<bool> existsByNameCi(String name) async {
    final countExp = categories.id.count();
    final q = selectOnly(categories)..addColumns([countExp]);
    q.where(categories.name.lower().equals(name.toLowerCase()));
    final row = await q.getSingle();
    final count = row.read(countExp) ?? 0;
    return count > 0;
  }

  Future<bool> existsByNameCiExcludingId(
      {required String name, required String excludeId}) async {
    final countExp = categories.id.count();
    final q = selectOnly(categories)..addColumns([countExp]);
    q.where(categories.name.lower().equals(name.toLowerCase()) &
        categories.id.isNotIn([excludeId]));
    final row = await q.getSingle();
    final count = row.read(countExp) ?? 0;
    return count > 0;
  }

  Future<String> insertCategory(CategoriesCompanion cat) async {
    await into(categories).insert(cat);
    return cat.id.value;
  }

  Future<bool> updateCategory(CategoriesCompanion cat) async {
    final result = await (update(categories)
          ..where((c) => c.id.equals(cat.id.value)))
        .write(cat);
    return result > 0;
  }

  Future<bool> deleteCategory(String id) async {
    final result =
        await (delete(categories)..where((c) => c.id.equals(id))).go();
    return result > 0;
  }

  Future<List<Category>> getAll() async {
    return await (select(categories)
          ..orderBy([(c) => OrderingTerm.asc(c.name)]))
        .get();
  }

  Stream<List<Category>> watchAll() {
    return (select(categories)..orderBy([(c) => OrderingTerm.asc(c.name)]))
        .watch();
  }
}
