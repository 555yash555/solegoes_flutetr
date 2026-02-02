import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solegoes_app/src/constants/app_colors.dart';

class SoleGoesLogo extends StatelessWidget {
  final double fontSize;
  final bool centered;

  const SoleGoesLogo({
    super.key,
    this.fontSize = 32,
    this.centered = true,
  });

  @override
  Widget build(BuildContext context) {
    // Define the specific font style for the logo
    final logoStyle = GoogleFonts.outfit(
      fontSize: fontSize,
      fontWeight: FontWeight.w700, // Bold
      height: 1.1,
      letterSpacing: -0.5,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: centered ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        // "Sole" - White
        Text(
          'Sole',
          style: logoStyle.copyWith(
            color: Colors.white,
          ),
        ),
        // "Goes" - Gradient
        ShaderMask(
          shaderCallback: (bounds) {
            return const LinearGradient(
              colors: [
                Color(0xFF3B82F6), // Blue / accentBlue
                Color(0xFF8B5CF6), // Violet
                Color(0xFFEC4899), // Pink (hint of pink at the end)
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcIn,
          child: Text(
            'Goes',
            style: logoStyle.copyWith(
              color: Colors.white, // Color is ignored by ShaderMask but required for text rendering
            ),
          ),
        ),
      ],
    );
  }
}
