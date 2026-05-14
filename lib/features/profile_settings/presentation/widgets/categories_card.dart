import 'package:expense_manager/core/constants/app_assets.dart';
import 'package:expense_manager/core/constants/app_colors.dart';
import 'package:expense_manager/features/profile_settings/bloc/profile_settings_bloc.dart';
import 'package:expense_manager/features/profile_settings/bloc/profile_settings_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class CategoriesCard extends StatelessWidget {
  final List<String> categories;
  final TextEditingController controller;

  const CategoriesCard({
    super.key,
    required this.categories,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CATEGORIES',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 14),

          /// ADD CATEGORY INPUT
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2C),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    textCapitalization: TextCapitalization.words,
                    controller: controller,
                    style: const TextStyle(color: AppColors.whiteColor),
                    decoration: const InputDecoration(
                      hintText: 'New category name',
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 48,
                width: 48,
                child: ElevatedButton(
                  onPressed: () {
                    final name = controller.text.trim();
                    if (name.isEmpty) return;

                    context.read<ProfileSettingsBloc>().add(AddCategory(name));

                    controller.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 24,
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(color: Colors.white10),
          const SizedBox(height: 8),

          /// CATEGORY LIST
          if (categories.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'No categories yet',
                style: TextStyle(color: Colors.white54),
              ),
            ),

          ...categories.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.read<ProfileSettingsBloc>().add(
                        RemoveCategory(item),
                      );
                    },
                    child: Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(181, 3, 3, 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color.fromRGBO(181, 3, 3, 1),
                        ),
                      ),
                      child: Center(
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: SvgPicture.asset(
                            AppAssets.trash2,
                            colorFilter: const ColorFilter.mode(
                              Color.fromRGBO(181, 3, 3, 1),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
