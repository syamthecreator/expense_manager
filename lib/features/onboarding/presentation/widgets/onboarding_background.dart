import 'package:expense_manager/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class OnboardingBackground extends StatelessWidget {
  final String image;

  const OnboardingBackground({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: Image.asset(image, fit: BoxFit.cover)),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.blackColor.withValues(alpha: 0.25),
                  AppColors.blackColor.withValues(alpha: 0.97),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
