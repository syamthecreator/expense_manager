import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashFinished extends SplashState {
  final String nextRoute;

  const SplashFinished(this.nextRoute);

  @override
  List<Object?> get props => [nextRoute];
}