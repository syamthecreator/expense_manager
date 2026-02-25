import 'package:expense_manager/app/app_routes.dart';
import 'package:expense_manager/core/constants/app_colors.dart';
import 'package:expense_manager/core/widgets/primary_button.dart';
import 'package:expense_manager/features/auth/bloc/auth_bloc.dart';
import 'package:expense_manager/features/auth/bloc/auth_event.dart';
import 'package:expense_manager/features/auth/bloc/auth_state.dart';
import 'package:expense_manager/features/auth/presentation/widgets/auth_background.dart';
import 'package:expense_manager/features/auth/presentation/widgets/otp_input_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  static const _padding = 24.0;

  @override
  void initState() {
    super.initState();
    _scheduleOtpAutoFill();
  }

  void _scheduleOtpAutoFill() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<AuthBloc>();
      final state = bloc.state;

      if (state.apiOtp != null && state.otp.isEmpty) {
        bloc.add(OtpChanged(state.apiOtp!));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: Padding(
        padding: const EdgeInsets.all(_padding),
        child: BlocListener<AuthBloc, AuthState>(
          listener: _handleAuthState,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _BackButton(),
              SizedBox(height: 24),
              _HeaderText(),
              SizedBox(height: 8),
              _SubtitleText(),
              SizedBox(height: 12),
              _TestOtpDisplay(),
              SizedBox(height: 32),
              _OtpInputBoxes(),
              SizedBox(height: 32),
              _VerifyButton(),
              SizedBox(height: 16),
              _FooterText(),
            ],
          ),
        ),
      ),
    );
  }

  void _handleAuthState(BuildContext context, AuthState state) {
    if (state.status == AuthStatus.authenticated) {
      context.go(AppRoutes.home);
    } else if (state.status == AuthStatus.needsNickname) {
      context.go('/login/nickname');
    }
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pop(),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color.fromRGBO(240, 240, 240, 0.2),
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
      ),
    );
  }
}

class _HeaderText extends StatelessWidget {
  const _HeaderText();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Verify OTP',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.whiteColor,
      ),
    );
  }
}

class _SubtitleText extends StatelessWidget {
  const _SubtitleText();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Enter the 6-digit code',
      style: TextStyle(color: Colors.white70),
    );
  }
}

class _TestOtpDisplay extends StatelessWidget {
  const _TestOtpDisplay();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state.apiOtp == null) return const SizedBox.shrink();

        return Text(
          'TEST OTP: ${state.apiOtp}',
          style: const TextStyle(
            color: Colors.yellowAccent,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        );
      },
    );
  }
}

class _OtpInputBoxes extends StatelessWidget {
  const _OtpInputBoxes();

  static const _otpLength = 6;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final otp = state.otp.padRight(_otpLength);

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            _otpLength,
            (index) => OtpInputBox(
              value: otp[index].trim(),
              isActive: index == state.otp.length,
            ),
          ),
        );
      },
    );
  }
}

class _VerifyButton extends StatelessWidget {
  const _VerifyButton();

  bool _isEnabled(AuthState state) {
    return RegExp(r'^\d{6}$').hasMatch(state.otp) &&
        state.status != AuthStatus.verifying;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final enabled = _isEnabled(state);

        return SizedBox(
          width: double.infinity,
          child: PrimaryButton(
            isExpanded: false,
            title: state.status == AuthStatus.verifying
                ? 'Verifying...'
                : 'Verify',
            isEnabled: enabled,
            onPressed: enabled ? () => _verifyOtp(context) : null,
          ),
        );
      },
    );
  }

  void _verifyOtp(BuildContext context) {
    context.read<AuthBloc>().add(VerifyOtp());
  }
}

class _FooterText extends StatelessWidget {
  const _FooterText();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'OTP auto-filled for testing purposes',
      style: TextStyle(color: Colors.white38),
    );
  }
}
