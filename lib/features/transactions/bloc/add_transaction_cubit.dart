import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_manager/features/categories/model/category_model.dart';

/// State for add transaction form
class AddTransactionState {
  final String type;
  final CategoryModel? category;
  final bool isValid;

  const AddTransactionState({
    this.type = 'debit',
    this.category,
    this.isValid = false,
  });

  /// Returns a new state with updated values
  AddTransactionState copyWith({
    String? type,
    CategoryModel? category,
    bool? isValid,
  }) {
    return AddTransactionState(
      type: type ?? this.type,
      category: category ?? this.category,
      isValid: isValid ?? this.isValid,
    );
  }
}

/// Cubit responsible for add transaction form logic
class AddTransactionCubit extends Cubit<AddTransactionState> {
  AddTransactionCubit() : super(const AddTransactionState());

  /// Updates transaction type
  void changeType(String type) {
    log('Transaction type changed to: $type');
    emit(state.copyWith(type: type));
  }

  /// Updates selected category
  void selectCategory(CategoryModel category) {
    log('Category selected: ${category.name} (ID: ${category.id})');
    emit(state.copyWith(category: category));
  }

  /// Validates form input and updates state
  void validate({required String amount, required String title}) {
    final amountIsNumeric = double.tryParse(amount) != null;
    final amountIsPositive = amountIsNumeric ? double.parse(amount) > 0 : false;
    final categorySelected = state.category != null;

    final valid =
        amount.isNotEmpty &&
        amountIsNumeric &&
        amountIsPositive &&
        title.isNotEmpty &&
        categorySelected;

    log(
      'Validation result: $valid '
      '(Amount valid: ${amount.isNotEmpty && amountIsNumeric && amountIsPositive}, '
      'Title valid: ${title.isNotEmpty}, '
      'Category selected: $categorySelected)',
    );

    emit(state.copyWith(isValid: valid));
  }
}
