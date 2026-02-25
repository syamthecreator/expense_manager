import 'package:expense_manager/core/constants/app_assets.dart';
import 'package:expense_manager/features/onboarding/model/onboarding_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc()
    : super(
        OnboardingState(
          index: 0,
          pages: const [
            OnboardingModel(
              image: AppAssets.onboardingImage,
              title: 'Privacy by Default, With Zero Ads or Hidden Tracking',
              description: 'No ads. No trackers. No third-party analytics.',
            ),
            OnboardingModel(
              image: AppAssets.onboardingImage,
              title: 'Insights That Help You Spend Better Without Complexity',
              description: 'See category-wise spending, recent activity.',
            ),
            OnboardingModel(
              image: AppAssets.onboardingImage,
              title: 'Local-First Tracking That Stays Fully On Your Device',
              description: 'Your finances stay on your phone.',
            ),
          ],
        ),
      ) {
    on<OnboardingNext>((event, emit) {
      if (!state.isLast) {
        emit(state.copyWith(index: state.index + 1));
      }
    });

    on<OnboardingPrevious>((event, emit) {
      if (state.index > 0) {
        emit(state.copyWith(index: state.index - 1));
      }
    });

    on<OnboardingSkip>((event, emit) {
      emit(state.copyWith(index: state.pages.length - 1));
    });
  }
}

extension on OnboardingState {
  OnboardingState copyWith({int? index}) {
    return OnboardingState(index: index ?? this.index, pages: pages);
  }
}
