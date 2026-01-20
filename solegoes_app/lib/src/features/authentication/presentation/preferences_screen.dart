import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/async_value_ui.dart';
import '../../../common_widgets/app_snackbar.dart';
import '../data/auth_repository.dart';
import 'auth_controller.dart';

/// Preferences screen - interests, budget, trip duration
/// Reference: designs/option15_preferences.html
class PreferencesScreen extends ConsumerStatefulWidget {
  const PreferencesScreen({super.key});

  @override
  ConsumerState<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends ConsumerState<PreferencesScreen> {
  final Set<String> _selectedInterests = {};
  String? _selectedBudget;
  String? _selectedStyle;

  final List<String> _interests = [
    'Beach 🏖️',
    'Mountain 🏔️',
    'Heritage 🏛️',
    'Adventure 🎉',
    'Food 🍜',
    'Art 🎨',
    'Music 🎵',
    'Camping 🏕️',
    'Wellness 🧘',
    'Nightlife 🌃',
  ];

  final List<Map<String, dynamic>> _budgetOptions = [
    {'label': 'Under ₹10,000', 'icon': LucideIcons.banknote},
    {'label': '₹10,000 - ₹25,000', 'icon': LucideIcons.coins},
    {'label': '₹25,000+', 'icon': LucideIcons.gem},
  ];

  final List<String> _travelStyles = [
    'Backpacker 🎒',
    'Comfort 🏨',
    'Luxury 👑',
    'Eco 🌿',
  ];

  @override
  void initState() {
    super.initState();
    // Pre-fill from current user if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCurrentUserData();
    });
  }

  Future<void> _loadCurrentUserData() async {
    final user = await ref.read(authStateChangesProvider.future);
    if (user != null && mounted) {
      setState(() {
        _selectedInterests.addAll(user.interests);
        _selectedBudget = user.budgetRange;
        _selectedStyle = user.travelStyle;
      });
    }
  }

  Future<void> _finishSetup() async {
    if (_selectedInterests.length < 3) {
      AppSnackbar.showError(context, 'Please select at least 3 interests');
      return;
    }

    if (_selectedBudget == null) {
      AppSnackbar.showError(context, 'Please select your budget range');
      return;
    }

    if (_selectedStyle == null) {
      AppSnackbar.showError(context, 'Please select your travel style');
      return;
    }

    // Update preferences in Firebase
    final success = await ref.read(authControllerProvider.notifier).updatePreferences(
      interests: _selectedInterests.toList(),
      budgetRange: _selectedBudget!,
      travelStyle: _selectedStyle!,
    );

    if (success && mounted) {
      AppSnackbar.showSuccess(context, 'Profile setup complete!');
      context.go('/');
    }
  }

  void _skipSetup() {
    // Allow skipping but navigate to home
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    // Listen for auth state changes and show errors
    ref.listen(authControllerProvider, (prev, next) {
      next.showSnackbarOnError(context);
    });

    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Column(
        children: [
          // Header
          SafeArea(
            bottom: false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.bgDeep.withValues(alpha: 0.8),
                border: Border(
                  bottom: BorderSide(color: AppColors.borderSubtle),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => context.go('/profile-setup'),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceHover,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.surfacePressed,
                        ),
                      ),
                      child: const Icon(
                        LucideIcons.chevronLeft,
                        color: AppColors.textPrimary,
                        size: 20,
                      ),
                    ),
                  ),
                  Text(
                    'Step 4 of 4',
                    style: AppTextStyles.stepIndicator,
                  ),
                  GestureDetector(
                    onTap: _skipSetup,
                    child: Text(
                      'Skip',
                      style: AppTextStyles.labelLarge.copyWith(color: AppColors.textPrimary.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    'Your Preferences',
                    style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Help us personalize your experience',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Interests Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionTitle('Interests'),
                      Text(
                        'Select at least 3',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.iconMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInterestsPills(),
                  const SizedBox(height: 32),

                  // Budget Section
                  _buildSectionTitle('Budget per Trip'),
                  const SizedBox(height: 12),
                  _buildBudgetOptions(),
                  const SizedBox(height: 32),

                  // Travel Style Section
                  _buildSectionTitle('Travel Style'),
                  const SizedBox(height: 12),
                  _buildStylePills(),
                  const SizedBox(height: 100), // Space for bottom button
                ],
              ),
            ),
          ),
        ],
      ),
      // Fixed bottom button
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
          24,
          16,
          24,
          MediaQuery.of(context).padding.bottom + 16,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              AppColors.bgDeep.withValues(alpha: 0.9),
              AppColors.bgDeep,
            ],
          ),
        ),
        child: GestureDetector(
          onTap: isLoading ? null : () => _finishSetup(),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              gradient: isLoading ? null : AppColors.primaryGradient,
              color: isLoading ? AppColors.primary.withValues(alpha: 0.5) : null,
              borderRadius: BorderRadius.circular(16),
              boxShadow: isLoading
                  ? null
                  : [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: isLoading
                ? Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  )
                : Text(
                    'Finish Setup',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.button,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.textTertiary,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildInterestsPills() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _interests.map((interest) {
        final isSelected = _selectedInterests.contains(interest);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedInterests.remove(interest);
              } else {
                _selectedInterests.add(interest);
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.pillActiveBg
                  : AppColors.surfaceOverlay,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.borderSubtle,
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
              interest,
              style: AppTextStyles.labelLarge.copyWith(color: isSelected
                    ? Colors.white
                    : AppColors.textSecondary),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBudgetOptions() {
    return Column(
      children: _budgetOptions.map((option) {
        final isSelected = _selectedBudget == option['label'];
        return GestureDetector(
          onTap: () {
            setState(() => _selectedBudget = option['label']);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : AppColors.surfaceOverlay,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.borderSubtle,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.surfaceHover,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    option['icon'] as IconData,
                    size: 20,
                    color: isSelected
                        ? Colors.white
                        : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    option['label'] as String,
                    style: AppTextStyles.h5.copyWith(color: AppColors.textPrimary),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStylePills() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _travelStyles.map((style) {
        final isSelected = _selectedStyle == style;
        return GestureDetector(
          onTap: () {
            setState(() => _selectedStyle = style);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.pillActiveBg
                  : AppColors.surfaceOverlay,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.borderSubtle,
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
              style,
              style: AppTextStyles.labelLarge.copyWith(color: isSelected
                    ? Colors.white
                    : AppColors.textSecondary),
            ),
          ),
        );
      }).toList(),
    );
  }
}
