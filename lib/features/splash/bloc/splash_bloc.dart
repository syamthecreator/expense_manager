import 'package:expense_manager/features/splash/model/splash_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'splash_event.dart';
import 'splash_state.dart';
import '../../../../core/constants/app_assets.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  late final SplashModel _model;

  SplashBloc() : super(SplashInitial()) {
    _model = const SplashModel(
      logoPath: AppAssets.logo,
      duration: Duration(seconds: 2),
    );

    on<SplashStarted>(_onStarted);
  }

  Future<void> _onStarted(
    SplashStarted event,
    Emitter<SplashState> emit,
  ) async {
    emit(SplashLoading());
    await Future.delayed(_model.duration);
    emit(SplashFinished());
  }

  SplashModel get model => _model;
}