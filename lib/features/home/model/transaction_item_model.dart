import 'package:expense_manager/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum TransactionType { income, expense }

class TransactionItemModel {
  final String icon;
  final String title;
  final String category;
  final DateTime date;
  final double amount;
  final TransactionType type;

  TransactionItemModel({
    required this.icon,
    required this.title,
    required this.category,
    required this.date,
    required this.amount,
    required this.type,
  });

  bool get isIncome => type == TransactionType.income;

  String get formattedAmount {
    final formatter = NumberFormat('#,##,###');
    final sign = isIncome ? '+' : '-';
    return '$sign₹${formatter.format(amount)}';
  }

  Color get amountColor =>
      isIncome ? const Color(0xFF2DFF5D) : AppColors.redColour;
}
