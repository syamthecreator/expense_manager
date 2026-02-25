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
      create: (_) => SplashBloc()..add(SplashStarted()),
      child: Scaffold(
        backgroundColor: Colors.black,
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
