import 'package:expense_manager/features/categories/bloc/category_event.dart';
import 'package:expense_manager/features/profile_settings/bloc/profile_settings_bloc.dart';
import 'package:expense_manager/features/profile_settings/bloc/profile_settings_event.dart';
import 'package:expense_manager/features/sync/bloc/sync_bloc.dart';
import 'package:expense_manager/features/sync/data/sync_repository.dart';
import 'package:expense_manager/features/sync/service/sync_remote_service.dart';
import 'package:expense_manager/features/transactions/bloc/transaction_bloc.dart';
import 'package:expense_manager/features/transactions/bloc/transaction_event.dart';
import 'package:expense_manager/features/transactions/data/transaction_repository.dart';
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
    BlocProvider<ProfileSettingsBloc>(
      lazy: false,
      create: (_) =>
          ProfileSettingsBloc(CategoryRepository())..add(LoadCategories()),
    ),
    BlocProvider<TransactionBloc>(
      lazy: false,
      create: (_) =>
          TransactionBloc(TransactionRepository())
            ..add(LoadRecentTransactions()),
    ),
    BlocProvider<SyncBloc>(
      lazy: false,
      create: (_) => SyncBloc(SyncRepository(SyncRemoteService())),
    ),
  ];
}
