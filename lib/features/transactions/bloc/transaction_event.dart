abstract class TransactionEvent {}

class LoadRecentTransactions extends TransactionEvent {}

class LoadAllTransactions extends TransactionEvent {}

class AddTransaction extends TransactionEvent {
  final double amount;
  final String type;
  final String categoryId;
  final String? note;

  AddTransaction({
    required this.amount,
    required this.type,
    required this.categoryId,
    this.note,
  });
}

class DeleteTransaction extends TransactionEvent {
  final String transactionId;
  DeleteTransaction(this.transactionId);
}