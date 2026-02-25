import 'package:expense_manager/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class OnboardingTextContent extends StatelessWidget {
  final String title;
  final String description;

  const OnboardingTextContent({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        child: _TextBlock(
          key: ValueKey(title),
          title: title,
          description: description,
        ),
      ),
    );
  }
}

class _TextBlock extends StatelessWidget {
  final String title;
  final String description;

  const _TextBlock({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.whiteColor,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          description,
          style: const TextStyle(fontSize: 14, color: Colors.white70),
        ),
      ],
    );
  }
}
