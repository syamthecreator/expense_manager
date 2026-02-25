import 'package:expense_manager/app/di.dart';
import 'package:expense_manager/features/auth/bloc/auth_bloc.dart';

import 'package:expense_manager/features/auth/presentation/pages/login_screen.dart';
import 'package:expense_manager/features/auth/presentation/pages/nickname_screen.dart';
import 'package:expense_manager/features/auth/presentation/pages/verify_otp_screen.dart';
import 'package:expense_manager/features/home/presentation/pages/home_screen.dart';
import 'package:expense_manager/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:expense_manager/features/splash/presentation/pages/splash_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const home = '/home';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(path: splash, builder: (_, _) => const SplashScreen()),

      GoRoute(path: onboarding, builder: (_, _) => const OnboardingScreen()),

      ShellRoute(
        builder: (context, state, child) {
          return BlocProvider<AuthBloc>(
            create: (_) => AuthBloc(authRepository),
            child: child,
          );
        },
        routes: [
          GoRoute(path: login, builder: (_, _) => const LoginScreen()),
          GoRoute(
            path: '$login/verifyOtp',
            builder: (_, _) => const VerifyOtpScreen(),
          ),
          GoRoute(path: '$login/nickname', builder: (_, _) => NicknameScreen()),
        ],
      ),
      GoRoute(path: home, builder: (_, _) => const HomeScreen()),
    ],
  );
}
