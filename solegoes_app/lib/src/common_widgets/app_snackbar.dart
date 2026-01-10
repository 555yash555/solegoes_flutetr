import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Snackbar types with different styling
enum SnackbarType { error, success, info }

/// Custom styled snackbar matching app theme.
///
/// Usage:
/// ```dart
/// AppSnackbar.showError(context, 'Something went wrong');
/// AppSnackbar.showSuccess(context, 'Profile updated!');
/// AppSnackbar.showInfo(context, 'New trip available');
/// ```
class AppSnackbar {
  AppSnackbar._();

  /// Show error snackbar (red theme)
  static void showError(BuildContext context, String message) {
    _show(context, message, SnackbarType.error);
  }

  /// Show success snackbar (green theme)
  static void showSuccess(BuildContext context, String message) {
    _show(context, message, SnackbarType.success);
  }

  /// Show info snackbar (primary theme)
  static void showInfo(BuildContext context, String message) {
    _show(context, message, SnackbarType.info);
  }

  /// Internal method to show snackbar
  static void _show(BuildContext context, String message, SnackbarType type) {
    // Hide any existing snackbar first
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: _SnackbarContent(message: message, type: type),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        padding: EdgeInsets.zero,
        duration: const Duration(seconds: 4),
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }
}

/// Internal widget for snackbar content
class _SnackbarContent extends StatelessWidget {
  final String message;
  final SnackbarType type;

  const _SnackbarContent({
    required this.message,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor, width: 1),
      ),
      child: Row(
        children: [
          Icon(_icon, color: _iconColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color get _backgroundColor {
    switch (type) {
      case SnackbarType.error:
        return AppColors.errorBg;
      case SnackbarType.success:
        return AppColors.successBg;
      case SnackbarType.info:
        return AppColors.bgSurface;
    }
  }

  Color get _borderColor {
    switch (type) {
      case SnackbarType.error:
        return AppColors.errorBorder;
      case SnackbarType.success:
        return AppColors.successBorder;
      case SnackbarType.info:
        return AppColors.borderGlass;
    }
  }

  Color get _iconColor {
    switch (type) {
      case SnackbarType.error:
        return AppColors.errorIcon;
      case SnackbarType.success:
        return AppColors.successIcon;
      case SnackbarType.info:
        return AppColors.primary;
    }
  }

  IconData get _icon {
    switch (type) {
      case SnackbarType.error:
        return Icons.error_outline_rounded;
      case SnackbarType.success:
        return Icons.check_circle_outline_rounded;
      case SnackbarType.info:
        return Icons.info_outline_rounded;
    }
  }
}
