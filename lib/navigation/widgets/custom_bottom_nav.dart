import 'package:expense_manager/core/constants/app_assets.dart';
import 'package:expense_manager/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      margin: const EdgeInsets.only(bottom: 16),
      child: Center(
        child: IntrinsicWidth(
          child: Container(
            height: 64,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: const Color(0xFF2B2B2B),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: AppColors.whiteColor.withValues(alpha: 0.35),
                width: 3,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _NavSvgItem(
                  asset: AppAssets.chart,
                  index: 0,
                  selectedIndex: selectedIndex,
                  onTap: onTap,
                ),
                const SizedBox(width: 20),
                _NavSvgItem(
                  asset: AppAssets.sync,
                  index: 1,
                  selectedIndex: selectedIndex,
                  onTap: onTap,
                ),
                const SizedBox(width: 20),
                _NavSvgItem(
                  asset: AppAssets.profileSettings,
                  index: 2,
                  selectedIndex: selectedIndex,
                  onTap: onTap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavSvgItem extends StatelessWidget {
  final String asset;
  final int index;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _NavSvgItem({
    required this.asset,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  bool get isActive => index == selectedIndex;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? AppColors.kPrimaryColor : Colors.transparent,
        ),
        child: Center(
          child: SvgPicture.asset(
            asset,
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              AppColors.whiteColor,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
