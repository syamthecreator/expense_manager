class MonthlyLimitModel {
  final double spentAmount;
  final double totalLimit;

  MonthlyLimitModel({
    required this.spentAmount,
    required this.totalLimit,
  });

  double get progress => spentAmount / totalLimit;

  int get remainingPercentage =>
      ((1 - progress) * 100).clamp(0, 100).round();
}