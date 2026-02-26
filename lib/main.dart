import 'package:expense_manager/app/app_routes.dart';
import 'package:expense_manager/app/auth_repository.dart';
import 'package:expense_manager/core/services/notification/notification_service.dart';
import 'package:expense_manager/core/utils/app_bloc_binding.dart';
import 'package:expense_manager/features/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();

  runApp(
    /// Provides all required BLoCs to the app
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          lazy: false,
          create: (_) => AuthBloc(
            repository: authRepository,
            categoryRepository: categoryRepository,
            categoryRemoteService: categoryRemoteService,
          ),
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(splashFactory: NoSplash.splashFactory),
    );
  }
}
