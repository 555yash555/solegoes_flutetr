import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/async_value_ui.dart';
import '../../../common_widgets/app_snackbar.dart';
import 'auth_controller.dart';

/// Phone number collection screen - shown after Google/Apple signup
/// since social logins don't provide phone numbers
class PhoneCollectionScreen extends ConsumerStatefulWidget {
  const PhoneCollectionScreen({super.key});

  @override
  ConsumerState<PhoneCollectionScreen> createState() => _PhoneCollectionScreenState();
}

class _PhoneCollectionScreenState extends ConsumerState<PhoneCollectionScreen> {
  final _phoneController = TextEditingController();
  String _selectedCountryCode = '+91';
  String _selectedFlag = '🇮🇳';

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleContinue() async {
    final phone = _phoneController.text.trim();

    if (phone.isEmpty) {
      AppSnackbar.showError(context, 'Please enter your phone number');
      return;
    }

    if (phone.length < 10) {
      AppSnackbar.showError(context, 'Please enter a valid phone number');
      return;
    }

    // Format phone number with country code
    final phoneNumber = '$_selectedCountryCode$phone';

    // Update phone number in Firebase
    final success = await ref.read(authControllerProvider.notifier).updatePhoneNumber(phoneNumber);

    if (success && mounted) {
      context.go('/profile-setup');
    }
  }

  void _handleSkip() {
    // Allow skipping but navigate to profile setup
    context.go('/profile-setup');
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with skip button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
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
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _handleSkip,
                    child: Text(
                      'Skip',
                      style: AppTextStyles.labelLarge.copyWith(color: AppColors.textPrimary.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),

              // Icon
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  LucideIcons.phone,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(height: 32),

              // Title
              const Text(
                'Add Phone Number',
                style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                'We\'ll use this to send you trip updates and connect you with your travel squad.',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: AppColors.textPrimary.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 40),

              // Phone field
              const Text(
                'Phone Number',
                style: AppTextStyles.labelLarge.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: 12),
              _buildPhoneField(),
              const SizedBox(height: 16),

              // Info text
              Row(
                children: [
                  Icon(
                    LucideIcons.shieldCheck,
                    size: 16,
                    color: AppColors.accentGreen.withValues(alpha: 0.8),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Your number is private and only shared with trip hosts',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textPrimary.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Continue button
              GestureDetector(
                onTap: isLoading ? null : () => _handleContinue(),
                child: Container(
                  width: double.infinity,
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
                      ? const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              LucideIcons.arrowRight,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceOverlay,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        children: [
          // Country code dropdown
          GestureDetector(
            onTap: _showCountryPicker,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: AppColors.borderSubtle),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    _selectedFlag,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _selectedCountryCode,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    LucideIcons.chevronDown,
                    size: 16,
                    color: AppColors.textTertiary,
                  ),
                ],
              ),
            ),
          ),
          // Phone input
          Expanded(
            child: TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
                letterSpacing: 1,
              ),
              decoration: InputDecoration(
                hintText: '98765 43210',
                hintStyle: TextStyle(
                  color: AppColors.iconMuted,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _CountryPickerSheet(
        onSelect: (code, flag) {
          setState(() {
            _selectedCountryCode = code;
            _selectedFlag = flag;
          });
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _CountryPickerSheet extends StatelessWidget {
  final Function(String code, String flag) onSelect;

  const _CountryPickerSheet({required this.onSelect});

  static const _countries = [
    {'code': '+91', 'flag': '🇮🇳', 'name': 'India'},
    {'code': '+1', 'flag': '🇺🇸', 'name': 'United States'},
    {'code': '+44', 'flag': '🇬🇧', 'name': 'United Kingdom'},
    {'code': '+61', 'flag': '🇦🇺', 'name': 'Australia'},
    {'code': '+971', 'flag': '🇦🇪', 'name': 'UAE'},
    {'code': '+65', 'flag': '🇸🇬', 'name': 'Singapore'},
    {'code': '+60', 'flag': '🇲🇾', 'name': 'Malaysia'},
    {'code': '+66', 'flag': '🇹🇭', 'name': 'Thailand'},
    {'code': '+81', 'flag': '🇯🇵', 'name': 'Japan'},
    {'code': '+49', 'flag': '🇩🇪', 'name': 'Germany'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.shimmer,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Select Country',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _countries.length,
              itemBuilder: (context, index) {
                final country = _countries[index];
                return GestureDetector(
                  onTap: () => onSelect(country['code']!, country['flag']!),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceOverlay,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: Row(
                      children: [
                        Text(
                          country['flag']!,
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            country['name']!,
                            style: const AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary),
                          ),
                        ),
                        Text(
                          country['code']!,
                          style: AppTextStyles.labelLarge.copyWith(color: AppColors.textPrimary.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
