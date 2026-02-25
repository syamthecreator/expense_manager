import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'database_schema.dart';

class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('expense_manager.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onConfigure: _onConfigure,
      onCreate: _onCreate,
    );
  }

  /// VERY IMPORTANT — enables foreign keys
  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(DatabaseSchema.createCategoriesTable);
    await db.execute(DatabaseSchema.createTransactionsTable);
    await db.execute(DatabaseSchema.transactionCategoryIndex);
    await db.execute(DatabaseSchema.transactionDeletedIndex);
  }
}