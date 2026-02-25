import 'package:expense_manager/app/app_routes.dart';
import 'package:expense_manager/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingSkipButton extends StatelessWidget {
  const OnboardingSkipButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(top: 8, right: 16),
          child: TextButton(
            onPressed: () => context.go(AppRoutes.home),
            child: const Text(
              'SKIP',
              style: TextStyle(
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
