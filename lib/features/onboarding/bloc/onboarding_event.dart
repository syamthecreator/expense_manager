import 'package:equatable/equatable.dart';

/// Base class for all onboarding events
abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

/// Move to the next onboarding screen
class OnboardingNext extends OnboardingEvent {}

/// Move to the previous onboarding screen
class OnboardingPrevious extends OnboardingEvent {}

/// Skip onboarding and jump to the last screen
class OnboardingSkip extends OnboardingEvent {}