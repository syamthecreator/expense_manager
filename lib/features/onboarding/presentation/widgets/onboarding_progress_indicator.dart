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
        builder: (context, constraints) {
          const gap = 12.0;
          final totalGap = gap * (total - 1);
          final barWidth = (constraints.maxWidth - totalGap) / total;

          return Row(
            children: List.generate(
              total,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.only(right: index == total - 1 ? 0 : gap),
                width: barWidth,
                height: 4,
                decoration: BoxDecoration(
                  color: index <= currentIndex
                      ? AppColors.whiteColor
                      : Colors.white38,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
