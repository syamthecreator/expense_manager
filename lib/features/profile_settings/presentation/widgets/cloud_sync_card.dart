import 'package:expense_manager/app/app_routes.dart';
import 'package:expense_manager/core/constants/app_assets.dart';
import 'package:expense_manager/core/utils/app_snackbar.dart';
import 'package:expense_manager/features/auth/bloc/auth_bloc.dart';
import 'package:expense_manager/features/auth/bloc/auth_event.dart';
import 'package:expense_manager/features/sync/bloc/sync_bloc.dart';
import 'package:expense_manager/features/sync/bloc/sync_event.dart';
import 'package:expense_manager/features/sync/bloc/sync_state.dart';
import 'package:flutter/material.dart';
import 'package:expense_manager/core/constants/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class CloudSyncCard extends StatelessWidget {
  const CloudSyncCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CLOUD SYNC',
          style: TextStyle(
            color: AppColors.whiteColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white24),
          ),
          child: BlocListener<SyncBloc, SyncState>(
            listener: (context, state) {
              if (state is SyncSuccess) {
                AppSnackbar.showSuccess("Sync completed successfully");
              }

              if (state is SyncFailure) {
                AppSnackbar.showError(state.message);
              }
            },
            child: BlocBuilder<SyncBloc, SyncState>(
              builder: (context, state) {
                final isSyncing = state is SyncInProgress;
                final isSuccess = state is SyncSuccess;

                return GestureDetector(
                  onTap: isSyncing
                      ? null
                      : () {
                          context.read<SyncBloc>().add(const StartSync());
                        },
                  child: Opacity(
                    opacity: isSyncing ? 0.6 : 1,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2F2F7F),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Sync To Cloud',
                              style: TextStyle(
                                color: AppColors.whiteColor,

                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 22,
                            height: 22,
                            child: isSyncing
                                ? const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation(
                                      AppColors.whiteColor,
                                    ),
                                  )
                                : isSuccess
                                ? const Icon(
                                    Icons.check_circle,
                                    color: AppColors.greenColour,
                                  )
                                : const Icon(
                                    Icons.cloud_outlined,
                                    color: AppColors.whiteColor,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 14),

        GestureDetector(
          onTap: () {
            context.read<AuthBloc>().add(const LogoutRequested());

            context.go(AppRoutes.login);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white24),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Log Out',
                  style: TextStyle(
                    color: AppColors.redColour,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 8),
                Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: SvgPicture.asset(
                      AppAssets.power,
                      colorFilter: const ColorFilter.mode(
                        AppColors.redColour,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
