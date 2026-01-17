import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/async_value_ui.dart';
import '../../../common_widgets/app_snackbar.dart';
import '../data/auth_repository.dart';
import 'auth_controller.dart';

/// Profile setup screen - photo, name, bio, age
/// Reference: designs/option15_profile_setup.html
class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _bioController = TextEditingController();
  final _cityController = TextEditingController();
  String? _selectedGender;
  DateTime? _birthDate;
  final Set<String> _selectedTraits = {};

  final List<String> _traits = [
    'Outdoorsy 🌲',
    'Foodie 🍜',
    'Artsy 🎨',
    'Party 🪩',
    'Chill 😌',
    'Active 🏃',
  ];

  @override
  void initState() {
    super.initState();
    // Pre-fill name from current user if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCurrentUserData();
    });
  }

  Future<void> _loadCurrentUserData() async {
    final user = await ref.read(authStateChangesProvider.future);
    if (user != null && mounted) {
      setState(() {
        if (user.bio != null) {
          _bioController.text = user.bio!;
        }
        if (user.city != null) {
          _cityController.text = user.city!;
        }
        _selectedGender = user.gender;
        _birthDate = user.birthDate;
        _selectedTraits.addAll(user.personalityTraits);
      });
    }
  }

  @override
  void dispose() {
    _bioController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _skipToHome() {
    // Just go to home - next app open will show these screens again
    context.go('/');
  }

  Future<void> _handleContinue() async {
    final bio = _bioController.text.trim();
    final city = _cityController.text.trim();

    if (_birthDate == null) {
      AppSnackbar.showError(context, 'Please select your birth date');
      return;
    }

    if (_selectedGender == null) {
      AppSnackbar.showError(context, 'Please select your gender');
      return;
    }

    if (city.isEmpty) {
      AppSnackbar.showError(context, 'Please enter your city');
      return;
    }

    // Update profile in Firebase
    final success = await ref.read(authControllerProvider.notifier).updateProfile(
      bio: bio.isNotEmpty ? bio : null,
      city: city,
      gender: _selectedGender,
      birthDate: _birthDate,
      personalityTraits: _selectedTraits.toList(),
    );

    if (success && mounted) {
      context.go('/preferences');
    }
  }

  void _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              surface: AppColors.bgSurface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      setState(() => _birthDate = date);
    }
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
                    onTap: () => context.go('/otp'),
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
                  Text(
                    'Step 3 of 4',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary.withValues(alpha: 0.6),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _skipToHome(),
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
                  Center(
                    child: Text(
                      'Complete Your Profile',
                      style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Let others get to know the real you',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Photo upload
                  Center(child: _buildPhotoUpload()),
                  const SizedBox(height: 32),

                  // Basic Info Section
                  _buildSectionHeader('Basic Info'),
                  const SizedBox(height: 20),

                  // Birth Date & Gender
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Birth Date', required: true),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: _selectDate,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceOverlay,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.borderSubtle),
                                ),
                                child: Text(
                                  _birthDate != null
                                      ? '${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}'
                                      : 'Select',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: _birthDate != null
                                        ? AppColors.textPrimary
                                        : AppColors.iconMuted,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Gender', required: true),
                            const SizedBox(height: 8),
                            _buildDropdown(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // City
                  _buildLabel('City', required: true),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _cityController,
                    hint: 'Where are you based?',
                    prefixIcon: LucideIcons.mapPin,
                  ),
                  const SizedBox(height: 32),

                  // Personality Section
                  _buildSectionHeader('Personality'),
                  const SizedBox(height: 20),

                  // Traits
                  _buildLabel('Traits'),
                  const SizedBox(height: 12),
                  _buildTraitsPills(),
                  const SizedBox(height: 20),

                  // Bio
                  _buildLabel('Bio'),
                  const SizedBox(height: 8),
                  _buildTextArea(),
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
          onTap: isLoading ? null : () => _handleContinue(),
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
                    'Continue',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoUpload() {
    return GestureDetector(
      onTap: () {
        // TODO: Pick image
      },
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.surfaceOverlay,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.borderGlass,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shimmer,
              blurRadius: 20,
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Icon(
                LucideIcons.user,
                size: 48,
                color: AppColors.iconMuted,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.bgDeep,
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.iconMuted,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  LucideIcons.camera,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.surfacePressed,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textHint,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.surfacePressed,
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text, {bool required = false}) {
    return Row(
      children: [
        Text(
          text,
          style: AppTextStyles.labelLarge.copyWith(color: AppColors.textPrimary),
        ),
        if (required)
          Text(
            ' *',
            style: AppTextStyles.labelLarge.copyWith(color: AppColors.accentRose),
          ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    IconData? prefixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceOverlay,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: TextField(
        controller: controller,
        style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: AppColors.iconMuted,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: prefixIcon != null
              ? Icon(
                  prefixIcon,
                  size: 20,
                  color: AppColors.iconMuted,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceOverlay,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedGender,
          hint: Text(
            'Select',
            style: TextStyle(
              color: AppColors.iconMuted,
              fontSize: 15,
            ),
          ),
          icon: Icon(
            LucideIcons.chevronDown,
            size: 16,
            color: AppColors.iconMuted,
          ),
          dropdownColor: AppColors.bgSurface,
          isExpanded: true,
          style: const TextStyle(
            fontSize: 15,
            color: AppColors.textPrimary,
          ),
          items: ['Male', 'Female', 'Other'].map((gender) {
            return DropdownMenuItem(
              value: gender,
              child: Text(gender),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => _selectedGender = value);
          },
        ),
      ),
    );
  }

  Widget _buildTraitsPills() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _traits.map((trait) {
        final isSelected = _selectedTraits.contains(trait);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedTraits.remove(trait);
              } else {
                _selectedTraits.add(trait);
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
              trait,
              style: AppTextStyles.labelLarge.copyWith(color: isSelected
                    ? Colors.white
                    : AppColors.textSecondary),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTextArea() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceOverlay,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: TextField(
        controller: _bioController,
        maxLines: 5,
        style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: 'Tell us a bit about yourself...',
          hintStyle: TextStyle(
            color: AppColors.iconMuted,
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}
