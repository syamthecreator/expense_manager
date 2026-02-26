import 'dart:developer';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'database_schema.dart';

/// Application database singleton
class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();

  static Database? _database;

  /// Returns the database instance
  Future<Database> get database async {
    if (_database != null) return _database!;

    log('Initializing database...', name: 'AppDatabase');
    _database = await _initDB('expense_manager.db');
    log('Database initialized successfully', name: 'AppDatabase');
    return _database!;
  }

  /// Initializes the database
  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    log('Database path: $path', name: 'AppDatabase');

    return openDatabase(
      path,
      version: 1,
      onConfigure: _onConfigure,
      onCreate: _onCreate,
    );
  }

  /// Configures database settings
  Future<void> _onConfigure(Database db) async {
    log('Enabling foreign keys...', name: 'AppDatabase');
    await db.execute('PRAGMA foreign_keys = ON');
    log('Foreign keys enabled', name: 'AppDatabase');
  }

  /// Creates database tables and indexes
  Future<void> _onCreate(Database db, int version) async {
    log('Creating database tables...', name: 'AppDatabase');

    await db.execute(DatabaseSchema.createCategoriesTable);
    log('Categories table created', name: 'AppDatabase');

    await db.execute(DatabaseSchema.createTransactionsTable);
    log('Transactions table created', name: 'AppDatabase');

    await db.execute(DatabaseSchema.transactionCategoryIndex);
    log('Category index created', name: 'AppDatabase');

    await db.execute(DatabaseSchema.transactionDeletedIndex);
    log('Deleted index created', name: 'AppDatabase');

    log(
      'All database tables and indexes created successfully',
      name: 'AppDatabase',
    );
  }

  /// Clears all database tables
  Future<void> clearDatabase() async {}
}
