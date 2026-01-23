import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A bottom-positioned action button with gradient fade overlay.
/// 
/// Features:
/// - Fixed to bottom of screen
/// - Gradient overlay for visual depth
/// - Loading state support
/// - Disabled state support
/// - Safe area padding
/// 
/// Common use cases:
/// - Continue/Next buttons in setup flows
/// - Primary CTAs at bottom of scrollable content
class BottomActionButton extends StatelessWidget {
  /// The button text to display
  final String text;
  
  /// Callback when button is pressed
  final VoidCallback onPressed;
  
  /// Whether the button is in loading state
  final bool isLoading;
  
  /// Whether the button is enabled
  final bool isEnabled;

  const BottomActionButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.bgDeep.withValues(alpha: 0),
            AppColors.bgDeep,
          ],
        ),
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.md,
      ),
      child: GestureDetector(
        onTap: isEnabled && !isLoading ? onPressed : null,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: isEnabled && !isLoading
                ? AppColors.primaryGradient
                : null,
            color: !isEnabled || isLoading
                ? AppColors.surfacePressed
                : null,
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.textPrimary,
                    ),
                  )
                : Text(
                    text,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.button,
                  ),
          ),
        ),
      ),
    );
  }
}
