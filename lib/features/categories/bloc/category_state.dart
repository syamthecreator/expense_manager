import '../model/category_model.dart';

/// State for category management
class CategoryState {
  final List<CategoryModel> categories;
  final bool isLoading;

  const CategoryState({this.categories = const [], this.isLoading = false});

  /// Returns a new state with updated values
  CategoryState copyWith({List<CategoryModel>? categories, bool? isLoading}) {
    return CategoryState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
