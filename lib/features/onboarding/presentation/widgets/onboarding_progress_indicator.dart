import 'package:expense_manager/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class OnboardingProgressIndicator extends StatelessWidget {
  final int currentIndex;
  final int total;

  const OnboardingProgressIndicator({
    super.key,
    required this.currentIndex,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: LayoutBuilder(
        builder: (context, constraints) => _buildProgressBars(constraints),
      ),
    );
  }

  Widget _buildProgressBars(BoxConstraints constraints) {
    const gap = 12.0;
    final totalGap = gap * (total - 1);
    final barWidth = (constraints.maxWidth - totalGap) / total;

    return Row(
      children: List.generate(
        total,
        (index) => _buildProgressBar(index, barWidth, index == total - 1),
      ),
    );
  }

  Widget _buildProgressBar(int index, double width, bool isLast) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.only(right: isLast ? 0 : 12),
      width: width,
      height: 4,
      decoration: BoxDecoration(
        color: _getBarColor(index),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Color _getBarColor(int index) {
    return index <= currentIndex
        ? AppColors.whiteColor
        : Colors.white38;
  }
}