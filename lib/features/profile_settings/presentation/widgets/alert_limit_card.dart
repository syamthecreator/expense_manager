import 'package:expense_manager/core/constants/app_colors.dart';
import 'package:expense_manager/core/utils/helper.dart';
import 'package:expense_manager/core/widgets/primary_button.dart';
import 'package:expense_manager/features/profile_settings/bloc/profile_settings_bloc.dart';
import 'package:expense_manager/features/profile_settings/bloc/profile_settings_event.dart';
import 'package:expense_manager/features/profile_settings/bloc/profile_settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlertLimitCard extends StatefulWidget {
  const AlertLimitCard({super.key});

  @override
  State<AlertLimitCard> createState() => _AlertLimitCardState();
}

class _AlertLimitCardState extends State<AlertLimitCard> {
  final TextEditingController _limitController = TextEditingController();

  @override
  void dispose() {
    _limitController.dispose();
    super.dispose();
  }

  void _setLimit(BuildContext context) {
    final rawText = _limitController.text.replaceAll(',', '');

    final value = double.tryParse(rawText);
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
        const Divider(thickness: 3, height: 3, color: AppColors.greyShade),
        const SizedBox(height: 16),

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
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          Helper.currencyFormatter(),
                        ],
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
                    child: PrimaryButton(
                      isExpanded: false,
                      title: "Set",
                      isEnabled: true,
                      onPressed: () => _setLimit(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              BlocBuilder<ProfileSettingsBloc, ProfileSettingsState>(
                buildWhen: (p, c) => p.data.alertLimit != c.data.alertLimit,
                builder: (context, state) {
                  return Text(
                    'Current Limit: ₹${Helper().formatNumber(state.data.alertLimit)}',
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
