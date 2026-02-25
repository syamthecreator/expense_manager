import 'package:expense_manager/app/app_routes.dart';
import 'package:expense_manager/core/constants/app_colors.dart';
import 'package:expense_manager/features/splash/bloc/splash_bloc.dart';
import 'package:expense_manager/features/splash/bloc/splash_event.dart';
import 'package:expense_manager/features/splash/bloc/splash_state.dart';
import 'package:expense_manager/features/splash/presentation/widgets/splash_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Creates SplashBloc only for this screen and disposes it after navigation
      create: (_) => SplashBloc()..add(SplashStarted()),
      child: const _SplashView(),
    );
  }
}

class _SplashView extends StatelessWidget {
  const _SplashView();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SplashBloc>();

    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      body: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashFinished) {
            context.go(AppRoutes.onboarding);
          }
        },
        child: Center(
          child: SplashLogo(assetPath: bloc.model.logoPath, size: 160),
        ),
      ),
    );
  }
}
