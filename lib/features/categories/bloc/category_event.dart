abstract class CategoryEvent {}

class LoadCategories extends CategoryEvent {}

class AddCategory extends CategoryEvent {
  final String name;
  AddCategory(this.name);
}

class DeleteCategory extends CategoryEvent {
  final String categoryId;
  DeleteCategory(this.categoryId);
}