import 'package:expense_manager/core/services/database/database_schema.dart';

class TransactionModel {
  final String id;
  final double amount;
  final String type;
  final String categoryId;
  final String? note;
  final DateTime timestamp;
  final bool isSynced;
  final bool isDeleted;

  const TransactionModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.timestamp,
    this.note,
    this.isSynced = false,
    this.isDeleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      DatabaseSchema.id: id,
      DatabaseSchema.amount: amount,
      DatabaseSchema.type: type,
      DatabaseSchema.categoryId: categoryId,
      DatabaseSchema.note: note,
      DatabaseSchema.timestamp: timestamp.toIso8601String(),
      DatabaseSchema.isSynced: isSynced ? 1 : 0,
      DatabaseSchema.isDeleted: isDeleted ? 1 : 0,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map[DatabaseSchema.id],
      amount: (map[DatabaseSchema.amount] as num).toDouble(),
      type: map[DatabaseSchema.type],
      categoryId: map[DatabaseSchema.categoryId],
      note: map[DatabaseSchema.note],
      timestamp: DateTime.parse(map[DatabaseSchema.timestamp]),
      isSynced: map[DatabaseSchema.isSynced] == 1,
      isDeleted: map[DatabaseSchema.isDeleted] == 1,
    );
  }
}

class TransactionWithCategory {
  final TransactionModel transaction;
  final String categoryName;

  TransactionWithCategory({
    required this.transaction,
    required this.categoryName,
  });
}