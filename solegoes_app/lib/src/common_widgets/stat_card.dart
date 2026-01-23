import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A card displaying a statistic with a value and label.
/// 
/// Features:
/// - Consistent card styling
/// - Large value with small uppercase label
/// - Used for displaying metrics and stats
/// 
/// Common use cases:
/// - Profile stats (trips completed, upcoming trips)
/// - Trip detail quick stats (rating, spots left, difficulty)
class StatCard extends StatelessWidget {
  /// The main value to display (e.g., "15", "4.8", "Advanced")
  final String value;
  
  /// The label describing the stat (e.g., "TRIPS", "RATING")
  final String label;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceOverlay,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: AppTextStyles.h2,
          ),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            style: AppTextStyles.statLabel,
          ),
        ],
      ),
    );
  }
}
