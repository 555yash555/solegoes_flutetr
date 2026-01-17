import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum AppButtonVariant {
  primary,
  secondary,
  outline,
  text,
}

enum AppButtonShape {
  rounded, // Radius 16
  pill,    // Radius 30 (Full)
}

enum AppButtonSize {
  small,  // Height 40
  medium, // Height 48
  large,  // Height 56
}

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final AppButtonVariant variant;
  final AppButtonShape shape;
  final AppButtonSize size;
  final bool isFullWidth;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.shape = AppButtonShape.rounded,
    this.size = AppButtonSize.large,
    this.isFullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      height: _getHeight(),
      decoration: _getDecoration(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: _getBorderRadius(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(_getTextColor()),
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: 20,
            color: _getTextColor(),
          ),
          const SizedBox(width: 8),
        ],
        Text(
          text,
          textAlign: TextAlign.center,
          style: _getTextStyle().copyWith(
            color: _getTextColor(),
          ),
        ),
      ],
    );
  }

  double _getHeight() {
    switch (size) {
      case AppButtonSize.small:
        return 40;
      case AppButtonSize.medium:
        return 48;
      case AppButtonSize.large:
        return 56;
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case AppButtonSize.small:
        return AppTextStyles.buttonSmall;
      case AppButtonSize.medium:
      case AppButtonSize.large:
        return AppTextStyles.button;
    }
  }

  BorderRadius _getBorderRadius() {
    switch (shape) {
      case AppButtonShape.rounded:
        return BorderRadius.circular(16);
      case AppButtonShape.pill:
        return BorderRadius.circular(30);
    }
  }

  Color _getTextColor() {
    if (onPressed == null) return AppColors.textDisabled;
    
    switch (variant) {
      case AppButtonVariant.primary:
        return Colors.white;
      case AppButtonVariant.secondary:
        return Colors.white;
      case AppButtonVariant.outline:
        return AppColors.textPrimary;
      case AppButtonVariant.text:
        return AppColors.primary;
    }
  }

  BoxDecoration? _getDecoration() {
    if (onPressed == null) {
      return BoxDecoration(
        color: AppColors.surfaceOverlay,
        borderRadius: _getBorderRadius(),
      );
    }

    switch (variant) {
      case AppButtonVariant.primary:
        return BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: _getBorderRadius(),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.2),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        );
      case AppButtonVariant.secondary:
        return BoxDecoration(
          color: AppColors.surfaceHover,
          borderRadius: _getBorderRadius(),
          border: Border.all(color: AppColors.borderSubtle),
        );
      case AppButtonVariant.outline:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: _getBorderRadius(),
          border: Border.all(color: AppColors.borderFocus),
        );
      case AppButtonVariant.text:
        return BoxDecoration(
          borderRadius: _getBorderRadius(),
        );
    }
  }
}
