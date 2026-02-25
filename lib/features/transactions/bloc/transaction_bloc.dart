import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/transaction_repository.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

class TransactionBloc
    extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository repository;

  TransactionBloc(this.repository)
      : super(const TransactionState()) {
    on<LoadRecentTransactions>(_onLoadRecent);
    on<LoadAllTransactions>(_onLoadAll);
    on<AddTransaction>(_onAddTransaction);
    on<DeleteTransaction>(_onDeleteTransaction);
  }

  Future<void> _onLoadRecent(
    LoadRecentTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final transactions =
        await repository.getRecentTransactions();

    emit(
      state.copyWith(
        transactions: transactions,
        isLoading: false,
      ),
    );
  }

  Future<void> _onLoadAll(
    LoadAllTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final transactions =
        await repository.getAllTransactions();

    emit(
      state.copyWith(
        transactions: transactions,
        isLoading: false,
      ),
    );
  }

  Future<void> _onAddTransaction(
    AddTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    await repository.addTransaction(
      amount: event.amount,
      type: event.type,
      categoryId: event.categoryId,
      note: event.note,
    );

    final updated =
        await repository.getRecentTransactions();

    emit(state.copyWith(transactions: updated));
  }

  Future<void> _onDeleteTransaction(
    DeleteTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    await repository.deleteTransaction(event.transactionId);

    emit(
      state.copyWith(
        transactions: state.transactions
            .where((t) =>
                t.transaction.id != event.transactionId)
            .toList(),
      ),
    );
  }
}