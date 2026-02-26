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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingBottomActions extends StatelessWidget {
  final OnboardingState state;

  const OnboardingBottomActions({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Row(
        children: [
          if (state.index > 0) ...[
            _buildBackButton(context),
            const SizedBox(width: 12),
          ],
          _buildNextButton(context),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Container(
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
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return Expanded(
      child: PrimaryButton(
        isEnabled: true,
        isExpanded: false,
        title: state.isLast ? 'Get Started' : 'Next',
        onPressed: () => _handleButtonPress(context),
      ),
    );
  }

  Future<void> _handleButtonPress(BuildContext context) async {
    if (state.isLast) {
      await _completeOnboarding(context);
    } else {
      context.read<OnboardingBloc>().add(OnboardingNext());
    }
  }

  Future<void> _completeOnboarding(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(kHasSeenOnboarding, true);
      if (context.mounted) {
        context.go(AppRoutes.login);
      }
    } catch (e) {
      debugPrint('Error completing onboarding: $e');
    }
  }
}
