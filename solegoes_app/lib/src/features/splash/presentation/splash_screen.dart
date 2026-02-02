import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_theme.dart';
import '../../../common_widgets/sole_goes_logo.dart';
import '../../authentication/data/auth_repository.dart';
import '../../onboarding/data/onboarding_repository.dart';

/// Splash screen shown while app initializes
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    if (!mounted) return;

    // Check onboarding status
    final onboardingRepoAsync = ref.read(onboardingRepositoryProvider);
    final isOnboardingComplete = onboardingRepoAsync.when(
      data: (repo) => repo.isOnboardingComplete,
      loading: () => false,
      error: (_, __) => true,
    );

    if (!isOnboardingComplete) {
      context.go('/onboarding');
      return;
    }

    // Check auth status
    final authRepository = ref.read(authRepositoryProvider);
    final currentUser = authRepository.currentUser;

    if (currentUser == null) {
      context.go('/login');
      return;
    }

    // User is logged in, check profile completion
    try {
      final user = await authRepository.getUserProfile(currentUser.uid);
      if (!user.isProfileComplete) {
        if (mounted) context.go('/profile-setup');
        return;
      }
      if (!user.isPreferencesComplete) {
        if (mounted) context.go('/preferences');
        return;
      }
      // Profile complete, go to home
      if (mounted) context.go('/');
    } catch (e) {
      // If we can't get user profile, go to profile setup
      if (mounted) context.go('/profile-setup');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            ClipOval(
              child: Image.asset(
                'assets/images/logo_symbol.png',
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),
            // App name
            const SoleGoesLogo(
              fontSize: 32,
              centered: true,
            ),
            const SizedBox(height: 8),
            Text(
              'Solo Travel, Together',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 48),
            // Loading indicator
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
