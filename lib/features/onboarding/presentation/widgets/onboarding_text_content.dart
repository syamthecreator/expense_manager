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

  static const Duration _animationDuration = Duration(milliseconds: 300);
  static const EdgeInsets _padding = EdgeInsets.symmetric(horizontal: 24);
  static const double _titleFontSize = 22;
  static const double _descriptionFontSize = 14;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _padding,
      child: _AnimatedTextContent(
        title: title,
        description: description,
      ),
    );
  }
}

class _AnimatedTextContent extends StatelessWidget {
  final String title;
  final String description;

  const _AnimatedTextContent({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: OnboardingTextContent._animationDuration,
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      child: _TextBlock(
        key: ValueKey<String>(title),
        title: title,
        description: description,
      ),
    );
  }
}

class _TextBlock extends StatelessWidget {
  final String title;
  final String description;

  const _TextBlock({required this.title, required this.description, super.key});

  static const TextStyle _titleStyle = TextStyle(
    fontSize: OnboardingTextContent._titleFontSize,
    fontWeight: FontWeight.bold,
    color: AppColors.whiteColor,
  );

  static const TextStyle _descriptionStyle = TextStyle(
    fontSize: OnboardingTextContent._descriptionFontSize,
    color: Colors.white70,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: _titleStyle),
        const SizedBox(height: 12),
        Text(description, style: _descriptionStyle),
      ],
    );
  }
}
