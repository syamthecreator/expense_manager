import 'package:go_router/go_router.dart';

// Auth
import 'package:expense_manager/features/auth/presentation/pages/login_screen.dart';
import 'package:expense_manager/features/auth/presentation/pages/nickname_screen.dart';
import 'package:expense_manager/features/auth/presentation/pages/verify_otp_screen.dart';

// Splash & Onboarding
import 'package:expense_manager/features/splash/presentation/pages/splash_screen.dart';
import 'package:expense_manager/features/onboarding/presentation/pages/onboarding_screen.dart';

// Home & Navigation
import 'package:expense_manager/navigation/bottom_nav_shell.dart';
import 'package:expense_manager/features/home/presentation/pages/home_screen.dart';
import 'package:expense_manager/features/transactions/presentation/pages/transaction_screen.dart';
import 'package:expense_manager/features/profile_settings/presentation/pages/profile_and_settings_screen.dart';

class AppRoutes {
  // Route names
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const verifyOtp = '$login/verifyOtp';
  static const nickname = '$login/nickname';
  static const home = '/home';
  static const transaction = '/transaction';
  static const profileAndSettings = '/profileAndSettings';

  static final GoRouter router = GoRouter(
    initialLocation: splash, // Start with splash screen
    routes: [
      // Public routes (no authentication required)
      GoRoute(path: splash, builder: (_, _) => const SplashScreen()),
      GoRoute(path: onboarding, builder: (_, _) => const OnboardingScreen()),

      // Authentication flow routes
      GoRoute(path: login, builder: (_, _) => const LoginScreen()),
      GoRoute(path: verifyOtp, builder: (_, _) => const VerifyOtpScreen()),
      GoRoute(path: nickname, builder: (_, _) => NicknameScreen()),

      // Protected routes with bottom navigation
      ShellRoute(
        builder: (context, state, child) {
          return BottomNavShell(child: child);
        },
        routes: [
          GoRoute(path: home, builder: (_, _) => const HomeScreen()),
          GoRoute(
            path: transaction,
            builder: (_, _) => const TransactionScreen(),
          ),
          GoRoute(
            path: profileAndSettings,
            builder: (_, _) => const ProfileAndSettingsScreen(),
          ),
        ],
      ),
    ],
  );
}
