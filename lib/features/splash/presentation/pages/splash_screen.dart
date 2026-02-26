import 'package:expense_manager/core/constants/app_colors.dart';
import 'package:expense_manager/features/auth/bloc/auth_bloc.dart';
import 'package:expense_manager/features/auth/bloc/auth_event.dart';
import 'package:expense_manager/features/splash/bloc/splash_bloc.dart';
import 'package:expense_manager/features/splash/bloc/splash_event.dart';
import 'package:expense_manager/features/splash/bloc/splash_state.dart';
import 'package:expense_manager/features/splash/presentation/widgets/splash_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(const LoadSession());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashBloc()..add(SplashStarted()),
      child: Scaffold(
        backgroundColor: AppColors.blackColor,
        body: BlocListener<SplashBloc, SplashState>(
          listener: (context, state) {
            if (state is SplashFinished) {
              context.go(state.nextRoute);
            }
          },
          child: Center(
            child: BlocBuilder<SplashBloc, SplashState>(
              builder: (context, state) {
                final bloc = context.read<SplashBloc>();
                return SplashLogo(assetPath: bloc.model.logoPath);
              },
            ),
          ),
        ),
      ),
    );
  }
}
