import 'package:expense_manager/app/app_routes.dart';
import 'package:expense_manager/core/constants/app_assets.dart';
import 'package:expense_manager/core/constants/app_colors.dart';
import 'package:expense_manager/core/utils/helper.dart';
import 'package:expense_manager/core/widgets/primary_button.dart';
import 'package:expense_manager/features/auth/bloc/auth_bloc.dart';
import 'package:expense_manager/features/auth/bloc/auth_event.dart';
import 'package:expense_manager/features/auth/bloc/auth_state.dart';
import 'package:expense_manager/features/auth/presentation/widgets/auth_background.dart';
import 'package:expense_manager/features/auth/presentation/widgets/otp_input_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
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
    _initializeScreen();
  }

  void _initializeScreen() {
    context.read<AuthBloc>().add(const ClearOtp());
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
          child: const _VerifyOtpContent(),
        ),
      ),
    );
  }

  void _handleAuthState(BuildContext context, AuthState state) {
    switch (state.status) {
      case AuthStatus.authenticated:
        context.go(AppRoutes.home);
        break;
      case AuthStatus.needsNickname:
        context.go(AppRoutes.nickname);
        break;
      default:
        break;
    }
  }
}

// Extracted main content widget
class _VerifyOtpContent extends StatelessWidget {
  const _VerifyOtpContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
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
        _OtpInputSection(),
        SizedBox(height: 32),
        _VerifyButtonSection(),
        SizedBox(height: 16),
        _FooterText(),
      ],
    );
  }
}

// Extracted widgets with single responsibility
class _BackButton extends StatelessWidget {
  const _BackButton();

  void _handleBackPress(BuildContext context) {
    context.read<AuthBloc>().add(const ClearOtp());
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleBackPress(context),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.blackColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0x33F0F0F0), width: 1),
        ),
        alignment: Alignment.center,
        child: SvgPicture.asset(
          AppAssets.iosLeftArrow,
          colorFilter: const ColorFilter.mode(
            AppColors.whiteColor,
            BlendMode.srcIn,
          ),
        ),
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
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final maskedPhone = Helper().maskIndianPhone(state.phone);

        return Text(
          'Enter the 6-digit code sent to $maskedPhone',
          style: const TextStyle(color: Colors.white70),
        );
      },
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

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.yellow.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.yellow.withValues(alpha: 0.3)),
          ),
          child: Text(
            '🔑 Test OTP: ${state.apiOtp}',
            style: const TextStyle(
              color: Colors.yellowAccent,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        );
      },
    );
  }
}

class _OtpInputSection extends StatelessWidget {
  const _OtpInputSection();

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
            (index) => _OtpInputBoxWrapper(
              index: index,
              value: otp[index],
              isActive: index == state.otp.length,
            ),
          ),
        );
      },
    );
  }
}

// Wrapper for OtpInputBox with key for proper rebuilding
class _OtpInputBoxWrapper extends StatelessWidget {
  final int index;
  final String value;
  final bool isActive;

  const _OtpInputBoxWrapper({
    required this.index,
    required this.value,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return OtpInputBox(
      key: ValueKey('otp_$index'),
      value: value.trim(),
      isActive: isActive,
    );
  }
}

class _VerifyButtonSection extends StatelessWidget {
  const _VerifyButtonSection();

  bool _isEnabled(AuthState state) {
    return RegExp(r'^\d{6}$').hasMatch(state.otp) &&
        state.status != AuthStatus.verifying;
  }

  String _getButtonText(AuthState state) {
    switch (state.status) {
      case AuthStatus.verifying:
        return 'Verifying...';
      case AuthStatus.error:
        return 'Try Again';
      default:
        return 'Verify';
    }
  }

  void _verifyOtp(BuildContext context) {
    context.read<AuthBloc>().add(VerifyOtp());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final enabled = _isEnabled(state);
        final buttonText = _getButtonText(state);

        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: 
              
              PrimaryButton(
                isExpanded: false,
                title: buttonText,
                isEnabled: enabled,
                onPressed: enabled ? () => _verifyOtp(context) : null,
              ),
            ),
            if (state.status == AuthStatus.error && state.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  state.errorMessage!,
                  style: const TextStyle(color: Colors.redAccent),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _FooterText extends StatelessWidget {
  const _FooterText();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: const Text(
        'OTP auto-filled for testing purposes',
        style: TextStyle(color: Colors.white38, fontSize: 14),
        textAlign: TextAlign.center,
      ),
    );
  }
}
