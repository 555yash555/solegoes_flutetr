import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../common_widgets/app_image.dart';

class CategoryCard extends StatelessWidget {
  final String category;
  final String imageUrl;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Capitalize category name
    final label = category.isNotEmpty
        ? category[0].toUpperCase() + category.substring(1)
        : category;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.borderGlass),
          boxShadow: AppShadows.md,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Image
              AppImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.zero, // Parent Clips
              ),

              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.scrim.withOpacity(0.0),
                      AppColors.scrim.withOpacity(0.6),
                      AppColors.scrim,
                    ],
                    stops: const [0.0, 0.5, 0.8, 1.0],
                  ),
                ),
              ),

              // Category Name
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        label,
                        style: AppTextStyles.h4.copyWith(color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
