import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../theme/app_theme.dart';
import '../../authentication/data/auth_repository.dart';
import '../../authentication/presentation/auth_controller.dart';

/// Profile screen with user info and settings links
/// Reference: designs/option15_profile_page.html
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(authStateChangesProvider);

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        bottom: false,
        child: userAsync.when(
          data: (user) => SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              children: [
                // Header
                _buildHeader(context),
                // Profile header with avatar
                _buildProfileHeader(user?.displayName, user?.email),
                // Stats
                _buildStats(context),
                const SizedBox(height: 24),
                // Menu sections
                _buildPersonalInfo(context),
                const SizedBox(height: 24),
                _buildTravelPreferences(context),
                const SizedBox(height: 24),
                _buildAccount(context, ref),
              ],
            ),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (_, __) => const Center(
            child: Text(
              'Failed to load profile',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 40), // Spacer for balance
          const Text(
            'Profile',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          GestureDetector(
            onTap: () => context.push('/settings'),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surfaceHover,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: const Icon(
                LucideIcons.settings,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(String? name, String? email) {
    final displayName = name ?? 'User';
    final initials = displayName.isNotEmpty
        ? displayName.split(' ').map((n) => n.isNotEmpty ? n[0] : '').take(2).join().toUpperCase()
        : 'U';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.surfaceOverlay,
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        children: [
          // Avatar with edit badge
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.bgDeep,
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.borderSubtle,
                      blurRadius: 0,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    // Edit profile photo
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.bgSurface,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.borderGlass),
                    ),
                    child: const Icon(
                      LucideIcons.pencil,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Name
          Text(
            displayName,
            style: const AppTextStyles.h2.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 4),
          // Email
          Text(
            email ?? '',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => context.push('/my-trips'),
              child: _buildStatCard('5', 'Trips'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard('3', 'Upcoming'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceOverlay,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const AppTextStyles.h2.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.textHint,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Personal Information'),
          const SizedBox(height: 12),
          _buildListGroup([
            _buildListItem(
              icon: LucideIcons.mail,
              label: 'Email',
              onTap: () => context.push('/edit-profile'),
            ),
            _buildListItem(
              icon: LucideIcons.phone,
              label: 'Phone',
              onTap: () {},
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildTravelPreferences(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Travel Preferences'),
          const SizedBox(height: 12),
          _buildListGroup([
            _buildListItem(
              icon: LucideIcons.compass,
              label: 'Interests',
              onTap: () => context.push('/preferences'),
            ),
            _buildListItem(
              icon: LucideIcons.wallet,
              label: 'Budget Range',
              onTap: () {},
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildAccount(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Account'),
          const SizedBox(height: 12),
          _buildListGroup([
            _buildListItem(
              icon: LucideIcons.creditCard,
              label: 'Payment Methods',
              onTap: () {},
            ),
            _buildListItem(
              icon: LucideIcons.logOut,
              label: 'Log Out',
              isDestructive: true,
              onTap: () => _showLogoutDialog(context, ref),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.textHint,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildListGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceOverlay,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildListItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? AppColors.accentRose : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.borderSubtle, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: (isDestructive ? AppColors.accentRose : Colors.white)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 20,
                color: color,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyLarge.copyWith(color: color),
              ),
            ),
            if (!isDestructive)
              Icon(
                LucideIcons.chevronRight,
                size: 20,
                color: AppColors.shimmer,
              ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.bgSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Logout',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.textMuted,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Logout',
              style: TextStyle(color: AppColors.accentRose),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await ref.read(authControllerProvider.notifier).signOut();
    }
  }
}
