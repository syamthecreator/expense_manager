import 'package:expense_manager/core/services/database/app_database.dart';
import 'package:expense_manager/core/services/database/database_schema.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../model/category_model.dart';

class CategoryRepository {
  final _uuid = const Uuid();

  /// Fetch all active (not deleted) categories
  Future<List<CategoryModel>> getCategories() async {
    final db = await AppDatabase.instance.database;

    final result = await db.query(
      DatabaseSchema.categoriesTable,
      where: '${DatabaseSchema.isDeleted} = ?',
      whereArgs: [0],
      orderBy: DatabaseSchema.categoryName,
    );

    return result.map(CategoryModel.fromMap).toList();
  }

  /// Insert new category (offline-first)
  Future<CategoryModel> addCategory(String name) async {
    final db = await AppDatabase.instance.database;

    final category = CategoryModel(id: _uuid.v4(), name: name);

    await db.insert(
      DatabaseSchema.categoriesTable,
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return category;
  }

  /// Soft delete category
  Future<void> deleteCategory(String categoryId) async {
    final db = await AppDatabase.instance.database;

    await db.update(
      DatabaseSchema.categoriesTable,
      {DatabaseSchema.isDeleted: 1, DatabaseSchema.isSynced: 0},
      where: '${DatabaseSchema.id} = ?',
      whereArgs: [categoryId],
    );
  }
}
