import 'package:expense_manager/core/constants/app_colors.dart';
import 'package:expense_manager/features/profile_settings/bloc/profile_settings_bloc.dart';
import 'package:expense_manager/features/profile_settings/bloc/profile_settings_state.dart';
import 'package:expense_manager/features/profile_settings/presentation/widgets/alert_limit_card.dart';
import 'package:expense_manager/features/profile_settings/presentation/widgets/categories_card.dart';
import 'package:expense_manager/features/profile_settings/presentation/widgets/cloud_sync_card.dart';
import 'package:expense_manager/features/profile_settings/presentation/widgets/nickname_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileAndSettingsScreen extends StatelessWidget {
  const ProfileAndSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController categoryController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Profile & Settings',
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),

              const NicknameCard(),
              const SizedBox(height: 24),

              const AlertLimitCard(),

              const SizedBox(height: 16),
              const Divider(
                thickness: 3,
                height: 3,
                color: AppColors.greyShade,
              ),

              const SizedBox(height: 16),

              BlocBuilder<ProfileSettingsBloc, ProfileSettingsState>(
                builder: (context, state) {
                  return CategoriesCard(
                    controller: categoryController,
                    categories: state.data.categories,
                  );
                },
              ),

              const SizedBox(height: 16),
              const Divider(
                thickness: 3,
                height: 3,
                color: AppColors.greyShade,
              ),

              const SizedBox(height: 24),

              const CloudSyncCard(),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
