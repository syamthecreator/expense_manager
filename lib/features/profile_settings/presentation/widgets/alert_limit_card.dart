import 'package:expense_manager/core/constants/app_colors.dart';
import 'package:expense_manager/features/auth/bloc/auth_bloc.dart';
import 'package:expense_manager/features/auth/bloc/auth_event.dart';
import 'package:expense_manager/features/auth/bloc/auth_state.dart';
import 'package:expense_manager/features/profile_settings/bloc/profile_settings_bloc.dart';
import 'package:expense_manager/features/profile_settings/bloc/profile_settings_event.dart';
import 'package:expense_manager/features/profile_settings/bloc/profile_settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlertLimitCard extends StatefulWidget {
  const AlertLimitCard({super.key});

  @override
  State<AlertLimitCard> createState() => _AlertLimitCardState();
}

class _AlertLimitCardState extends State<AlertLimitCard> {
  final TextEditingController _limitController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final ValueNotifier<bool> _isEditingNickname = ValueNotifier(false);

  @override
  void dispose() {
    _limitController.dispose();
    _nicknameController.dispose();
    _isEditingNickname.dispose();
    super.dispose();
  }

  void _onNicknameAction(BuildContext context) {
    if (_isEditingNickname.value) {
      final newName = _nicknameController.text.trim();
      if (newName.isEmpty) return;

      // Save nickname
      context.read<AuthBloc>().add(UpdateNickname(newName));
      FocusScope.of(context).unfocus();
    }

    // Toggle edit mode
    _isEditingNickname.value = !_isEditingNickname.value;
  }

  void _setLimit(BuildContext context) {
    final value = double.tryParse(_limitController.text);
    if (value == null || value <= 0) return;

    context.read<ProfileSettingsBloc>().add(UpdateAlertLimit(value));
    _limitController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'NICKNAME',
          style: TextStyle(
            color: AppColors.whiteColor,
            fontSize: 14,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),

        // Nickname (View / Edit)
        BlocBuilder<AuthBloc, AuthState>(
          buildWhen: (p, c) => p.nickname != c.nickname,
          builder: (context, authState) {
            final nickname = authState.nickname ?? '';

            return ValueListenableBuilder<bool>(
              valueListenable: _isEditingNickname,
              builder: (context, isEditing, _) {
                if (!isEditing) {
                  _nicknameController.text = nickname;
                }

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white24, width: 0.5),
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
                                nickname.isNotEmpty ? nickname : 'Not set',
                                style: const TextStyle(
                                  color: AppColors.whiteColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _onNicknameAction(context),
                        child: Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Icon(
                            isEditing ? Icons.check : Icons.edit_outlined,
                            color: isEditing
                                ? AppColors.greenColour
                                : Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),

        const SizedBox(height: 16),
        const Divider(thickness: 3, height: 3, color: AppColors.greyShade),
        const SizedBox(height: 16),

        // Alert limit
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white24, width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ALERT LIMIT (₹)',
                style: TextStyle(color: AppColors.whiteColor, fontSize: 14),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2C),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _limitController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Amount (₹)',
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => _setLimit(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.kPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Set',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              BlocBuilder<ProfileSettingsBloc, ProfileSettingsState>(
                buildWhen: (p, c) => p.data.alertLimit != c.data.alertLimit,
                builder: (context, state) {
                  return Text(
                    'Current Limit: ₹${state.data.alertLimit.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 14,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
