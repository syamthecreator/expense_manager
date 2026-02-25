import 'package:expense_manager/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class OtpInputBox extends StatelessWidget {
  final String value;
  final bool isActive;

  const OtpInputBox({super.key, required this.value, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.greyShade,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? AppColors.kPrimaryColor : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Text(
        value.isEmpty ? '-' : value,
        style: const TextStyle(
          fontSize: 20,
          color: AppColors.whiteColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
