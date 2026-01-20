import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../theme/app_theme.dart';
import '../../../common_widgets/app_snackbar.dart';
import '../../../common_widgets/app_button.dart';
import '../../../common_widgets/app_text_field.dart';
import '../../../common_widgets/social_sign_in_button.dart';
import '../data/auth_repository.dart';
import 'auth_controller.dart';

/// Login screen with email/password and social login
/// Reference: designs/option15_login.html
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // Validate inputs
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty) {
      AppSnackbar.showError(context, 'Please enter your email');
      return;
    }

    if (password.isEmpty) {
      AppSnackbar.showError(context, 'Please enter your password');
      return;
    }

    // Call auth controller
    final success = await ref.read(authControllerProvider.notifier).signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (success && mounted) {
      // Check if profile is complete
      final user = await ref.read(authStateChangesProvider.future);
      if (mounted && user != null) {
        if (!user.isProfileComplete) {
          context.go('/profile-setup');
        } else if (!user.isPreferencesComplete) {
          context.go('/preferences');
        } else {
          context.go('/');
        }
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    final user = await ref.read(authControllerProvider.notifier).signInWithGoogle();

    if (user != null && mounted) {
      // Google sign-in doesn't provide phone number, so collect it
      // Check if phone already exists
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
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Column(
        children: [
          // Hero section - 30% of screen
          _buildHeroSection(),
          // Form section - scrollable
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  // Welcome text
                  Text(
                    'Welcome back',
                    style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Sign in to continue',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Email field
                  _buildInputLabel('Email or Phone'),
                  const SizedBox(height: 8),
                  AppTextField(
                    controller: _emailController,
                    hint: 'Enter your email',
                    icon: LucideIcons.mail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),

                  // Password field
                  _buildInputLabel('Password'),
                  const SizedBox(height: 8),
                  AppTextField(
                    controller: _passwordController,
                    hint: 'Enter your password',
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
                  const SizedBox(height: 12),

                  // Forgot password
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        // TODO: Navigate to forgot password
                      },
                      child: Text(
                        'Forgot Password?',
                        style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Sign in button
                  AppButton(
                    text: 'Sign In',
                    onPressed: () => _handleLogin(),
                    isLoading: isLoading,
                    variant: AppButtonVariant.primary,
                    shape: AppButtonShape.rounded,
                  ),
                  const SizedBox(height: 32),

                  // Divider
                  _buildDivider(),
                  const SizedBox(height: 32),

                  // Social buttons
                  Row(
                    children: [
                      Expanded(
                        child: SocialSignInButton(
                          provider: SocialProvider.google,
                          onPressed: () => _handleGoogleSignIn(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SocialSignInButton(
                          provider: SocialProvider.apple,
                          onPressed: () {},
                          // isLoading: false, // Add isLoading if needed
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Sign up link
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary.withValues(alpha: 0.5),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.go('/signup'),
                          child: Text(
                            'Sign Up',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
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
      height: MediaQuery.of(context).size.height * 0.30,
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
              'https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=800&q=80',
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
                  color: AppColors.textPrimary,
                  size: 20,
                ),
              ),
            ),
          ),

          // Title text
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Embark on Your',
                  style: AppTextStyles.heroTitleMedium,
                ),
                ShaderMask(
                  shaderCallback: (bounds) =>
                      AppColors.primaryGradient.createShader(bounds),
                  child: Text(
                    'Next Journey',
                    style: AppTextStyles.heroTitleMedium,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Solo travel, made social ✨',
                  style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary),
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
}
