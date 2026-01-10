import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ActionText extends StatelessWidget {
  final String normalText;
  final String actionText;
  final VoidCallback onActionPressed;
  final double fontSize;
  final Color? normalColor;
  final Color? actionColor;
  final bool underlineAction;

  const ActionText({
    super.key,
    required this.normalText,
    required this.actionText,
    required this.onActionPressed,
    this.fontSize = 14,
    this.normalColor,
    this.actionColor,
    this.underlineAction = false,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(
          fontSize: fontSize,
          color: normalColor ?? AppColors.textSecondary,
          fontFamily: 'Plus Jakarta Sans', // Ensure generic font family works if theme isn't inherited
        ),
        children: [
          TextSpan(text: normalText),
          const TextSpan(text: ' '),
          TextSpan(
            text: actionText,
            style: TextStyle(
              color: actionColor ?? AppColors.primary,
              fontWeight: FontWeight.bold,
              decoration: underlineAction ? TextDecoration.underline : null,
              decorationColor: actionColor ?? AppColors.primary,
            ),
            recognizer: TapGestureRecognizer()..onTap = onActionPressed,
          ),
        ],
      ),
    );
  }
}
