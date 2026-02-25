import '../data/transaction_repository.dart';

class TransactionState {
  final List<TransactionWithCategory> transactions;
  final bool isLoading;

  const TransactionState({
    this.transactions = const [],
    this.isLoading = false,
  });

  TransactionState copyWith({
    List<TransactionWithCategory>? transactions,
    bool? isLoading,
  }) {
    return TransactionState(
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}