import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_theme.dart';
import 'widgets/bottom_nav_island.dart';

/// Main app scaffold with floating bottom navigation island
class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: navigationShell,
      extendBody: true,
      bottomNavigationBar: BottomNavIsland(navigationShell: navigationShell),
    );
  }
}
