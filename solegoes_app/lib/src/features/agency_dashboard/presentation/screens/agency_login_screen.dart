import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../theme/app_theme.dart';
import '../../../../common_widgets/app_button.dart';
import '../../../../common_widgets/app_text_field.dart';
import '../../../../common_widgets/app_snackbar.dart';
import '../../../../common_widgets/social_sign_in_button.dart';
import '../../../authentication/data/auth_repository.dart';
import '../../../authentication/presentation/auth_controller.dart';

/// Agency Login Screen — converted from design_mockups/00_agency_login.html
/// Layout: split (hero left, form right) on desktop >900px,
///         stacked (hero top 250px, form below) on mobile.
class AgencyLoginScreen extends ConsumerStatefulWidget {
  const AgencyLoginScreen({super.key});

  @override
  ConsumerState<AgencyLoginScreen> createState() => _AgencyLoginScreenState();
}

class _AgencyLoginScreenState extends ConsumerState<AgencyLoginScreen> {
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

    final user = await ref
        .read(authControllerProvider.notifier)
        .signInWithEmailAndPassword(email: email, password: password);

    if (user == null || !mounted) return;

    if (user.role == 'agency') {
      context.go('/agency-pending');
    } else if (user.role == 'superAdmin') {
      context.go('/admin');
    } else {
      context.go('/agency-signup');
    }
  }

  Future<void> _handleGoogleSignIn() async {
    final user = await ref.read(authControllerProvider.notifier).signInWithGoogle();
    if (user == null || !mounted) return;

    if (user.role == 'agency') {
      context.go('/agency-pending');
    } else if (user.role == 'superAdmin') {
      context.go('/admin');
    } else {
      // 'consumer' or new user
      context.go('/agency-signup');
    }
  }

  Future<void> _showForgotPassword() async {
    final emailCtrl = TextEditingController(text: _emailController.text.trim());
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgSurface,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
        title: Text('Reset Password', style: AppTextStyles.h4),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter your email and we\'ll send you a reset link.',
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: emailCtrl,
              hint: 'Enter your email',
              icon: LucideIcons.mail,
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel',
                style: AppTextStyles.label.copyWith(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () async {
              final email = emailCtrl.text.trim();
              if (email.isEmpty) return;
              Navigator.of(ctx).pop();
              try {
                await ref
                    .read(authRepositoryProvider)
                    .sendPasswordResetEmail(email);
                if (mounted) {
                  AppSnackbar.showSuccess(context, 'Reset email sent to $email');
                }
              } catch (e) {
                if (mounted) {
                  AppSnackbar.showError(context, 'Failed to send reset email');
                }
              }
            },
            child: Text('Send Link',
                style: AppTextStyles.label.copyWith(color: AppColors.primary)),
          ),
        ],
      ),
    );
    emailCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 900) {
              return _buildDesktopLayout(isLoading);
            } else {
              return _buildMobileLayout(isLoading);
            }
          },
        ),
      ),
    );
  }

  // ─── Desktop: split hero (left) + form (right) ───

  Widget _buildDesktopLayout(bool isLoading) {
    return Row(
      children: [
        // Left: Hero section
        Expanded(child: _buildHeroPanel()),
        // Right: Form section (max 600px)
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: _buildFormPanel(isLoading, isDesktop: true),
        ),
      ],
    );
  }

  // ─── Mobile: stacked ───

  Widget _buildMobileLayout(bool isLoading) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeroMobile(),
          _buildFormPanel(isLoading, isDesktop: false),
        ],
      ),
    );
  }

  // ─── Hero Panel (Desktop – full height) ───

  Widget _buildHeroPanel() {
    return Container(
      color: AppColors.bgSurface,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.network(
            'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=1200&q=80',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Container(color: AppColors.bgSurface),
          ),
          // Dark gradient overlay  
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x33090909),
                  Color(0xE6090909),
                ],
                stops: [0.0, 1.0],
              ),
            ),
          ),
          // Logo top-left
          Positioned(
            top: 40,
            left: 40,
            child: _buildLogoRow(),
          ),
          // Hero copy bottom-left
          Positioned(
            bottom: 48,
            left: 48,
            right: 48,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.1,
                    ),
                    children: [
                      const TextSpan(text: 'Scale your\n'),
                      WidgetSpan(
                        child: ShaderMask(
                          shaderCallback: (bounds) =>
                              AppColors.primaryGradient.createShader(bounds),
                          child: const Text(
                            'travel business.',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Manage bookings, publish trips, and grow your revenue\nwith the SoleGoes agency ecosystem.',
                  style: AppTextStyles.body.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Hero Mobile (250px top section) ───

  Widget _buildHeroMobile() {
    return SizedBox(
      height: 250,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800&q=80',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Container(color: AppColors.bgSurface),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x33090909), Color(0xE6090909)],
              ),
            ),
          ),
          Positioned(
            top: 24,
            left: 24,
            child: _buildLogoRow(),
          ),
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.2,
                ),
                children: [
                  const TextSpan(text: 'Scale your '),
                  WidgetSpan(
                    child: ShaderMask(
                      shaderCallback: (bounds) =>
                          AppColors.primaryGradient.createShader(bounds),
                      child: const Text(
                        'travel business.',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
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

  Widget _buildLogoRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: AppRadius.smAll,
          ),
          alignment: Alignment.center,
          child: Text(
            'S',
            style: AppTextStyles.label.copyWith(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text('SoleGoes',
            style: AppTextStyles.h4.copyWith(color: Colors.white)),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.2),
            border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.4)),
            borderRadius: AppRadius.fullAll,
          ),
          child: Text(
            'Agency',
            style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary),
          ),
        ),
      ],
    );
  }

  // ─── Form Panel ───

  Widget _buildFormPanel(bool isLoading, {required bool isDesktop}) {
    return Container(
      color: AppColors.bgDeep,
      child: Stack(
        children: [
          // Back to Traveler App button
          Positioned(
            top: isDesktop ? 40 : 16,
            right: isDesktop ? 40 : 16,
            child: GestureDetector(
              onTap: () => context.go('/login'),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.arrowLeft,
                      size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 6),
                  Text(
                    'Back to Traveler App',
                    style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
          // Form content centered
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 48 : 24,
                vertical: isDesktop ? 80 : 40,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Agency Portal', style: AppTextStyles.h2),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to your agency dashboard',
                      style: AppTextStyles.bodySmall,
                    ),
                    const SizedBox(height: 32),

                    // Email field
                    Text('Email or Phone',
                        style: AppTextStyles.label),
                    const SizedBox(height: 8),
                    AppTextField(
                      controller: _emailController,
                      hint: 'Enter your email',
                      icon: LucideIcons.mail,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),

                    // Password field
                    Text('Password', style: AppTextStyles.label),
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
                    const SizedBox(height: 8),

                    // Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: _showForgotPassword,
                        child: Text(
                          'Forgot Password?',
                          style: AppTextStyles.labelSmall
                              .copyWith(color: AppColors.primary),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Sign In button
                    AppButton(
                      text: 'Sign In',
                      onPressed: _handleLogin,
                      isLoading: isLoading,
                      variant: AppButtonVariant.primary,
                      shape: AppButtonShape.rounded,
                    ),
                    const SizedBox(height: 28),

                    // Divider
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                                height: 1,
                                color: AppColors.borderSubtle)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text('or continue with',
                              style: AppTextStyles.labelSmall
                                  .copyWith(color: AppColors.textHint)),
                        ),
                        Expanded(
                            child: Container(
                                height: 1,
                                color: AppColors.borderSubtle)),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Social buttons
                    Row(
                      children: [
                        Expanded(
                          child: SocialSignInButton(
                            provider: SocialProvider.google,
                            onPressed: _handleGoogleSignIn,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: SocialSignInButton(
                            provider: SocialProvider.apple,
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Apply now link
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Not a SoleGoes partner yet? ',
                            style: AppTextStyles.bodySmall,
                          ),
                          GestureDetector(
                            onTap: () => context.go('/agency-signup'),
                            child: Text(
                              'Apply now',
                              style: AppTextStyles.label.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
