import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';

enum SocialProvider { google, apple }

class SocialSignInButton extends StatelessWidget {
  final SocialProvider provider;
  final VoidCallback? onPressed;
  final bool isLoading;

  const SocialSignInButton({
    super.key,
    required this.provider,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surfaceOverlay,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            else if (provider == SocialProvider.google)
              SizedBox(
                width: 20,
                height: 20,
                child: CustomPaint(
                  painter: _GoogleLogoPainter(),
                ),
              )
            else
              const Icon(
                LucideIcons.apple,
                size: 20,
                color: Colors.white,
              ),
            const SizedBox(width: 12),
            Text(
              provider == SocialProvider.google ? 'Google' : 'Apple',
              style: AppTextStyles.h5.copyWith(color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter for Google logo
class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Blue
    final bluePaint = Paint()..color = const Color(0xFF4285F4);
    canvas.drawArc(
      Rect.fromLTWH(0, 0, w, h),
      -0.5,
      1.5,
      true,
      bluePaint,
    );

    // Green
    final greenPaint = Paint()..color = const Color(0xFF34A853);
    canvas.drawArc(
      Rect.fromLTWH(0, 0, w, h),
      1.0,
      1.2,
      true,
      greenPaint,
    );

    // Yellow
    final yellowPaint = Paint()..color = const Color(0xFFFBBC05);
    canvas.drawArc(
      Rect.fromLTWH(0, 0, w, h),
      2.2,
      1.0,
      true,
      yellowPaint,
    );

    // Red
    final redPaint = Paint()..color = const Color(0xFFEA4335);
    canvas.drawArc(
      Rect.fromLTWH(0, 0, w, h),
      3.2,
      0.9,
      true,
      redPaint,
    );

    // White center
    final whitePaint = Paint()..color = Colors.white;
    canvas.drawCircle(
      Offset(w / 2, h / 2),
      w * 0.35,
      whitePaint,
    );

    // Blue bar
    canvas.drawRect(
      Rect.fromLTWH(w * 0.5, h * 0.35, w * 0.5, h * 0.3),
      bluePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
