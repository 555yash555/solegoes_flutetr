import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum AppCardVariant {
  surface, // Opaque surface color (surfaceHover)
  glass,   // Glassmorphism (blur + semi-transparent)
  outline, // Transparent with border
}

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final double? borderRadius;
  final AppCardVariant variant;
  final Color? backgroundColor;
  final Border? border;
  final List<BoxShadow>? boxShadow;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.borderRadius,
    this.variant = AppCardVariant.surface,
    this.backgroundColor,
    this.border,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: _getDecoration(),
      child: child,
    );

    // Apply specific effects based on variant
    if (variant == AppCardVariant.glass) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? AppRadius.lg),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: content,
        ),
      );
    } else {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? AppRadius.lg),
        child: content,
      );
    }

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: content,
      );
    }

    return content;
  }

  BoxDecoration _getDecoration() {
    final radius = borderRadius ?? AppRadius.lg;

    switch (variant) {
      case AppCardVariant.surface:
        return BoxDecoration(
          color: backgroundColor ?? AppColors.surfaceHover,
          borderRadius: BorderRadius.circular(radius),
          border: border ?? Border.all(color: AppColors.borderGlass),
          boxShadow: boxShadow,
        );
      case AppCardVariant.glass:
        return BoxDecoration(
          color: backgroundColor ?? AppColors.surfaceOverlay,
          borderRadius: BorderRadius.circular(radius),
          border: border ?? Border.all(color: AppColors.borderGlass),
          boxShadow: boxShadow,
        );
      case AppCardVariant.outline:
        return BoxDecoration(
          color: backgroundColor ?? Colors.transparent,
          borderRadius: BorderRadius.circular(radius),
          border: border ?? Border.all(color: AppColors.borderSubtle),
          boxShadow: boxShadow,
        );
    }
  }
}
