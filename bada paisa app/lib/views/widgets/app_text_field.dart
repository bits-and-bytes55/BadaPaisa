import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/config/theme/app_theme.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.isRequired = false,
    this.hint,
    this.icon,
    this.prefixText,
    this.suffixText,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.maxLength,
    this.textInputAction = TextInputAction.next,
    this.textCapitalization = TextCapitalization.none,
  });

  final String label;
  final TextEditingController controller;
  final bool isRequired;
  final String? hint;
  final IconData? icon;
  final String? prefixText;
  final String? suffixText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final int? maxLength;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    Widget? prefix;
    if (icon != null) {
      prefix = Icon(icon, size: 20, color: AppColors.textSecondary);
    } else if (prefixText != null) {
      prefix = Padding(
        padding: const EdgeInsets.only(left: 16, right: 8),
        child: Text(prefixText!, style: AppTextStyles.bodyDark),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            style: AppTextStyles.label,
            children: [
              if (isRequired)
                TextSpan(
                  text: ' *',
                  style: AppTextStyles.label.copyWith(color: AppColors.error),
                ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          onChanged: onChanged,
          maxLength: maxLength,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: AppTextStyles.bodyDark,
          cursorColor: AppColors.secondary,
          decoration: InputDecoration(
            hintText: hint,
            counterText: '',
            isDense: true,
            prefixIcon: prefix,
            prefixIconConstraints: const BoxConstraints(
              minWidth: 44,
              minHeight: 0,
            ),
            suffixText: suffixText,
            suffixStyle: AppTextStyles.caption,
          ),
        ),
      ],
    );
  }
}
