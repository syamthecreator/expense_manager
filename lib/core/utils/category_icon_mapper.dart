import 'package:expense_manager/core/constants/app_assets.dart';

class CategoryIconMapper {
  static const String defaultIcon = AppAssets.category;

  static const Map<String, String> _iconMap = {
    'Food': AppAssets.food,
    'Bills': AppAssets.bill,
    'Transport': AppAssets.transport,
    'Shopping': AppAssets.cart,
  };

  static String getIcon(String categoryName) {
    return _iconMap[categoryName] ?? defaultIcon;
  }
}
