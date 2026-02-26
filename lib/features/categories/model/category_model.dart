import 'package:expense_manager/core/services/database/database_schema.dart';

class CategoryModel {
  final String id; // UUID
  final String name;
  final bool isSynced;
  final bool isDeleted;

  const CategoryModel({
    required this.id,
    required this.name,
    this.isSynced = false,
    this.isDeleted = false,
  });

  // Convert model → Map (for SQLite)
  Map<String, dynamic> toMap() {
    return {
      DatabaseSchema.id: id,
      DatabaseSchema.categoryName: name,
      DatabaseSchema.isSynced: isSynced ? 1 : 0,
      DatabaseSchema.isDeleted: isDeleted ? 1 : 0,
    };
  }

  // Convert Map → model (from SQLite)
  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map[DatabaseSchema.id] as String,
      name: map[DatabaseSchema.categoryName] as String,
      isSynced: (map[DatabaseSchema.isSynced] as int) == 1,
      isDeleted: (map[DatabaseSchema.isDeleted] as int) == 1,
    );
  }
}
