import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A selectable pill widget used for multi-select interfaces.
/// 
/// Features:
/// - Visual feedback for selected/unselected states
/// - Smooth transitions
/// - Shadow effect when selected
/// - Consistent with app design system
/// 
/// Common use cases:
/// - Interest selection (preferences screen)
/// - Personality traits selection (profile setup)
/// - Tag/category selection
class SelectablePill extends StatelessWidget {
  /// The text label to display
  final String label;
  
  /// Whether this pill is currently selected
  final bool isSelected;
  
  /// Callback when selection state changes
  final ValueChanged<bool> onChanged;

  const SelectablePill({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!isSelected),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.pillActiveBg : AppColors.surfaceOverlay,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderSubtle,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    blurRadius: 15,
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: AppTextStyles.labelLarge.copyWith(
            color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
