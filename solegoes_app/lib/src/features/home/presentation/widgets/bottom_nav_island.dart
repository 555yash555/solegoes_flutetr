import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../theme/app_theme.dart';

/// Floating bottom navigation island with FAB center button
/// Reference: designs/option15_mobile.html
class BottomNavIsland extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const BottomNavIsland({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    final currentIndex = navigationShell.currentIndex;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF18181B).withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(AppRadius.full),
            border: Border.all(color: AppColors.borderGlass),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 25,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Home
                  _NavItem(
                    icon: LucideIcons.home,
                    isActive: currentIndex == 0,
                    onTap: () => _onTap(0),
                  ),
                  // Explore
                  _NavItem(
                    icon: LucideIcons.compass,
                    isActive: currentIndex == 1,
                    onTap: () => _onTap(1),
                  ),
                  // Center FAB (Create Trip)
                  _CenterFab(
                    onTap: () {
                      // Navigate to create trip screen
                      context.push('/create-trip');
                    },
                  ),
                  // Chat
                  _NavItem(
                    icon: LucideIcons.messageCircle,
                    isActive: currentIndex == 3,
                    onTap: () => _onTap(3),
                  ),
                  // Profile
                  _NavItem(
                    icon: LucideIcons.user,
                    isActive: currentIndex == 4,
                    onTap: () => _onTap(4),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Icon(
          icon,
          size: 24,
          color: isActive ? AppColors.primary : AppColors.textTertiary,
        ),
      ),
    );
  }
}

class _CenterFab extends StatelessWidget {
  final VoidCallback onTap;

  const _CenterFab({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Transform.translate(
        offset: const Offset(0, -12),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.bgDeep,
              width: 4,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.4),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            LucideIcons.plus,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }
}
