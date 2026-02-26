import 'package:expense_manager/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class OtpInputBox extends StatelessWidget {
  final String value;
  final bool isActive;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  const OtpInputBox({
    super.key,
    required this.value,
    this.isActive = false,
    this.width,
    this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 52,
        height: height ?? 56,
        alignment: Alignment.center,
        decoration: _buildDecoration(),
        child: _buildText(),
      ),
    );
  }

  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      color: AppColors.greyShade,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: isActive ? AppColors.kPrimaryColor : Colors.transparent,
        width: 1.5,
      ),
    );
  }

  Widget _buildText() {
    final displayText = value.isEmpty ? '-' : value;

    return Text(
      displayText,
      style: const TextStyle(
        fontSize: 20,
        color: AppColors.whiteColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
