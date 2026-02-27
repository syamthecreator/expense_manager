import 'package:expense_manager/core/constants/app_colors.dart';
import 'package:expense_manager/core/utils/category_icon_mapper.dart';
import 'package:expense_manager/core/utils/helper.dart';
import 'package:expense_manager/core/widgets/custom_floating_action_button.dart';
import 'package:expense_manager/features/auth/bloc/auth_bloc.dart';
import 'package:expense_manager/features/auth/bloc/auth_state.dart';
import 'package:expense_manager/features/categories/bloc/category_bloc.dart';
import 'package:expense_manager/features/categories/bloc/category_event.dart';
import 'package:expense_manager/features/categories/data/category_repository.dart';
import 'package:expense_manager/features/home/model/monthly_limit_model.dart';
import 'package:expense_manager/features/home/model/transaction_item_model.dart';
import 'package:expense_manager/features/profile_settings/bloc/profile_settings_bloc.dart';
import 'package:expense_manager/features/profile_settings/bloc/profile_settings_state.dart';
import 'package:expense_manager/features/transactions/bloc/add_transaction_cubit.dart';
import 'package:expense_manager/features/transactions/bloc/transaction_bloc.dart';
import 'package:expense_manager/features/transactions/bloc/transaction_event.dart';
import 'package:expense_manager/features/transactions/bloc/transaction_state.dart';
import 'package:expense_manager/features/transactions/presentation/widgets/add_transaction_sheet.dart';
import 'package:expense_manager/features/home/presentation/widgets/monthly_limit_card.dart';
import 'package:expense_manager/features/home/presentation/widgets/summary_card.dart';
import 'package:expense_manager/features/transactions/presentation/widgets/transaction_list_item.dart';
import 'package:expense_manager/navigation/bloc/nav_bloc.dart';
import 'package:expense_manager/navigation/bloc/nav_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _WelcomeHeader(),
              SizedBox(height: 24),
              _SummaryCardsRow(),
              SizedBox(height: 24),
              _MonthlyLimitSection(),
              SizedBox(height: 25),
              _Divider(),
              SizedBox(height: 25),
              _RecentTransactionsHeader(),
              SizedBox(height: 16),
              _TransactionList(),
            ],
          ),
        ),
      ),
      floatingActionButton: const _FloatingActionButtonSection(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}

// Extracted Widgets for better performance and maintainability

class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (p, c) => p.nickname != c.nickname,
      builder: (context, state) {
        final name = state.nickname;

        return Text(
          name != null && name.isNotEmpty ? '👋 Welcome, $name' : '👋 Welcome',
          style: const TextStyle(
            color: AppColors.whiteColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        );
      },
    );
  }
}

class _SummaryCardsRow extends StatelessWidget {
  const _SummaryCardsRow();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        final (income, expense) = _calculateTotals(state.transactions);

        return Row(
          children: [
            Expanded(
              child: SummaryCard(
                title: 'Total Income',
                amount: '₹${income.toStringAsFixed(0)}',
                isIncome: true,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SummaryCard(
                title: 'Total Expense',
                amount: '₹${expense.toStringAsFixed(0)}',
                isIncome: false,
              ),
            ),
          ],
        );
      },
    );
  }

  (double income, double expense) _calculateTotals(List transactions) {
    double totalIncome = 0;
    double totalExpense = 0;

    for (final item in transactions) {
      if (item.transaction.type == 'credit') {
        totalIncome += item.transaction.amount;
      } else if (item.transaction.type == 'debit') {
        totalExpense += item.transaction.amount;
      }
    }

    return (totalIncome, totalExpense);
  }
}

class _MonthlyLimitSection extends StatelessWidget {
  const _MonthlyLimitSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, transactionState) {
        return BlocBuilder<ProfileSettingsBloc, ProfileSettingsState>(
          builder: (context, profileState) {
            final spent = Helper().calculateMonthlyExpense(
              transactionState.transactions,
            );
            final limit = profileState.data.alertLimit;

            return MonthlyLimitCard(
              model: MonthlyLimitModel(spentAmount: spent, totalLimit: limit),
            );
          },
        );
      },
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Divider(thickness: 1, height: 3, color: AppColors.greyShade);
  }
}

class _RecentTransactionsHeader extends StatelessWidget {
  const _RecentTransactionsHeader();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Recent Transactions',
      style: TextStyle(
        color: AppColors.whiteColor,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _TransactionList extends StatelessWidget {
  const _TransactionList();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.transactions.isEmpty) {
            return const Center(
              child: Text(
                'No recent transactions',
                style: TextStyle(color: Colors.white54),
              ),
            );
          }

          return ListView.separated(
            itemCount: state.transactions.length,
            separatorBuilder: (_, _) => const SizedBox(),
            itemBuilder: (context, index) {
              final item = state.transactions[index];

              return _TransactionItem(
                item: item,
                onDelete: () =>
                    _deleteTransaction(context, item.transaction.id),
              );
            },
          );
        },
      ),
    );
  }

  void _deleteTransaction(BuildContext context, String id) {
    context.read<TransactionBloc>().add(DeleteTransaction(id));
  }
}

class _TransactionItem extends StatelessWidget {
  final dynamic item;
  final VoidCallback onDelete;

  const _TransactionItem({required this.item, required this.onDelete});

  @override
  Widget build(BuildContext context) {
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
      onDelete: onDelete,
    );
  }
}

class _FloatingActionButtonSection extends StatelessWidget {
  const _FloatingActionButtonSection();

  void _openAddTransaction(BuildContext context) {
    context.read<NavBloc>().add(HideBottomNav());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AddTransactionSheetWithProviders(),
    ).whenComplete(() {
      if (!context.mounted) return;
      context.read<NavBloc>().add(ShowBottomNav());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24, right: 16),
      child: CustomFloatingActionButton(
        onPressed: () => _openAddTransaction(context),
      ),
    );
  }
}

class _AddTransactionSheetWithProviders extends StatelessWidget {
  const _AddTransactionSheetWithProviders();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              CategoryBloc(CategoryRepository())..add(LoadCategoryList()),
        ),
        BlocProvider(create: (_) => AddTransactionCubit()),
      ],
      child: const AddTransactionSheet(),
    );
  }
}
