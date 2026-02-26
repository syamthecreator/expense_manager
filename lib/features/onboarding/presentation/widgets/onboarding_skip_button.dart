import 'package:expense_manager/app/app_keys.dart';
import 'package:expense_manager/app/app_routes.dart';
import 'package:expense_manager/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingSkipButton extends StatelessWidget {
  const OnboardingSkipButton({super.key});

  static const TextStyle _textStyle = TextStyle(
    color: AppColors.whiteColor,
    fontWeight: FontWeight.w500,
    fontSize: 15,
  );

  static const EdgeInsets _padding = EdgeInsets.only(top: 8, right: 16);

  Future<void> _handleSkip(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(kHasSeenOnboarding, true);
      if (context.mounted) {
        context.go(AppRoutes.login);
      }
    } catch (e) {
      debugPrint('Error skipping onboarding: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: _padding,
          child: TextButton(
            onPressed: () => _handleSkip(context),
            child: const Text('SKIP', style: _textStyle),
          ),
        ),
      ),
    );
  }
}
