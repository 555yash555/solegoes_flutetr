import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';
import 'app_shimmer.dart';

/// A centralized image widget that handles caching, loading (shimmer), and errors.
/// Wraps [CachedNetworkImage] with consistent styling and behavior.
class AppImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? errorWidget;
  final Color? color;
  final BlendMode? colorBlendMode;
  final BoxShape shape;

  const AppImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.errorWidget,
    this.color,
    this.colorBlendMode,
    this.shape = BoxShape.rectangle,
  });

  /// Factory constructor for avatar/circular images
  factory AppImage.avatar({
    required String? imageUrl,
    required String? name,
    double size = 40,
    Color? backgroundColor,
    Color? textColor,
  }) {
    final fallback = _buildInitialsAvatar(name, size, backgroundColor, textColor);
    
    return AppImage(
      imageUrl: imageUrl,
      width: size,
      height: size,
      shape: BoxShape.circle,
      fit: BoxFit.cover,
      errorWidget: fallback,
    );
  }

  static Widget _buildInitialsAvatar(String? name, double size, Color? bgColor, Color? textColor) {
    return _AppAvatarFallback(
      name: name,
      size: size,
      backgroundColor: bgColor,
      textColor: textColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine effective border radius (ignore if circle)
    final effectiveBorderRadius = shape == BoxShape.circle 
        ? null 
        : (borderRadius ?? BorderRadius.zero);
    
    // If URL is null/empty, show error widget immediately
    if (imageUrl == null || imageUrl!.isEmpty) {
      return ClipRRect(
         borderRadius: effectiveBorderRadius ?? BorderRadius.zero,
         child: Container(
           width: width,
           height: height,
           decoration: BoxDecoration(
             borderRadius: effectiveBorderRadius,
             shape: shape,
           ),
           child: errorWidget ?? _buildDefaultErrorPlaceholder(),
         ),
      );
    }

    return ClipRRect(
      borderRadius: effectiveBorderRadius ?? BorderRadius.zero, 
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: effectiveBorderRadius,
          shape: shape,
        ),
        clipBehavior: Clip.antiAlias,
        child: CachedNetworkImage(
          imageUrl: imageUrl!,
          width: width,
          height: height,
          fit: fit,
          color: color,
          colorBlendMode: colorBlendMode,
          placeholder: (context, url) => AppShimmer(
            width: width ?? double.infinity,
            height: height ?? double.infinity,
            shape: shape,
            borderRadius: effectiveBorderRadius?.topLeft.x ?? 0,
          ),
          errorWidget: (context, url, error) => errorWidget ?? _buildDefaultErrorPlaceholder(),
        ),
      ),
    );
  }

  Widget _buildDefaultErrorPlaceholder() {
    return Container(
      color: AppColors.surfaceSelected, // Use a lighter background (15% white)
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.imageOff,
              color: AppColors.textDisabled,
              size: (width != null && width! < 60) ? 16 : 24,
            ),
          ],
        ),
      ),
    );
  }
}

class _AppAvatarFallback extends StatelessWidget {
  final String? name;
  final double size;
  final Color? backgroundColor;
  final Color? textColor;

  const _AppAvatarFallback({
    this.name, 
    required this.size, 
    this.backgroundColor, 
    this.textColor
  });

  @override
  Widget build(BuildContext context) {
    final initial = (name != null && name!.isNotEmpty) ? name![0].toUpperCase() : 'U';
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontSize: size * 0.5,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
