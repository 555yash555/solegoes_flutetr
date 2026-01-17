import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/async_value_ui.dart';
import '../../../common_widgets/app_snackbar.dart';
import 'auth_controller.dart';

/// Signup screen with email/password, Google signup, and phone number collection
/// Reference: designs/option15_login.html (adapted for signup)
class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    // Validate inputs
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty) {
      AppSnackbar.showError(context, 'Please enter your full name');
      return;
    }

    if (email.isEmpty) {
      AppSnackbar.showError(context, 'Please enter your email');
      return;
    }

    if (password.isEmpty) {
      AppSnackbar.showError(context, 'Please enter a password');
      return;
    }

    if (password.length < 6) {
      AppSnackbar.showError(context, 'Password must be at least 6 characters');
      return;
    }

    if (password != confirmPassword) {
      AppSnackbar.showError(context, 'Passwords do not match');
      return;
    }

    if (!_agreeToTerms) {
      AppSnackbar.showError(context, 'Please agree to the Terms of Service');
      return;
    }

    // Format phone number with country code
    final phoneNumber = phone.isNotEmpty ? '+91$phone' : null;

    // Call auth controller
    final success = await ref.read(authControllerProvider.notifier).createUserWithEmailAndPassword(
      email: email,
      password: password,
      displayName: name,
      phoneNumber: phoneNumber,
    );

    if (success && mounted) {
      context.go('/profile-setup');
    }
  }

  Future<void> _handleGoogleSignup() async {
    final user = await ref.read(authControllerProvider.notifier).signInWithGoogle();

    if (user != null && mounted) {
      // Google sign-in doesn't provide phone number, so collect it
      if (user.phoneNumber == null || user.phoneNumber!.isEmpty) {
        context.go('/phone-collection');
      } else if (!user.isProfileComplete) {
        context.go('/profile-setup');
      } else if (!user.isPreferencesComplete) {
        context.go('/preferences');
      } else {
        context.go('/');
      }
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
          // Hero section - 25% of screen (smaller for signup since more fields)
          _buildHeroSection(),
          // Form section - scrollable
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  // Welcome text
                  const Text(
                    'Create Account',
                    style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Join the community of solo travelers',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textPrimary.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Full Name field
                  _buildInputLabel('Full Name'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _nameController,
                    hint: 'Enter your full name',
                    icon: LucideIcons.user,
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 16),

                  // Email field
                  _buildInputLabel('Email'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _emailController,
                    hint: 'Enter your email',
                    icon: LucideIcons.mail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  // Phone field
                  _buildInputLabel('Phone Number'),
                  const SizedBox(height: 8),
                  _buildPhoneField(),
                  const SizedBox(height: 16),

                  // Password field
                  _buildInputLabel('Password'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _passwordController,
                    hint: 'Create a password',
                    icon: LucideIcons.lock,
                    obscureText: _obscurePassword,
                    suffixIcon: GestureDetector(
                      onTap: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                      child: Icon(
                        _obscurePassword
                            ? LucideIcons.eyeOff
                            : LucideIcons.eye,
                        size: 20,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Confirm Password field
                  _buildInputLabel('Confirm Password'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _confirmPasswordController,
                    hint: 'Confirm your password',
                    icon: LucideIcons.shieldCheck,
                    obscureText: _obscureConfirmPassword,
                    suffixIcon: GestureDetector(
                      onTap: () => setState(
                          () => _obscureConfirmPassword = !_obscureConfirmPassword),
                      child: Icon(
                        _obscureConfirmPassword
                            ? LucideIcons.eyeOff
                            : LucideIcons.eye,
                        size: 20,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Terms checkbox
                  _buildTermsCheckbox(),
                  const SizedBox(height: 24),

                  // Sign up button
                  _buildPrimaryButton(
                    label: 'Create Account',
                    onTap: isLoading ? null : () => _handleSignup(),
                    isLoading: isLoading,
                  ),
                  const SizedBox(height: 24),

                  // Divider
                  _buildDivider(),
                  const SizedBox(height: 24),

                  // Social buttons
                  Row(
                    children: [
                      Expanded(child: _buildSocialButton(isGoogle: true)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildSocialButton(isGoogle: false)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Sign in link
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary.withValues(alpha: 0.5),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.go('/login'),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.22,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            child: Image.network(
              'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=800&q=80',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(color: AppColors.bgSurface);
              },
            ),
          ),

          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.bgDeep.withValues(alpha: 0.2),
                  AppColors.bgDeep.withValues(alpha: 0.6),
                  AppColors.bgDeep,
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
          ),

          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            child: GestureDetector(
              onTap: () => context.go('/onboarding'),
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
          ),

          // Title text
          Positioned(
            bottom: 16,
            left: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Start Your',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                ShaderMask(
                  shaderCallback: (bounds) =>
                      AppColors.primaryGradient.createShader(bounds),
                  child: const Text(
                    'Adventure',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: AppTextStyles.labelLarge.copyWith(color: AppColors.textPrimary),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceOverlay,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: AppColors.iconMuted,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(
            icon,
            size: 20,
            color: AppColors.textTertiary,
          ),
          suffixIcon: suffixIcon != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: suffixIcon,
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: AppColors.borderSubtle),
              ),
            ),
            child: Row(
              children: [
                const Text(
                  '🇮🇳',
                  style: AppTextStyles.h4,
                ),
                const SizedBox(width: 8),
                Text(
                  '+91',
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
          // Phone input
          Expanded(
            child: TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Enter phone number',
                hintStyle: TextStyle(
                  color: AppColors.iconMuted,
                  fontWeight: FontWeight.w500,
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

  Widget _buildTermsCheckbox() {
    return GestureDetector(
      onTap: () => setState(() => _agreeToTerms = !_agreeToTerms),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: _agreeToTerms
                  ? AppColors.primary
                  : AppColors.surfaceOverlay,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: _agreeToTerms ? AppColors.primary : AppColors.borderSubtle,
              ),
            ),
            child: _agreeToTerms
                ? const Icon(
                    LucideIcons.check,
                    size: 14,
                    color: Colors.white,
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.labelMedium.copyWith(color: AppColors.textPrimary.withValues(alpha: 0.6),
                  height: 1.4,
                ),
                children: const [
                  TextSpan(text: 'I agree to the '),
                  TextSpan(
                    text: 'Terms of Service',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton({
    required String label,
    required VoidCallback? onTap,
    bool isLoading = false,
  }) {
    return GestureDetector(
      onTap: onTap,
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
            : Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.surfacePressed,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or continue with',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
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

  Widget _buildSocialButton({required bool isGoogle}) {
    return GestureDetector(
      onTap: isGoogle ? () => _handleGoogleSignup() : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surfaceOverlay,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isGoogle)
              // Google icon
              SizedBox(
                width: 20,
                height: 20,
                child: CustomPaint(
                  painter: _GoogleLogoPainter(),
                ),
              )
            else
              // Apple icon
              const Icon(
                LucideIcons.apple,
                size: 20,
                color: Colors.white,
              ),
            const SizedBox(width: 12),
            Text(
              isGoogle ? 'Google' : 'Apple',
              style: AppTextStyles.h5.copyWith(color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter for Google logo
class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Blue
    final bluePaint = Paint()..color = const Color(0xFF4285F4);
    canvas.drawArc(
      Rect.fromLTWH(0, 0, w, h),
      -0.5,
      1.5,
      true,
      bluePaint,
    );

    // Green
    final greenPaint = Paint()..color = const Color(0xFF34A853);
    canvas.drawArc(
      Rect.fromLTWH(0, 0, w, h),
      1.0,
      1.2,
      true,
      greenPaint,
    );

    // Yellow
    final yellowPaint = Paint()..color = const Color(0xFFFBBC05);
    canvas.drawArc(
      Rect.fromLTWH(0, 0, w, h),
      2.2,
      1.0,
      true,
      yellowPaint,
    );

    // Red
    final redPaint = Paint()..color = const Color(0xFFEA4335);
    canvas.drawArc(
      Rect.fromLTWH(0, 0, w, h),
      3.2,
      0.9,
      true,
      redPaint,
    );

    // White center
    final whitePaint = Paint()..color = Colors.white;
    canvas.drawCircle(
      Offset(w / 2, h / 2),
      w * 0.35,
      whitePaint,
    );

    // Blue bar
    canvas.drawRect(
      Rect.fromLTWH(w * 0.5, h * 0.35, w * 0.5, h * 0.3),
      bluePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
