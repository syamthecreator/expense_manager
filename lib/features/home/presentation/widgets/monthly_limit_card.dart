import 'package:expense_manager/core/constants/app_colors.dart';
import 'package:expense_manager/features/home/model/monthly_limit_model.dart';
import 'package:flutter/material.dart';

class MonthlyLimitCard extends StatelessWidget {
  final MonthlyLimitModel model;

  const MonthlyLimitCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _buildDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 10),
          _buildAmountText(),
          const SizedBox(height: 10),
          _buildProgressBar(),
          const SizedBox(height: 10),
          _buildRemainingText(),
        ],
      ),
    );
  }

  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(22),
      color: const Color(0xFF191919),
      border: Border.all(color: const Color(0x1AFFFFFF)),
    );
  }

  Widget _buildHeader() {
    return const Text(
      'MONTHLY LIMIT',
      style: TextStyle(
        color: Color(0xB3FFFFFF),
        fontSize: 13,
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildAmountText() {
    final spentAmount = '₹${model.spentAmount.toStringAsFixed(0)}';
    final totalAmount = ' / ₹${model.totalLimit.toStringAsFixed(0)}';

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: spentAmount,
            style: const TextStyle(
              color: Color.fromRGBO(255, 255, 255, 0.6),
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: totalAmount,
            style: const TextStyle(color: Colors.white54, fontSize: 26),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 10,
        width: double.infinity,
        color: Colors.white24,
        child: _buildProgressFill(),
      ),
    );
  }

  Widget _buildProgressFill() {
    return FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: model.progress.clamp(0.0, 1.0),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [AppColors.startGreen, AppColors.endGreen],
          ),
        ),
      ),
    );
  }

  Widget _buildRemainingText() {
    return Text(
      '${model.remainingPercentage}% Remaining',
      style: const TextStyle(color: Color(0x99FFFFFF), fontSize: 16),
    );
  }
}
