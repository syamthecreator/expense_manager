import 'package:expense_manager/core/services/database/app_database.dart';
import 'package:expense_manager/core/services/database/database_schema.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../model/category_model.dart';

class CategoryRepository {
  final _uuid = const Uuid();

  // Fetch all non-deleted categories
  Future<List<CategoryModel>> getCategories() async {
    final db = await AppDatabase.instance.database;

    final result = await db.query(
      DatabaseSchema.categoriesTable,
      where: '${DatabaseSchema.isDeleted} = 0',
      orderBy: DatabaseSchema.categoryName,
    );

    return result.map(CategoryModel.fromMap).toList();
  }

  // Add new category
  Future<void> addCategory(String name) async {
    final db = await AppDatabase.instance.database;

    final category = CategoryModel(id: _uuid.v4(), name: name);

    await db.insert(DatabaseSchema.categoriesTable, category.toMap());
  }

  // Soft delete category
  Future<void> deleteCategory(String categoryId) async {
    final db = await AppDatabase.instance.database;

    await db.update(
      DatabaseSchema.categoriesTable,
      {DatabaseSchema.isDeleted: 1, DatabaseSchema.isSynced: 0},
      where: '${DatabaseSchema.id} = ?',
      whereArgs: [categoryId],
    );
  }

  // INSERT DEFAULT CATEGORIES (ONLY ONCE)
  Future<void> seedDefaultCategories() async {
    final db = await AppDatabase.instance.database;

    final existing = await getCategories();
    if (existing.isNotEmpty) return;

    const defaults = ['Food', 'Bills', 'Transport', 'Shopping'];

    final batch = db.batch();

    for (final name in defaults) {
      batch.insert(
        DatabaseSchema.categoriesTable,
        CategoryModel(id: _uuid.v4(), name: name).toMap(),
      );
    }

    await batch.commit(noResult: true);
  }

  /// Bulk insert from API (unchanged)
  Future<void> insertFromApi(List<CategoryModel> categories) async {
    final db = await AppDatabase.instance.database;

    final batch = db.batch();

    for (final category in categories) {
      batch.insert(
        DatabaseSchema.categoriesTable,
        category.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }
}
