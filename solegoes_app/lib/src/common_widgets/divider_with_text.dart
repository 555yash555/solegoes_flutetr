import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A horizontal divider with centered text.
/// 
/// Features:
/// - Customizable text and style
/// - Horizontal lines on both sides
/// - Commonly used for "or continue with" separators
/// 
/// Common use cases:
/// - Auth screens (login/signup) for social login separator
/// - Any section that needs visual separation with label
class DividerWithText extends StatelessWidget {
  /// The text to display in the center
  final String text;
  
  /// Optional custom text style
  /// Defaults to [AppTextStyles.bodySmall] with [AppColors.textTertiary]
  final TextStyle? textStyle;
  
  /// Color of the divider lines
  /// Defaults to [AppColors.surfacePressed]
  final Color? dividerColor;

  const DividerWithText({
    super.key,
    required this.text,
    this.textStyle,
    this.dividerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: dividerColor ?? AppColors.surfacePressed,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            text,
            style: textStyle ??
                AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: dividerColor ?? AppColors.surfacePressed,
          ),
        ),
      ],
    );
  }
}
