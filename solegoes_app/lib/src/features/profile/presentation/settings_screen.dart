import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../theme/app_theme.dart';
import '../../authentication/presentation/auth_controller.dart';

/// Settings screen with app preferences
/// Reference: designs/option15_settings.html
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _darkModeEnabled = true; // Always dark mode for now

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(context),
              const SizedBox(height: 16),
              // Account section
              _buildAccountSection(context),
              const SizedBox(height: 24),
              // Preferences section
              _buildPreferencesSection(context),
              const SizedBox(height: 24),
              // Support section
              _buildSupportSection(context),
              const SizedBox(height: 24),
              // Version info
              _buildVersionInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surfaceHover,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: const Icon(
                LucideIcons.chevronLeft,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Account'),
          const SizedBox(height: 12),
          _buildListGroup([
            _buildNavItem(
              icon: LucideIcons.user,
              label: 'Edit Profile',
              onTap: () => context.push('/edit-profile'),
            ),
            _buildNavItem(
              icon: LucideIcons.bell,
              label: 'Notifications',
              onTap: () => context.push('/notifications'),
            ),
            _buildNavItem(
              icon: LucideIcons.lock,
              label: 'Privacy & Security',
              onTap: () {
                // TODO: Navigate to privacy settings
              },
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildPreferencesSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Preferences'),
          const SizedBox(height: 12),
          _buildListGroup([
            _buildInfoItem(
              icon: LucideIcons.globe,
              label: 'Language',
              value: 'English',
            ),
            _buildToggleItem(
              icon: LucideIcons.moon,
              label: 'Dark Mode',
              value: _darkModeEnabled,
              onChanged: (value) {
                setState(() {
                  _darkModeEnabled = value;
                });
                // Note: Light mode not implemented yet
              },
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Support'),
          const SizedBox(height: 12),
          _buildListGroup([
            _buildNavItem(
              icon: LucideIcons.helpCircle,
              label: 'Help Center',
              onTap: () {
                // TODO: Navigate to help center
              },
            ),
            _buildDestructiveItem(
              icon: LucideIcons.logOut,
              label: 'Log Out',
              onTap: () => _showLogoutDialog(context),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildVersionInfo() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          'Version 1.0.0 • SoleGoes Inc.',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.iconMuted,
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

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
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
                color: AppColors.surfacePressed,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyLarge.copyWith(color: Colors.white),
              ),
            ),
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

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
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
              color: AppColors.surfacePressed,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodyLarge.copyWith(color: Colors.white),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem({
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
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
              color: AppColors.surfacePressed,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodyLarge.copyWith(color: Colors.white),
            ),
          ),
          // Custom toggle switch
          GestureDetector(
            onTap: () => onChanged(!value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              height: 26,
              decoration: BoxDecoration(
                color: value ? AppColors.primary : AppColors.surfacePressed,
                borderRadius: BorderRadius.circular(13),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.all(3),
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDestructiveItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.accentRose.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 20,
                color: AppColors.accentRose,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyLarge.copyWith(color: AppColors.accentRose),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) async {
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
