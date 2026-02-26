import 'package:expense_manager/core/constants/app_colors.dart';
import 'package:expense_manager/core/widgets/primary_button.dart';
import 'package:expense_manager/features/categories/bloc/category_bloc.dart';
import 'package:expense_manager/features/categories/bloc/category_state.dart';
import 'package:expense_manager/features/transactions/bloc/add_transaction_cubit.dart';
import 'package:expense_manager/features/transactions/bloc/transaction_bloc.dart';
import 'package:expense_manager/features/transactions/bloc/transaction_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTransactionSheet extends StatefulWidget {
  const AddTransactionSheet({super.key});

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 16,
        right: 16,
        top: 20,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF1C1C1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(context),
          const SizedBox(height: 24),
          _typeToggle(),
          const SizedBox(height: 20),
          _textField(
            hint: 'Title',
            controller: _titleCtrl,
            onChanged: (_) => _validate(context),
          ),
          const SizedBox(height: 14),
          _textField(
            hint: 'Amount ( ₹ )',
            controller: _amountCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$')),
            ],
            onChanged: (_) => _validate(context),
          ),
          const SizedBox(height: 24),
          _categorySection(),
          const SizedBox(height: 20),
          _privacyNote(),
          const SizedBox(height: 24),
          _saveButton(context),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  void _validate(BuildContext context) {
    context.read<AddTransactionCubit>().validate(
      title: _titleCtrl.text,
      amount: _amountCtrl.text,
    );
  }

  // HEADER
  Widget _header(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Add Transaction',
          style: TextStyle(
            color: AppColors.whiteColor,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Text(
            'Close',
            style: TextStyle(
              color: AppColors.whiteColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // EXPENSE / INCOME TOGGLE
  Widget _typeToggle() {
    return BlocBuilder<AddTransactionCubit, AddTransactionState>(
      builder: (context, state) {
        return Container(
          height: 64,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white24, width: 2),
          ),
          child: Row(
            children: [
              Expanded(
                child: _toggleItem(
                  label: 'Expense',
                  selected: state.type == 'debit',
                  onTap: () =>
                      context.read<AddTransactionCubit>().changeType('debit'),
                ),
              ),
              Expanded(
                child: _toggleItem(
                  label: 'Income',
                  selected: state.type == 'credit',
                  onTap: () =>
                      context.read<AddTransactionCubit>().changeType('credit'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _toggleItem({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: selected ? AppColors.greenColour : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected ? AppColors.whiteColor : Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // TEXT FIELD
  Widget _textField({
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    ValueChanged<String>? onChanged,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: const Color(0xFF2A2A2C),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  // CATEGORY SECTION
  Widget _categorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CATEGORY',
          style: TextStyle(
            color: Colors.white38,
            fontSize: 12,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 14),
        BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, catState) {
            if (catState.isLoading) {
              return const Text(
                'Loading categories...',
                style: TextStyle(color: Colors.white54),
              );
            }

            if (catState.categories.isEmpty) {
              return _buildEmptyCategories(context);
            }

            return BlocBuilder<AddTransactionCubit, AddTransactionState>(
              builder: (context, txState) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: catState.categories.map((category) {
                      final selected = txState.category?.id == category.id;

                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () {
                            context.read<AddTransactionCubit>().selectCategory(
                              category,
                            );
                            _validate(context);
                          },
                          child: _categoryChip(
                            category.name,
                            selected: selected,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildEmptyCategories(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.category_outlined,
            size: 40,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 12),
          const Text(
            'No categories found',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Category is required to add a transaction.\nCreate a category in Profile to continue.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _categoryChip(String label, {bool selected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: selected
            ? const Color.fromRGBO(49, 46, 203, 0.5)
            : const Color(0xFF2A2A2C),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: selected
              ? const Color.fromRGBO(0, 122, 255, 1)
              : Colors.white24,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }

  // PRIVACY NOTE
  Widget _privacyNote() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(0, 133, 0, 0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, color: AppColors.whiteColor, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Everything you add here is saved only on your device.',
              style: TextStyle(color: AppColors.whiteColor, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  // SAVE BUTTON
  Widget _saveButton(BuildContext context) {
    return BlocBuilder<AddTransactionCubit, AddTransactionState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          child: PrimaryButton(
            isExpanded: false,
            title: 'Save',
            isEnabled: state.isValid,
            onPressed: state.isValid ? () => _onSave(context, state) : null,
          ),
        );
      },
    );
  }

  void _onSave(BuildContext context, AddTransactionState state) {
    final amount = double.parse(_amountCtrl.text);

    context.read<TransactionBloc>().add(
      AddTransaction(
        amount: amount,
        type: state.type,
        categoryId: state.category!.id,
        note: _titleCtrl.text,
      ),
    );

    Navigator.pop(context);
  }
}
