import 'package:expense_manager/core/constants/app_assets.dart';
import 'package:expense_manager/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final bool isIncome;

  const SummaryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        gradient: _buildGradient(),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          const SizedBox(height: 10),
          _buildAmountRow(),
        ],
      ),
    );
  }

  LinearGradient _buildGradient() {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: isIncome
          ? const [AppColors.lightGreenColour, AppColors.darkGreenColour]
          : const [AppColors.lightRedColour, AppColors.darkRedColour],
    );
  }

  Widget _buildTitle() {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.whiteColor,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildAmountRow() {
    return Row(
      children: [
        SvgPicture.asset(
          _getArrowAsset(),
          width: 18,
          height: 18,
          colorFilter: const ColorFilter.mode(
            AppColors.whiteColor,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          amount,
          style: const TextStyle(
            color: AppColors.whiteColor,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  String _getArrowAsset() {
    return isIncome ? AppAssets.downArrow : AppAssets.upperArrow;
  }
}
