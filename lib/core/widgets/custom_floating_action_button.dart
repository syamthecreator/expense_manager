import 'package:expense_manager/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CustomFloatingActionButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.flotingActionButtonColour1,
            AppColors.flotingActionButtonColour2,
          ],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 0),
            blurRadius: 25,
            spreadRadius: 0,
            color: const Color(0xFFFFFF19).withValues(alpha: 0.25),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: const Center(
            child: Icon(Icons.add, color: AppColors.whiteColor, size: 30),
          ),
        ),
      ),
    );
  }
}
