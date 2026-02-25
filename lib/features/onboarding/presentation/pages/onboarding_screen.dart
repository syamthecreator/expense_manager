import 'package:expense_manager/features/onboarding/presentation/widgets/onboarding_background.dart';
import 'package:expense_manager/features/onboarding/presentation/widgets/onboarding_bottom_actions.dart';
import 'package:expense_manager/features/onboarding/presentation/widgets/onboarding_progress_indicator.dart';
import 'package:expense_manager/features/onboarding/presentation/widgets/onboarding_skip_button.dart';
import 'package:expense_manager/features/onboarding/presentation/widgets/onboarding_text_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/onboarding_bloc.dart';
import '../../bloc/onboarding_state.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingBloc(),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatelessWidget {
  const _OnboardingView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, state) {
          final page = state.pages[state.index];

          return Stack(
            children: [
              OnboardingBackground(image: page.image),
              const OnboardingSkipButton(),

              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),

                    OnboardingProgressIndicator(
                      currentIndex: state.index,
                      total: state.pages.length,
                    ),

                    const SizedBox(height: 24),

                    OnboardingTextContent(
                      title: page.title,
                      description: page.description,
                    ),

                    const SizedBox(height: 28),

                    OnboardingBottomActions(state: state),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
