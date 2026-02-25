import 'package:expense_manager/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:expense_manager/features/splash/presentation/pages/splash_screen.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  // Route names
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const home = '/home';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(path: splash, builder: (context, state) => const SplashScreen()),
      GoRoute(path: onboarding, builder: (_, _) => const OnboardingScreen()),
    ],
  );
}
