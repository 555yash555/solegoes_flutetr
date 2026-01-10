import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.obscureText = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05), // Glassmorphic background
        borderRadius: BorderRadius.circular(20), // Larger radius (16-20px requested)
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)), // Subtle border
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white30), // Match CSS input-field::placeholder
          prefixIcon: prefixIcon != null 
              ? Icon(prefixIcon, color: AppColors.textTertiary) 
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, 
            vertical: 16
          ),
        ),
      ),
    );
  }
}
