import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/db/app_database.dart';
import '../../data/db/category_dao.dart';
import '../../data/repos/category_repository.dart';
import 'database_providers.dart';

final categoryDaoProvider = Provider<CategoryDao>((ref) {
  final db = ref.read(databaseProvider);
  return CategoryDao(db);
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final dao = ref.read(categoryDaoProvider);
  return CategoryRepository(dao);
});

final categoriesStreamProvider =
    StreamProvider.autoDispose<List<Category>>((ref) {
  return ref.read(categoryRepositoryProvider).watchAll();
});

final createCategoryProvider =
    FutureProvider.family<bool, ({String name})>((ref, data) async {
  final repo = ref.read(categoryRepositoryProvider);
  final id = 'cat_${DateTime.now().millisecondsSinceEpoch}';
  final createdId = await repo.create(id: id, name: data.name);
  return createdId != null;
});

final updateCategoryProvider =
    FutureProvider.family<bool, ({String id, String? name})>((ref, data) async {
  final repo = ref.read(categoryRepositoryProvider);
  return repo.update(id: data.id, name: data.name);
});

final deleteCategoryProvider =
    FutureProvider.family<bool, String>((ref, id) async {
  final repo = ref.read(categoryRepositoryProvider);
  return repo.delete(id);
});
