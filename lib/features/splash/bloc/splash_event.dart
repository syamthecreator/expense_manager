import 'package:equatable/equatable.dart';

/// Base class for all splash events
abstract class SplashEvent extends Equatable {
  const SplashEvent();

  @override
  List<Object?> get props => [];
}

/// Triggered when the splash screen starts
class SplashStarted extends SplashEvent {}
