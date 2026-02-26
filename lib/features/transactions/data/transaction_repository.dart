import 'package:expense_manager/core/services/database/app_database.dart';
import 'package:expense_manager/core/services/database/database_schema.dart';
import 'package:uuid/uuid.dart';
import 'package:sqflite/sqflite.dart';
import '../model/transaction_model.dart';

class TransactionRepository {
  final _uuid =
      const Uuid(); // UUID generator for creating unique transaction IDs

  /// Fetch recent transactions with category names (limited number for home screen)
  Future<List<TransactionWithCategory>> getRecentTransactions({
    int limit = 10, // Default to 10 most recent transactions
  }) async {
    final db = await AppDatabase.instance.database; // Get database instance

    // Join transactions with categories to get category name for each transaction
    final result = await db.rawQuery(
      '''
      SELECT t.*, c.${DatabaseSchema.categoryName} AS category_name
      FROM ${DatabaseSchema.transactionsTable} t
      JOIN ${DatabaseSchema.categoriesTable} c
      ON t.${DatabaseSchema.categoryId} = c.${DatabaseSchema.id}
      WHERE t.${DatabaseSchema.isDeleted} = 0
      ORDER BY t.${DatabaseSchema.timestamp} DESC
      LIMIT ?
    ''',
      [limit],
    );

    // Convert raw data to model objects with category names
    return result.map((row) {
      return TransactionWithCategory(
        transaction: TransactionModel.fromMap(row),
        categoryName: row['category_name'] as String,
      );
    }).toList();
  }

  /// Fetch all non-deleted transactions with category names
  Future<List<TransactionWithCategory>> getAllTransactions() async {
    final db = await AppDatabase.instance.database;

    // Join transactions with categories, exclude deleted items, order by newest first
    final result = await db.rawQuery('''
      SELECT t.*, c.${DatabaseSchema.categoryName} AS category_name
      FROM ${DatabaseSchema.transactionsTable} t
      JOIN ${DatabaseSchema.categoriesTable} c
      ON t.${DatabaseSchema.categoryId} = c.${DatabaseSchema.id}
      WHERE t.${DatabaseSchema.isDeleted} = 0
      ORDER BY t.${DatabaseSchema.timestamp} DESC
    ''');

    // Convert all rows to model objects
    return result.map((row) {
      return TransactionWithCategory(
        transaction: TransactionModel.fromMap(row),
        categoryName: row['category_name'] as String,
      );
    }).toList();
  }

  /// Add a new transaction to the database
  Future<void> addTransaction({
    required double amount,
    required String type,
    required String categoryId,
    String? note,
  }) async {
    final db = await AppDatabase.instance.database;

    // Create new transaction with unique ID and current timestamp
    final tx = TransactionModel(
      id: _uuid.v4(),
      amount: amount,
      type: type,
      categoryId: categoryId,
      note: note,
      timestamp: DateTime.now(),
    );

    await db.insert(
      DatabaseSchema.transactionsTable,
      tx.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Soft delete a transaction (mark as deleted instead of permanent removal)
  Future<void> deleteTransaction(String id) async {
    final db = await AppDatabase.instance.database;

    // Update isDeleted flag to 1 and mark as not synced with server
    await db.update(
      DatabaseSchema.transactionsTable,
      {
        DatabaseSchema.isDeleted: 1, // Soft delete flag
        DatabaseSchema.isSynced: 0, // Mark for future sync
      },
      where: '${DatabaseSchema.id} = ?',
      whereArgs: [id],
    );
  }

  /// Get total debit amount for the current month (non-deleted)
  Future<double> getCurrentMonthDebitTotal() async {
    final db = await AppDatabase.instance.database;

    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    final result = await db.rawQuery(
      '''
    SELECT IFNULL(SUM(${DatabaseSchema.amount}), 0) AS total
    FROM ${DatabaseSchema.transactionsTable}
    WHERE ${DatabaseSchema.type} = 'debit'
      AND ${DatabaseSchema.isDeleted} = 0
      AND ${DatabaseSchema.timestamp} BETWEEN ? AND ?
    ''',
      [startOfMonth.toIso8601String(), endOfMonth.toIso8601String()],
    );

    return (result.first['total'] as num).toDouble();
  }
}
