import 'package:equatable/equatable.dart';

/// Base class for all splash states
abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

/// Initial splash state
class SplashInitial extends SplashState {}

/// Splash loading state
class SplashLoading extends SplashState {}

/// Splash completed state with navigation route
class SplashFinished extends SplashState {
  final String nextRoute;

  const SplashFinished(this.nextRoute);

  @override
  List<Object?> get props => [nextRoute];
}
