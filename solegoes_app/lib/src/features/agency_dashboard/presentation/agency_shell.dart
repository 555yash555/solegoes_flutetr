import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_theme.dart';
import 'components/dashboard_sidebar.dart';
import 'components/dashboard_topbar.dart';

/// Maps branch index → page title shown in mobile topbar
const _branchTitles = <int, String>{
  0: 'Dashboard',
  1: 'My Trips',
  2: 'Bookings',
  3: 'Messages',
  4: 'Payouts',
};

/// Responsive shell that wraps every agency screen.
///
/// >900px → permanent sidebar + sticky topbar + scrollable content  
/// ≤900px → Scaffold drawer + hamburger topbar + scrollable content
class AgencyShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AgencyShell({super.key, required this.navigationShell});

  void _onBranchTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 900;
        if (isDesktop) {
          return _DesktopLayout(
            navigationShell: navigationShell,
            onBranchTap: _onBranchTap,
          );
        }
        return _MobileLayout(
          navigationShell: navigationShell,
          onBranchTap: _onBranchTap,
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
// Desktop: permanent sidebar + content column
// ─────────────────────────────────────────────
class _DesktopLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final ValueChanged<int> onBranchTap;

  const _DesktopLayout({
    required this.navigationShell,
    required this.onBranchTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Row(
        children: [
          DashboardSidebar(
            currentIndex: navigationShell.currentIndex,
            onBranchTap: onBranchTap,
          ),
          Expanded(
            child: Column(
              children: [
                DashboardTopbar(isMobile: false),
                Expanded(child: navigationShell),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Mobile: drawer sidebar + hamburger topbar
// ─────────────────────────────────────────────
class _MobileLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final ValueChanged<int> onBranchTap;

  const _MobileLayout({
    required this.navigationShell,
    required this.onBranchTap,
  });

  @override
  Widget build(BuildContext context) {
    final pageTitle = _branchTitles[navigationShell.currentIndex] ?? 'Agency';
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      drawer: Drawer(
        backgroundColor: AppColors.bgSurface,
        // Remove default white background & shadow
        elevation: 0,
        child: DashboardSidebar(
          currentIndex: navigationShell.currentIndex,
          onBranchTap: (i) {
            onBranchTap(i);
            Navigator.of(context).pop(); // close drawer after tap
          },
        ),
      ),
      body: Column(
        children: [
          DashboardTopbar(
            isMobile: true,
            pageTitle: pageTitle,
            onMenuTap: () => Scaffold.of(context).openDrawer(),
          ),
          Expanded(child: navigationShell),
        ],
      ),
    );
  }
}
