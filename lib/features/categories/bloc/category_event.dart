/// Base class for all category events
abstract class CategoryEvent {}

/// Load all categories from the database
class LoadCategoryList extends CategoryEvent {}

/// Add a new category
class AddCategory extends CategoryEvent {
  final String name;

  AddCategory(this.name);
}

/// Delete an existing category
class DeleteCategory extends CategoryEvent {
  final String categoryId;

  DeleteCategory(this.categoryId);
}
