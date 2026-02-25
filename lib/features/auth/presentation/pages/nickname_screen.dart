import 'package:expense_manager/app/app_routes.dart';
import 'package:expense_manager/core/constants/app_assets.dart';
import 'package:expense_manager/core/constants/app_colors.dart';
import 'package:expense_manager/core/widgets/primary_button.dart';
import 'package:expense_manager/features/auth/bloc/auth_bloc.dart';
import 'package:expense_manager/features/auth/bloc/auth_event.dart';
import 'package:expense_manager/features/auth/bloc/auth_state.dart';
import 'package:expense_manager/features/auth/presentation/widgets/auth_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class NicknameScreen extends StatefulWidget {
  const NicknameScreen({super.key});

  @override
  State<NicknameScreen> createState() => _NicknameScreenState();
}

class _NicknameScreenState extends State<NicknameScreen> {
  late final TextEditingController _controller;
  static const _spacingSmall = 8.0;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: BlocListener<AuthBloc, AuthState>(
          listener: _handleAuthState,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const _HeaderText(),
              SizedBox(height: _spacingSmall),
              _SubtitleText(),
              const SizedBox(height: 24),
              _NicknameInputField(controller: _controller),
              const SizedBox(height: 24),
              _ContinueButton(controller: _controller),
            ],
          ),
        ),
      ),
    );
  }

  void _handleAuthState(BuildContext context, AuthState state) {
    if (state.status == AuthStatus.authenticated) {
      context.go(AppRoutes.home);
    }
  }
}

class _HeaderText extends StatelessWidget {
  const _HeaderText();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          '👋 What should we call you?',
          style: TextStyle(
            color: AppColors.whiteColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _SubtitleText extends StatelessWidget {
  const _SubtitleText();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'This name stays only on your device.',
      style: TextStyle(fontSize: 16, color: Colors.white70),
    );
  }
}

class _NicknameInputField extends StatelessWidget {
  const _NicknameInputField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final isNotEmpty = value.text.trim().isNotEmpty;

        return Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.greyShade,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  style: const TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 16,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Nickname',
                    hintStyle: TextStyle(color: Colors.white38),
                    border: InputBorder.none,
                    isCollapsed: true,
                  ),
                ),
              ),

              if (isNotEmpty)
                SvgPicture.asset(AppAssets.verified, width: 24, height: 24),
            ],
          ),
        );
      },
    );
  }
}

class _ContinueButton extends StatelessWidget {
  const _ContinueButton({required this.controller});

  final TextEditingController controller;

  bool _isEnabled(AuthState state, String text) {
    return text.trim().isNotEmpty && state.status != AuthStatus.verifying;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) {
            final enabled = _isEnabled(state, value.text);

            return SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                isExpanded: false,
                isEnabled: enabled,
                title: state.status == AuthStatus.verifying
                    ? 'Creating...'
                    : 'Continue',
                onPressed: enabled ? () => _submitNickname(context) : null,
              ),
            );
          },
        );
      },
    );
  }

  void _submitNickname(BuildContext context) {
    final nickname = controller.text.trim();
    if (nickname.isNotEmpty) {
      context.read<AuthBloc>().add(SubmitNickname(nickname));
    }
  }
}
