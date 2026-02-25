import 'package:expense_manager/core/services/database/app_database.dart';
import 'package:expense_manager/core/services/database/database_schema.dart';
import 'package:uuid/uuid.dart';
import 'package:sqflite/sqflite.dart';
import '../model/transaction_model.dart';

class TransactionWithCategory {
  final TransactionModel transaction;
  final String categoryName;

  TransactionWithCategory({
    required this.transaction,
    required this.categoryName,
  });
}

class TransactionRepository {
  final _uuid = const Uuid();

  /// Fetch recent transactions WITH category name (SQL JOIN)
  Future<List<TransactionWithCategory>> getRecentTransactions({
    int limit = 10,
  }) async {
    final db = await AppDatabase.instance.database;

    final result = await db.rawQuery('''
      SELECT 
        t.*,
        c.${DatabaseSchema.categoryName} AS category_name
      FROM ${DatabaseSchema.transactionsTable} t
      JOIN ${DatabaseSchema.categoriesTable} c
        ON t.${DatabaseSchema.categoryId} = c.${DatabaseSchema.id}
      WHERE t.${DatabaseSchema.isDeleted} = 0
      ORDER BY t.${DatabaseSchema.timestamp} DESC
      LIMIT ?
    ''', [limit]);

    return result.map((row) {
      final transaction = TransactionModel.fromMap(row);
      return TransactionWithCategory(
        transaction: transaction,
        categoryName: row['category_name'] as String,
      );
    }).toList();
  }

  /// Fetch ALL active transactions (used in transactions screen)
  Future<List<TransactionWithCategory>> getAllTransactions() async {
    final db = await AppDatabase.instance.database;

    final result = await db.rawQuery('''
      SELECT 
        t.*,
        c.${DatabaseSchema.categoryName} AS category_name
      FROM ${DatabaseSchema.transactionsTable} t
      JOIN ${DatabaseSchema.categoriesTable} c
        ON t.${DatabaseSchema.categoryId} = c.${DatabaseSchema.id}
      WHERE t.${DatabaseSchema.isDeleted} = 0
      ORDER BY t.${DatabaseSchema.timestamp} DESC
    ''');

    return result.map((row) {
      final transaction = TransactionModel.fromMap(row);
      return TransactionWithCategory(
        transaction: transaction,
        categoryName: row['category_name'] as String,
      );
    }).toList();
  }

  /// Insert transaction (offline-first)
  Future<TransactionModel> addTransaction({
    required double amount,
    required String type,
    required String categoryId,
    String? note,
  }) async {
    final db = await AppDatabase.instance.database;

    final transaction = TransactionModel(
      id: _uuid.v4(),
      amount: amount,
      type: type,
      categoryId: categoryId,
      note: note,
      timestamp: DateTime.now(),
    );

    await db.insert(
      DatabaseSchema.transactionsTable,
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return transaction;
  }

  /// Soft delete transaction
  Future<void> deleteTransaction(String transactionId) async {
    final db = await AppDatabase.instance.database;

    await db.update(
      DatabaseSchema.transactionsTable,
      {DatabaseSchema.isDeleted: 1, DatabaseSchema.isSynced: 0},
      where: '${DatabaseSchema.id} = ?',
      whereArgs: [transactionId],
    );
  }
}