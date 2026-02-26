/// Base class for all transaction-related events
abstract class TransactionEvent {}

/// Event to load recent transactions (limited number for home screen display)
class LoadRecentTransactions extends TransactionEvent {}

/// Event to load all transactions (for full transaction history screen)
class LoadAllTransactions extends TransactionEvent {}

/// Event to add a new transaction with the provided details
class AddTransaction extends TransactionEvent {
  final double amount; // Transaction amount in rupees
  final String type; // Transaction type: 'debit' (expense) or 'credit' (income)
  final String categoryId; // ID of the selected category
  final String? note; // Optional note/description for the transaction

  AddTransaction({
    required this.amount,
    required this.type,
    required this.categoryId,
    this.note,
  });
}

/// Event to delete an existing transaction by its ID
class DeleteTransaction extends TransactionEvent {
  final String transactionId; // Unique ID of the transaction to delete
  DeleteTransaction(this.transactionId);
}