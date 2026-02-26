import 'package:expense_manager/features/transactions/model/transaction_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Helper {
  // Validates Indian mobile number (starts with 6-9 and has 10 digits)
  bool isValidIndianMobile(String phone) {
    final regex = RegExp(r'^[6-9]\d{9}$');
    return regex.hasMatch(phone);
  }

  // Get nickname from SharedPreferences
  Future<String?> getNickname() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('nickname');
  }

  // Formats date as "27th Dec 2025"
  String formatDate(DateTime date) {
    return '${date.day}th Dec ${date.year}';
  }

  // Masks Indian phone number: 9876543210 -> 9876****10
  String maskIndianPhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 10) return phone;
    return '${digits.substring(0, 4)}****${digits.substring(8, 10)}';
  }

  // Calculates total expenses for current month from debit transactions
  double calculateMonthlyExpense(List<TransactionWithCategory> transactions) {
    final now = DateTime.now();

    return transactions
        .where(
          (t) =>
              t.transaction.type == 'debit' &&
              t.transaction.timestamp.month == now.month &&
              t.transaction.timestamp.year == now.year,
        )
        .fold(0.0, (sum, t) => sum + t.transaction.amount);
  }

  
}
