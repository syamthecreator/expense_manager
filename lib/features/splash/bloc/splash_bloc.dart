import 'package:expense_manager/app/app_keys.dart';
import 'package:expense_manager/app/app_routes.dart';
import 'package:expense_manager/features/splash/model/splash_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_assets.dart';
import 'splash_event.dart';
import 'splash_state.dart';

/// BLoC responsible for splash screen flow
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  late final SplashModel _model;

  SplashBloc() : super(SplashInitial()) {
    _model = const SplashModel(
      logoPath: AppAssets.logo,
      duration: Duration(seconds: 2),
    );

    on<SplashStarted>(_onStarted);
  }

  /// Handles splash startup logic and navigation decision
  Future<void> _onStarted(
    SplashStarted event,
    Emitter<SplashState> emit,
  ) async {
    emit(SplashLoading());

    await Future.delayed(_model.duration);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final hasSeenOnboarding = prefs.getBool(kHasSeenOnboarding) ?? false;

    late final String nextRoute;

    if (token != null) {
      nextRoute = AppRoutes.home;
    } else if (!hasSeenOnboarding) {
      nextRoute = AppRoutes.onboarding;
    } else {
      nextRoute = AppRoutes.login;
    }

    emit(SplashFinished(nextRoute));
  }

  /// Exposes splash configuration model
  SplashModel get model => _model;
}
