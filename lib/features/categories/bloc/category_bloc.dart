import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/category_repository.dart';
import 'category_event.dart';
import 'category_state.dart';

/// BLoC responsible for managing category state
class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository repository;

  CategoryBloc(this.repository) : super(const CategoryState()) {
    on<LoadCategoryList>(_onLoadCategories);
    on<AddCategory>(_onAddCategory);
    on<DeleteCategory>(_onDeleteCategory);
  }

  /// Loads all categories
  Future<void> _onLoadCategories(
    LoadCategoryList event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final categories = await repository.getCategories();
    emit(state.copyWith(categories: categories, isLoading: false));
  }

  /// Adds a new category
  Future<void> _onAddCategory(
    AddCategory event,
    Emitter<CategoryState> emit,
  ) async {
    await repository.addCategory(event.name);
    final categories = await repository.getCategories();
    emit(state.copyWith(categories: categories));
  }

  /// Deletes an existing category
  Future<void> _onDeleteCategory(
    DeleteCategory event,
    Emitter<CategoryState> emit,
  ) async {
    await repository.deleteCategory(event.categoryId);
    final categories = await repository.getCategories();
    emit(state.copyWith(categories: categories));
  }
}
