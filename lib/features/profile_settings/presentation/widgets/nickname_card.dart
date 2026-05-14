import 'package:expense_manager/core/constants/app_assets.dart';
import 'package:expense_manager/core/constants/app_colors.dart';
import 'package:expense_manager/core/widgets/primary_button.dart';
import 'package:expense_manager/features/auth/bloc/auth_bloc.dart';
import 'package:expense_manager/features/auth/bloc/auth_event.dart';
import 'package:expense_manager/features/auth/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class NicknameCard extends StatefulWidget {
  const NicknameCard({super.key});

  @override
  State<NicknameCard> createState() => _NicknameCardState();
}

class _NicknameCardState extends State<NicknameCard> {
  final TextEditingController _nicknameController = TextEditingController();
  final ValueNotifier<bool> _isEditingNickname = ValueNotifier(false);

  @override
  void dispose() {
    _nicknameController.dispose();
    _isEditingNickname.dispose();
    super.dispose();
  }

  void _saveNickname(BuildContext context) {
    final newName = _nicknameController.text.trim();
    if (newName.isEmpty) return;

    context.read<AuthBloc>().add(UpdateNickname(newName));
    FocusScope.of(context).unfocus();

    _isEditingNickname.value = false;
  }

  void _enableEditing() {
    _isEditingNickname.value = true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (p, c) => p.nickname != c.nickname,
      builder: (context, authState) {
        final nickname = authState.nickname ?? '';

        return ValueListenableBuilder<bool>(
          valueListenable: _isEditingNickname,
          builder: (context, isEditing, _) {
            if (!isEditing) {
              _nicknameController.text = nickname;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'NICK NAME',
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 14,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white24, width: 0.5),

                    color: Colors.transparent,
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            isEditing ? 40 : 14,
                          ),
                          border: Border.all(color: Colors.white24, width: 0.5),
                          gradient: isEditing
                              ? const LinearGradient(
                                  colors: [
                                    Color(0xFF2E2E2E),
                                    Color(0xFF3A3A3A),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                )
                              : null,
                          color: isEditing ? null : Colors.transparent,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: isEditing
                                  ? TextField(
                                      controller: _nicknameController,
                                      autofocus: true,
                                      style: const TextStyle(
                                        color: AppColors.whiteColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        isCollapsed: true,
                                      ),
                                    )
                                  : Text(
                                      nickname.isNotEmpty
                                          ? nickname
                                          : 'Not set',
                                      style: const TextStyle(
                                        color: AppColors.whiteColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                            const SizedBox(width: 8),

                            GestureDetector(
                              onTap: _enableEditing,
                              child: Container(
                                height: 36,
                                width: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),

                                  border: isEditing
                                      ? null
                                      : Border.all(color: Colors.white24),
                                ),
                                child: Center(
                                  child: isEditing
                                      ? SvgPicture.asset(
                                          AppAssets.verified,
                                          width: 20,
                                          height: 20,
                                        )
                                      : SvgPicture.asset(
                                          AppAssets.edit,
                                          width: 16,
                                          height: 16,
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      if (isEditing) ...[
                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: PrimaryButton(
                            isExpanded: false,
                            title: "Save",
                            isEnabled: true,
                            onPressed: () {
                              _saveNickname(context);
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
