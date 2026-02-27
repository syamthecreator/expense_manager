import 'package:expense_manager/app/app_routes.dart';
import 'package:expense_manager/app/repository.dart';
import 'package:expense_manager/core/connectivity/connectivity_cubit.dart';
import 'package:expense_manager/core/services/notification/notification_service.dart';
import 'package:expense_manager/core/utils/app_bloc_binding.dart';
import 'package:expense_manager/core/utils/app_snackbar.dart';
import 'package:expense_manager/core/widgets/global_internet_banner.dart';
import 'package:expense_manager/features/auth/bloc/auth_bloc.dart';
import 'package:expense_manager/features/categories/data/category_repository.dart';
import 'package:expense_manager/features/profile_settings/bloc/profile_settings_bloc.dart';
import 'package:expense_manager/features/profile_settings/bloc/profile_settings_event.dart';
import 'package:expense_manager/features/sync/bloc/sync_bloc.dart';
import 'package:expense_manager/features/sync/data/sync_repository.dart';
import 'package:expense_manager/features/sync/service/sync_remote_service.dart';
import 'package:expense_manager/features/transactions/bloc/transaction_bloc.dart';
import 'package:expense_manager/features/transactions/bloc/transaction_event.dart';
import 'package:expense_manager/features/transactions/data/transaction_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();

  runApp(
    /// Provides all required BLoCs to the app
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ConnectivityCubit()),

        BlocProvider<AuthBloc>(
          lazy: false,
          create: (_) => AuthBloc(
            repository: authRepository,
            categoryRepository: categoryRepository,
            categoryRemoteService: categoryRemoteService,
          ),
        ),
        BlocProvider<ProfileSettingsBloc>(
          lazy: false,
          create: (_) =>
              ProfileSettingsBloc(CategoryRepository())..add(LoadCategories()),
        ),

        BlocProvider<SyncBloc>(
          lazy: false,
          create: (_) => SyncBloc(SyncRepository(SyncRemoteService())),
        ),

        BlocProvider<TransactionBloc>(
          lazy: false,
          create: (context) =>
              TransactionBloc(TransactionRepository(), context.read<SyncBloc>())
                ..add(LoadRecentTransactions()),
        ),

        ...AppBlocBinding.blocs,
      ],
      child: const MyApp(),
    ),
  );
}

/// Root application widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRoutes.router,
      scaffoldMessengerKey: AppSnackbar.messengerKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(splashFactory: NoSplash.splashFactory),

      builder: (context, child) {
        return GlobalInternetBanner(child: child ?? const SizedBox());
      },
    );
  }
}
