import 'package:expense_manager/features/transactions/model/transaction_model.dart';

class TransactionState {
  final List<TransactionWithCategory>
  transactions; // List of transactions with their associated category data
  final bool
  isLoading; // Flag to show/hide loading indicator during async operations

  const TransactionState({
    this.transactions = const [], // Default empty list
    this.isLoading = false, // Default not loading
  });

  /// Creates a new state by copying current values and replacing specified fields
  TransactionState copyWith({
    List<TransactionWithCategory>?
    transactions, // Optional new transactions list
    bool? isLoading, // Optional new loading status
  }) {
    return TransactionState(
      transactions:
          transactions ?? this.transactions, // Keep existing if not provided
      isLoading: isLoading ?? this.isLoading, // Keep existing if not provided
    );
  }
}
