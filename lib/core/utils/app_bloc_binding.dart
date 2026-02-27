import 'package:expense_manager/features/categories/bloc/category_event.dart';

import 'package:expense_manager/navigation/bloc/nav_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:expense_manager/features/categories/bloc/category_bloc.dart';
import 'package:expense_manager/features/categories/data/category_repository.dart';

/// Centralized BLoC bindings for the application
class AppBlocBinding {
  static List<BlocProvider> get blocs => [
    BlocProvider<NavBloc>(lazy: false, create: (_) => NavBloc()),
    BlocProvider<CategoryBloc>(
      lazy: false,
      create: (_) =>
          CategoryBloc(CategoryRepository())..add(LoadCategoryList()),
    ),
  ];
}
