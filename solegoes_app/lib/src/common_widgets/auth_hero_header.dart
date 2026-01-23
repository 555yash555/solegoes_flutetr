import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'circular_icon_button.dart';

/// A hero header section with background image and gradient overlay.
/// 
/// Features:
/// - Background image with rounded bottom corners
/// - Gradient overlay for better text readability
/// - Back button in top-left
/// - Title and subtitle overlay at bottom
/// - Responsive height based on screen size
/// 
/// Common use cases:
/// - Login screen hero
/// - Signup screen hero
/// - Any authentication flow headers
class AuthHeroHeader extends StatelessWidget {
  /// URL of the background image
  final String imageUrl;
  
  /// Main title text
  final String title;
  
  /// Optional subtitle text
  final String? subtitle;
  
  /// Callback when back button is pressed
  final VoidCallback onBack;
  
  /// Optional second line of title (with gradient effect)
  final String? titleSecondLine;
  
  /// Whether to apply gradient effect to second line
  final bool gradientOnSecondLine;
  
  /// Height factor (multiplied by screen height)
  /// Defaults to 0.30 (30% of screen height)
  final double heightFactor;

  const AuthHeroHeader({
    super.key,
    required this.imageUrl,
    required this.title,
    this.subtitle,
    required this.onBack,
    this.titleSecondLine,
    this.gradientOnSecondLine = true,
    this.heightFactor = 0.30,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * heightFactor,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(color: AppColors.bgSurface);
              },
            ),
          ),
          
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.bgDeep.withValues(alpha: 0.2),
                  AppColors.bgDeep.withValues(alpha: 0.6),
                  AppColors.bgDeep,
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
          ),
          
          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            child: CircularIconButton(
              icon: LucideIcons.chevronLeft,
              onPressed: onBack,
              backgroundColor: AppColors.surfaceHover,
              borderColor: AppColors.surfacePressed,
            ),
          ),
          
          // Title overlay
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.heroTitleMedium,
                ),
                if (titleSecondLine != null) ...[
                  if (gradientOnSecondLine)
                    ShaderMask(
                      shaderCallback: (bounds) =>
                          AppColors.primaryGradient.createShader(bounds),
                      child: Text(
                        titleSecondLine!,
                        style: AppTextStyles.heroTitleMedium,
                      ),
                    )
                  else
                    Text(
                      titleSecondLine!,
                      style: AppTextStyles.heroTitleMedium,
                    ),
                ],
                if (subtitle != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    subtitle!,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
