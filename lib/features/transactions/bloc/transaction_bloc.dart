import 'dart:developer';

import 'package:expense_manager/core/services/notification/notification_service.dart';
import 'package:expense_manager/features/sync/bloc/sync_bloc.dart';
import 'package:expense_manager/features/sync/bloc/sync_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/transaction_repository.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

/// BLoC responsible for transaction operations
class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository repository;
  final SyncBloc syncBloc;

  TransactionBloc(this.repository, this.syncBloc)
    : super(const TransactionState()) {
    on<LoadRecentTransactions>(_onLoadRecent);
    on<LoadAllTransactions>(_onLoadAll);
    on<AddTransaction>(_onAddTransaction);
    on<DeleteTransaction>(_onDeleteTransaction);
  }

  /// Loads recent transactions
  Future<void> _onLoadRecent(
    LoadRecentTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    log('Loading recent transactions', name: 'TransactionBloc');

    emit(state.copyWith(isLoading: true));

    final transactions = await repository.getRecentTransactions();

    log(
      'Recent transactions loaded: ${transactions.length}',
      name: 'TransactionBloc',
    );

    emit(state.copyWith(transactions: transactions, isLoading: false));
  }

  /// Loads all transactions
  Future<void> _onLoadAll(
    LoadAllTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    log('Loading all transactions', name: 'TransactionBloc');

    emit(state.copyWith(isLoading: true));

    final transactions = await repository.getAllTransactions();

    log(
      'All transactions loaded: ${transactions.length}',
      name: 'TransactionBloc',
    );

    emit(state.copyWith(transactions: transactions, isLoading: false));
  }

  /// Adds a new transaction
  Future<void> _onAddTransaction(
    AddTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    log(
      'Add transaction received',
      name: 'TransactionBloc',
      error: {
        'amount': event.amount,
        'type': event.type,
        'categoryId': event.categoryId,
        'note': event.note,
      },
    );

    // Read user-defined alert limit
    final prefs = await SharedPreferences.getInstance();
    final alertLimit = prefs.getDouble('alertLimit') ?? 1000;

    // Get current month debit total BEFORE insert
    final previousTotal = await repository.getCurrentMonthDebitTotal();

    // Insert transaction
    await repository.addTransaction(
      amount: event.amount,
      type: event.type,
      categoryId: event.categoryId,
      note: event.note,
    );

    log('Transaction saved to database', name: 'TransactionBloc');

    // Trigger notification ONLY when crossing limit
    syncBloc.add(const ResetSyncState());
    if (event.type == 'debit') {
      final newTotal = previousTotal + event.amount;

      if (previousTotal < alertLimit && newTotal >= alertLimit) {
        await NotificationService.showLimitExceeded(newTotal, alertLimit);
      }
    }

    // Reload transactions
    final transactions = await repository.getAllTransactions();

    emit(state.copyWith(transactions: transactions, isLoading: false));
  }

  /// Deletes a transaction
  Future<void> _onDeleteTransaction(
    DeleteTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    log('Delete transaction: ${event.transactionId}', name: 'TransactionBloc');

    await repository.deleteTransaction(event.transactionId);

     syncBloc.add(const ResetSyncState());

    emit(
      state.copyWith(
        transactions: state.transactions
            .where((t) => t.transaction.id != event.transactionId)
            .toList(),
      ),
    );

    log('Transaction deleted successfully', name: 'TransactionBloc');
  }
}
