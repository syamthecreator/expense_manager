import 'package:expense_manager/core/constants/app_colors.dart';
import 'package:expense_manager/core/utils/category_icon_mapper.dart';
import 'package:expense_manager/features/home/model/transaction_item_model.dart';
import 'package:expense_manager/features/transactions/bloc/transaction_bloc.dart';
import 'package:expense_manager/features/transactions/bloc/transaction_event.dart';
import 'package:expense_manager/features/transactions/bloc/transaction_state.dart';
import 'package:expense_manager/features/transactions/presentation/widgets/transaction_list_item.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Transactions',
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),

              Expanded(
                child: BlocBuilder<TransactionBloc, TransactionState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.transactions.isEmpty) {
                      return const Center(
                        child: Text(
                          'No transactions found',
                          style: TextStyle(color: Colors.white54),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: state.transactions.length,
                      itemBuilder: (context, index) {
                        final item = state.transactions[index];

                        return TransactionListItem(
                          model: TransactionItemModel(
                            icon: CategoryIconMapper.getIcon(item.categoryName),
                            title: item.transaction.note ?? 'Transaction',
                            category: item.categoryName,
                            date: item.transaction.timestamp,
                            amount: item.transaction.amount,
                            type: item.transaction.type == 'debit'
                                ? TransactionType.expense
                                : TransactionType.income,
                          ),
                          onDelete: () {
                            context.read<TransactionBloc>().add(
                              DeleteTransaction(item.transaction.id),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
