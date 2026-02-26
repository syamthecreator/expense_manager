import 'package:equatable/equatable.dart';

/// Base class for all profile settings events
abstract class ProfileSettingsEvent extends Equatable {
  const ProfileSettingsEvent();

  @override
  List<Object?> get props => [];
}

/// Load initial profile settings (nickname, alert limit)
class LoadInitialProfileSettings extends ProfileSettingsEvent {}

/// Load all categories from database
class LoadCategories extends ProfileSettingsEvent {}

/// Add a new category
class AddCategory extends ProfileSettingsEvent {
  final String name;

  const AddCategory(this.name);

  @override
  List<Object?> get props => [name];
}

/// Remove an existing category
class RemoveCategory extends ProfileSettingsEvent {
  final String name;

  const RemoveCategory(this.name);

  @override
  List<Object?> get props => [name];
}

/// Update monthly spending alert limit
class UpdateAlertLimit extends ProfileSettingsEvent {
  final double limit;

  const UpdateAlertLimit(this.limit);

  @override
  List<Object?> get props => [limit];
}
