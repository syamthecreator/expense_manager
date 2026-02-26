import 'package:equatable/equatable.dart';
import 'package:expense_manager/features/onboarding/model/onboarding_model.dart';

/// State for onboarding flow
class OnboardingState extends Equatable {
  final int index;
  final List<OnboardingModel> pages;

  const OnboardingState({required this.index, required this.pages});

  /// Indicates whether the current page is the last
  bool get isLast => index == pages.length - 1;

  @override
  List<Object?> get props => [index, pages];
}
