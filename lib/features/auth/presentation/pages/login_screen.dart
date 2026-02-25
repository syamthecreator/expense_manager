import 'package:expense_manager/app/app_routes.dart';
import 'package:expense_manager/core/constants/app_colors.dart';
import 'package:expense_manager/core/widgets/primary_button.dart';
import 'package:expense_manager/features/auth/bloc/auth_bloc.dart';
import 'package:expense_manager/features/auth/bloc/auth_event.dart';
import 'package:expense_manager/features/auth/bloc/auth_state.dart';
import 'package:expense_manager/features/auth/presentation/widgets/auth_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) => const _LoginView();
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  static const _horizontalPadding = 24.0;
  static const _spacingSmall = 8.0;
  static const _spacingMedium = 24.0;
  static const _spacingLarge = 32.0;

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
        child: BlocListener<AuthBloc, AuthState>(
          listener: _handleAuthState,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 80),
              _HeaderText(),
              SizedBox(height: _spacingSmall),
              _SubtitleText(),
              SizedBox(height: _spacingLarge),
              _PhoneInputField(),
              SizedBox(height: _spacingMedium),
              _ContinueButton(),
              SizedBox(height: _spacingLarge),
            ],
          ),
        ),
      ),
    );
  }

  void _handleAuthState(BuildContext context, AuthState state) {
    if (state.status == AuthStatus.otpSent) {
      context.push('${AppRoutes.login}/verifyOtp');
    }
  }
}

class _HeaderText extends StatelessWidget {
  const _HeaderText();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Get Started',
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
      'Log In Using Phone & OTP',
      style: TextStyle(fontSize: 16, color: Colors.white70),
    );
  }
}

class _PhoneInputField extends StatelessWidget {
  const _PhoneInputField();

  static const _countryCode = '+91';
  static const _inputDecoration = InputDecoration(
    hintText: 'Phone',
    hintStyle: TextStyle(color: Colors.white38),
    border: InputBorder.none,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.greyShade,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Text(
            _countryCode,
            style: TextStyle(color: AppColors.whiteColor, fontSize: 16),
          ),
          const SizedBox(width: 12),
          const VerticalDivider(
            color: AppColors.whiteColor,
            thickness: 1,
            width: 1,
            indent: 18,
            endIndent: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: AppColors.whiteColor),
              onChanged: (value) =>
                  context.read<AuthBloc>().add(PhoneNumberChanged(value)),
              decoration: _inputDecoration,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  const _ContinueButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isValid = isValidIndianMobile(state.phone);
        return SizedBox(
          width: double.infinity,
          child: PrimaryButton(
            title: state.status == AuthStatus.sendingOtp
                ? 'Sending...'
                : 'Continue',
            isExpanded: false,
            isEnabled: isValid,

            onPressed: isValidIndianMobile(state.phone)
                ? () => context.read<AuthBloc>().add(SubmitPhoneNumber())
                : null,
          ),
        );
      },
    );
  }

  bool isValidIndianMobile(String phone) {
    final regex = RegExp(r'^[6-9]\d{9}$');
    return regex.hasMatch(phone);
  }
}
