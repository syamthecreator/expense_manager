import 'package:expense_manager/app/app_keys.dart';
import 'package:expense_manager/app/app_routes.dart';
import 'package:expense_manager/core/constants/app_assets.dart';
import 'package:expense_manager/core/constants/app_colors.dart';
import 'package:expense_manager/core/widgets/primary_button.dart';
import 'package:expense_manager/features/onboarding/bloc/onboarding_bloc.dart';
import 'package:expense_manager/features/onboarding/bloc/onboarding_event.dart';
import 'package:expense_manager/features/onboarding/bloc/onboarding_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingBottomActions extends StatelessWidget {
  final OnboardingState state;

  const OnboardingBottomActions({super.key, required this.state});

  Future<void> _completeOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kHasSeenOnboarding, true);
    if (!context.mounted) return;

    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Row(
        children: [
          if (state.index > 0)
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.whiteColor),
              ),
              child: IconButton(
                icon: SvgPicture.asset(
                  AppAssets.leftArrow,
                  colorFilter: const ColorFilter.mode(
                    AppColors.whiteColor,
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: () =>
                    context.read<OnboardingBloc>().add(OnboardingPrevious()),
              ),
            ),

          if (state.index > 0) const SizedBox(width: 12),

          PrimaryButton(
            isEnabled: true,
            title: state.isLast ? 'Get Started' : 'Next',
            onPressed: () {
              if (state.isLast) {
                _completeOnboarding(context);
              } else {
                context.read<OnboardingBloc>().add(OnboardingNext());
              }
            },
          ),
        ],
      ),
    );
  }
}
