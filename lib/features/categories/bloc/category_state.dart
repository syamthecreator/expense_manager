import '../model/category_model.dart';

class CategoryState {
  final List<CategoryModel> categories;
  final bool isLoading;

  const CategoryState({
    this.categories = const [],
    this.isLoading = false,
  });

  CategoryState copyWith({
    List<CategoryModel>? categories,
    bool? isLoading,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}