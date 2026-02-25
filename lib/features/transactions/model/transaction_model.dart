import 'package:expense_manager/core/services/database/database_schema.dart';

class TransactionModel {
  final String id;
  final double amount;
  final String? note;
  final String type;
  final String categoryId;
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

  /// Convert model → Map (for SQLite)
  Map<String, dynamic> toMap() {
    return {
      DatabaseSchema.id: id,
      DatabaseSchema.amount: amount,
      DatabaseSchema.note: note,
      DatabaseSchema.type: type,
      DatabaseSchema.categoryId: categoryId,
      DatabaseSchema.timestamp: timestamp.toIso8601String(),
      DatabaseSchema.isSynced: isSynced ? 1 : 0,
      DatabaseSchema.isDeleted: isDeleted ? 1 : 0,
    };
  }

  /// Convert Map → model (from SQLite)
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map[DatabaseSchema.id] as String,
      amount: (map[DatabaseSchema.amount] as num).toDouble(),
      note: map[DatabaseSchema.note] as String?,
      type: map[DatabaseSchema.type] as String,
      categoryId: map[DatabaseSchema.categoryId] as String,
      timestamp: DateTime.parse(map[DatabaseSchema.timestamp] as String),
      isSynced: (map[DatabaseSchema.isSynced] as int) == 1,
      isDeleted: (map[DatabaseSchema.isDeleted] as int) == 1,
    );
  }

  /// Bloc-friendly immutability
  TransactionModel copyWith({
    String? id,
    double? amount,
    String? note,
    String? type,
    String? categoryId,
    DateTime? timestamp,
    bool? isSynced,
    bool? isDeleted,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      timestamp: timestamp ?? this.timestamp,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
