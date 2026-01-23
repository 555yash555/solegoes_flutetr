import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A circular icon button with consistent styling used throughout the app.
/// 
/// Common use cases:
/// - Back buttons in navigation
/// - Action buttons (notification, settings, etc.)
/// - Header icon buttons
class CircularIconButton extends StatelessWidget {
  /// The icon to display
  final IconData icon;
  
  /// Callback when button is pressed
  final VoidCallback onPressed;
  
  /// Background color of the button
  /// Defaults to [AppColors.surfaceHover]
  final Color? backgroundColor;
  
  /// Color of the icon
  /// Defaults to [AppColors.textPrimary]
  final Color? iconColor;
  
  /// Size of the circular button
  /// Defaults to 40
  final double size;
  
  /// Size of the icon inside the button
  /// Defaults to 20
  final double iconSize;
  
  /// Border color
  /// Defaults to [AppColors.borderSubtle]
  final Color? borderColor;

  const CircularIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size = 40,
    this.iconSize = 20,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.surfaceHover,
          shape: BoxShape.circle,
          border: Border.all(
            color: borderColor ?? AppColors.borderSubtle,
          ),
        ),
        child: Icon(
          icon,
          size: iconSize,
          color: iconColor ?? AppColors.textPrimary,
        ),
      ),
    );
  }
}
