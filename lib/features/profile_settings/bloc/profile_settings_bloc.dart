import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../categories/data/category_repository.dart';
import 'profile_settings_event.dart';
import 'profile_settings_state.dart';
import '../models/profile_settings_model.dart';

class ProfileSettingsBloc
    extends Bloc<ProfileSettingsEvent, ProfileSettingsState> {
  final CategoryRepository categoryRepository;

  ProfileSettingsBloc(this.categoryRepository)
    : super(
        const ProfileSettingsState(
          ProfileSettingsModel(nickname: '', alertLimit: 1000, categories: []),
        ),
      ) {
    on<LoadCategories>(_onLoadCategories);
    on<AddCategory>(_onAddCategory);
    on<RemoveCategory>(_onRemoveCategory);
    on<UpdateAlertLimit>(_onUpdateAlertLimit);

    _init();
  }

  /// Initialize data
  Future<void> _init() async {
    await categoryRepository.seedDefaultCategories();
    add(LoadCategories());
    await _loadInitialData();
  }

  /// Load nickname + alert limit
  Future<void> _loadInitialData() async {
    final prefs = await SharedPreferences.getInstance();

    final nickname = prefs.getString('nickname') ?? '';
    final alertLimit = prefs.getDouble('alertLimit') ?? 1000;

    // ignore: invalid_use_of_visible_for_testing_member
    emit(
      ProfileSettingsState(
        state.data.copyWith(nickname: nickname, alertLimit: alertLimit),
      ),
    );
  }

  /// Load categories
  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<ProfileSettingsState> emit,
  ) async {
    final categories = await categoryRepository.getCategories();

    emit(
      ProfileSettingsState(
        state.data.copyWith(categories: categories.map((e) => e.name).toList()),
      ),
    );
  }

  /// Add category
  Future<void> _onAddCategory(
    AddCategory event,
    Emitter<ProfileSettingsState> emit,
  ) async {
    await categoryRepository.addCategory(event.name);

    final updated = await categoryRepository.getCategories();

    emit(
      ProfileSettingsState(
        state.data.copyWith(categories: updated.map((e) => e.name).toList()),
      ),
    );
  }

  /// Remove category
  Future<void> _onRemoveCategory(
    RemoveCategory event,
    Emitter<ProfileSettingsState> emit,
  ) async {
    final all = await categoryRepository.getCategories();

    final category = all.firstWhere((c) => c.name == event.name);

    await categoryRepository.deleteCategory(category.id);

    final updated = await categoryRepository.getCategories();

    emit(
      ProfileSettingsState(
        state.data.copyWith(categories: updated.map((e) => e.name).toList()),
      ),
    );
  }

  /// Update alert limit
  Future<void> _onUpdateAlertLimit(
    UpdateAlertLimit event,
    Emitter<ProfileSettingsState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('alertLimit', event.limit);

    emit(ProfileSettingsState(state.data.copyWith(alertLimit: event.limit)));
  }
}
