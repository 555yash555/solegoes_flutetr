import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../app_shimmer.dart';

class TripCardSkeleton extends StatelessWidget {
  const TripCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceOverlay,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          const AppShimmer(
            width: double.infinity,
            height: 140,
            borderRadius: 0,
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                const AppShimmer(width: 150, height: 20),
                const SizedBox(height: 4),
                
                // Details
                const AppShimmer(width: 120, height: 12),
                const SizedBox(height: 8),
                
                // Price and Arrow
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    AppShimmer(width: 80, height: 24),
                    AppShimmer(width: 28, height: 28, borderRadius: 14),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
