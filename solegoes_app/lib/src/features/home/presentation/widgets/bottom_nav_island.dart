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

    return Material(
      elevation: 50,
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A0A0A).withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.6),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Home (Branch 0)
                    _NavItem(
                      icon: LucideIcons.home,
                      isActive: currentIndex == 0,
                      onTap: () => _onTap(0),
                    ),
                    // Explore (Branch 1)
                    _NavItem(
                      icon: LucideIcons.compass,
                      isActive: currentIndex == 1,
                      onTap: () => _onTap(1),
                    ),
                    // My Trips (Branch 2)
                    _NavItem(
                      icon: LucideIcons.briefcase,
                      isActive: currentIndex == 2,
                      onTap: () => _onTap(2),
                    ),
                    // Chat (Branch 3)
                    _NavItem(
                      icon: LucideIcons.messageCircle,
                      isActive: currentIndex == 3,
                      onTap: () => _onTap(3),
                    ),
                    // Profile (Branch 4)
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
