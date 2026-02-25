import 'package:expense_manager/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final double height;
  final double borderRadius;
  final bool isExpanded;

  const PrimaryButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.height = 48,
    this.borderRadius = 8,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final button = SizedBox(
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: const TextStyle(
            color: AppColors.whiteColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );

    return isExpanded ? Expanded(child: button) : button;
  }
}