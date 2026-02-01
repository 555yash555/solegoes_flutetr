import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'app_button.dart';

/// A reusable confirmation dialog with consistent styling.
/// Replaces all hand-rolled AlertDialog instances for confirmations.
class AppConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final Color? confirmColor;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;

  const AppConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.confirmColor,
    required this.onConfirm,
    this.onCancel,
    this.isDestructive = false,
  });

  /// Static helper to show the dialog
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color? confirmColor,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AppConfirmDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        confirmColor: confirmColor,
        onConfirm: onConfirm,
        onCancel: onCancel,
        isDestructive: isDestructive,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.bgSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(
          color: AppColors.borderSubtle,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              title,
              style: AppTextStyles.h3.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            
            // Message
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            
            // Actions
            Row(
              children: [
                // Cancel button
                Expanded(
                  child: AppButton(
                    text: cancelText,
                    variant: AppButtonVariant.ghost,
                    size: AppButtonSize.medium,
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      onCancel?.call();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                
                // Confirm button
                Expanded(
                  child: AppButton(
                    text: confirmText,
                    variant: isDestructive 
                        ? AppButtonVariant.destructive 
                        : AppButtonVariant.primary,
                    size: AppButtonSize.medium,
                    textColor: confirmColor,
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      onConfirm();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
