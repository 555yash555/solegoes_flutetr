import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String? label;  // NEW: Optional label above field
  final IconData? icon;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;  // NEW: For search bars
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final int? maxLines;  // NEW: For multi-line fields (bio, etc)
  final String? textPrefix;  // NEW: For @username style prefixes

  const AppTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.label,
    this.icon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.inputFormatters,
    this.readOnly = false,
    this.onTap,
    this.focusNode,
    this.maxLines = 1,
    this.textPrefix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Optional label above field
        if (label != null) ...[
          Text(
            label!,
            style: AppTextStyles.label.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceOverlay,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: errorText != null 
                  ? AppColors.error 
                  : AppColors.borderSubtle,
            ),
          ),
          child: Row(
            crossAxisAlignment: maxLines != null && maxLines! > 1 
                ? CrossAxisAlignment.start 
                : CrossAxisAlignment.center,
            children: [
              // Optional text prefix (e.g., "@" for username)
              if (textPrefix != null)
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    textPrefix!,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  obscureText: obscureText,
                  keyboardType: keyboardType,
                  maxLines: maxLines,
                  minLines: maxLines == 1 ? null : 1,
                  style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
                  onChanged: onChanged,
                  onSubmitted: onSubmitted,
                  inputFormatters: inputFormatters,
                  readOnly: readOnly,
                  onTap: onTap,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      color: AppColors.iconMuted,
                      fontWeight: FontWeight.w500,
                    ),
                    prefixIcon: icon != null 
                        ? Icon(
                            icon,
                            size: 20,
                            color: AppColors.textTertiary,
                          )
                        : null,
                    suffixIcon: suffixIcon != null
                        ? Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: suffixIcon,
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: textPrefix != null ? 4 : 16,
                      vertical: 16,
                    ),
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              errorText!,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
