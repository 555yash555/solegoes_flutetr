import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class SocialLoginButton extends StatelessWidget {
  final String text;
  final String svgAsset; // Path to SVG asset OR raw SVG string if handled differently
  // Since we don't have assets yet, I'll allow passing a Widget icon directly for flexibility
  final Widget? icon; 
  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
    required this.text,
    this.svgAsset = '',
    this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          side: const BorderSide(color: Colors.white12), // Subtle border
          backgroundColor: Colors.white.withValues(alpha: 0.03), // Very subtle fill, almost transparent
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) icon!,
            if (icon != null) const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
