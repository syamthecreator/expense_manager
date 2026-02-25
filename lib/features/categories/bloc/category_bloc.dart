import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/category_repository.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository repository;

  CategoryBloc(this.repository) : super(const CategoryState()) {
    on<LoadCategories>(_onLoadCategories);
    on<AddCategory>(_onAddCategory);
    on<DeleteCategory>(_onDeleteCategory);
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final categories = await repository.getCategories();

    emit(
      state.copyWith(
        categories: categories,
        isLoading: false,
      ),
    );
  }

  Future<void> _onAddCategory(
    AddCategory event,
    Emitter<CategoryState> emit,
  ) async {
    final category = await repository.addCategory(event.name);

    emit(
      state.copyWith(
        categories: [...state.categories, category],
      ),
    );
  }

  Future<void> _onDeleteCategory(
    DeleteCategory event,
    Emitter<CategoryState> emit,
  ) async {
    await repository.deleteCategory(event.categoryId);

    emit(
      state.copyWith(
        categories: state.categories
            .where((c) => c.id != event.categoryId)
            .toList(),
      ),
    );
  }
}