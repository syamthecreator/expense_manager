import 'package:expense_manager/core/constants/app_colors.dart';
import 'package:expense_manager/core/connectivity/connectivity_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GlobalInternetBanner extends StatelessWidget {
  final Widget child;

  const GlobalInternetBanner({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,

        BlocBuilder<ConnectivityCubit, ConnectivityStatus>(
          builder: (context, state) {
            final showBanner =
                state == ConnectivityStatus.offline ||
                state == ConnectivityStatus.backOnline;

            if (!showBanner) return const SizedBox();

            final isOnline = state == ConnectivityStatus.backOnline;

            return AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              top: 20,
              left: 16,
              right: 16,
              child: SafeArea(
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(12),
                  color: isOnline ? AppColors.greenColour : AppColors.redColour,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isOnline ? Icons.wifi : Icons.wifi_off,
                          color: AppColors.whiteColor,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            isOnline ? "Back Online" : "No Internet Connection",
                            style: const TextStyle(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
