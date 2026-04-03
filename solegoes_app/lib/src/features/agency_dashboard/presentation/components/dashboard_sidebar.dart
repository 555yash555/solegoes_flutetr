import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../common_widgets/sole_goes_logo.dart';
import '../../../../features/authentication/data/auth_repository.dart';
import '../../../../features/agency/data/agency_repository.dart';
import '../../../../theme/app_theme.dart';

// ─────────────────────────────────────────────
// Nav item model (compile-time constant)
// ─────────────────────────────────────────────
class _NavItem {
  final IconData icon;
  final String label;
  final int? branch;   // null = push route
  final String? route; // used when branch is null

  const _NavItem({
    required this.icon,
    required this.label,
    this.branch,
    this.route,
  });
}

const _navSections = <(String, List<_NavItem>)>[
  ('Overview', [
    _NavItem(icon: LucideIcons.layoutDashboard, label: 'Dashboard', branch: 0),
  ]),
  ('Manage', [
    _NavItem(icon: LucideIcons.map, label: 'My Trips', branch: 1),
    _NavItem(icon: LucideIcons.calendarCheck, label: 'Bookings', branch: 2),
    _NavItem(icon: LucideIcons.messageCircle, label: 'Messages', branch: 3),
  ]),
  ('Finance', [
    _NavItem(icon: LucideIcons.indianRupee, label: 'Payouts', branch: 4),
  ]),
  ('Account', [
    _NavItem(
      icon: LucideIcons.building2,
      label: 'Agency Profile',
      branch: null,
      route: '/agency/profile',
    ),
    _NavItem(
      icon: LucideIcons.settings,
      label: 'Settings',
      branch: null,
      route: '/agency/settings',
    ),
  ]),
];

// ─────────────────────────────────────────────
// DashboardSidebar
// ─────────────────────────────────────────────
class DashboardSidebar extends ConsumerWidget {
  final int currentIndex;
  final ValueChanged<int> onBranchTap;

  const DashboardSidebar({
    super.key,
    required this.currentIndex,
    required this.onBranchTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 240,
      color: AppColors.bgSurface,
      child: Column(
        children: [
          _SidebarLogo(),
          _AgencyInfoSection(),
          Expanded(child: _NavList(currentIndex: currentIndex, onBranchTap: onBranchTap)),
          const _SidebarFooter(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Logo row
// ─────────────────────────────────────────────
class _SidebarLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: Row(
        children: [
          const SoleGoesLogo(fontSize: 18, centered: false),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.14),
              borderRadius: AppRadius.fullAll,
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            child: Text(
              'Agency',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Agency info (watches live agency doc)
// ─────────────────────────────────────────────
class _AgencyInfoSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(authStateChangesProvider);
    return userAsync.when(
      data: (user) {
        if (user == null || user.agencyId == null) return const SizedBox.shrink();
        final agencyAsync = ref.watch(agencyStreamProvider(user.agencyId!));
        return agencyAsync.when(
          data: (agency) => _AgencyInfoContent(
            name: agency.businessName,
            initial: agency.businessName.isNotEmpty
                ? agency.businessName[0].toUpperCase()
                : 'A',
            isVerified: agency.isVerified,
          ),
          loading: () => _AgencyInfoContent(name: '...', initial: '?', isVerified: false),
          error: (_, __) => const SizedBox.shrink(),
        );
      },
      loading: () => _AgencyInfoContent(name: '...', initial: '?', isVerified: false),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _AgencyInfoContent extends StatelessWidget {
  final String name;
  final String initial;
  final bool isVerified;

  const _AgencyInfoContent({
    required this.name,
    required this.initial,
    required this.isVerified,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: AppRadius.smAll,
            ),
            alignment: Alignment.center,
            child: Text(
              initial,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          if (isVerified) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.12),
                border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
                borderRadius: AppRadius.fullAll,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.shieldCheck, size: 10, color: AppColors.success),
                  const SizedBox(width: 4),
                  Text(
                    'Verified Partner',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.success,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Nav list
// ─────────────────────────────────────────────
class _NavList extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onBranchTap;

  const _NavList({
    required this.currentIndex,
    required this.onBranchTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (sectionLabel, items) in _navSections) ...[
            _SectionLabel(label: sectionLabel),
            for (final item in items)
              _NavRow(
                icon: item.icon,
                label: item.label,
                isActive: item.branch != null && item.branch == currentIndex,
                onTap: () {
                  // Close drawer if open (mobile)
                  if (Scaffold.maybeOf(context)?.isDrawerOpen ?? false) {
                    Navigator.of(context).pop();
                  }
                  if (item.branch != null) {
                    onBranchTap(item.branch!);
                  } else if (item.route != null) {
                    context.go(item.route!);
                  }
                },
              ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Section label
// ─────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 6),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.caption.copyWith(
          color: AppColors.textTertiary,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Nav row
// ─────────────────────────────────────────────
class _NavRow extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavRow({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_NavRow> createState() => _NavRowState();
}

class _NavRowState extends State<_NavRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final Color bg = widget.isActive
        ? AppColors.primary.withValues(alpha: 0.14)
        : _hovered
            ? AppColors.surfaceHover
            : Colors.transparent;
    final Color fg = widget.isActive
        ? AppColors.primary
        : _hovered
            ? AppColors.textPrimary
            : AppColors.textSecondary;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(vertical: 1),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          decoration: BoxDecoration(color: bg, borderRadius: AppRadius.smAll),
          child: Row(
            children: [
              Icon(widget.icon, size: 16, color: fg),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.label,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 13,
                    fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w500,
                    color: fg,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Footer: sign out
// ─────────────────────────────────────────────
class _SidebarFooter extends ConsumerStatefulWidget {
  const _SidebarFooter();

  @override
  ConsumerState<_SidebarFooter> createState() => _SidebarFooterState();
}

class _SidebarFooterState extends ConsumerState<_SidebarFooter> {
  bool _hovered = false;
  bool _signingOut = false;

  Future<void> _doSignOut() async {
    if (_signingOut) return;
    setState(() => _signingOut = true);
    try {
      await ref.read(authRepositoryProvider).signOut();
    } finally {
      if (mounted) setState(() => _signingOut = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _doSignOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            decoration: BoxDecoration(
              color: _hovered ? AppColors.surfaceHover : Colors.transparent,
              borderRadius: AppRadius.smAll,
            ),
            child: Row(
              children: [
                if (_signingOut)
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.textTertiary,
                    ),
                  )
                else
                  Icon(
                    LucideIcons.logOut,
                    size: 16,
                    color: _hovered ? AppColors.textSecondary : AppColors.textTertiary,
                  ),
                const SizedBox(width: 10),
                Text(
                  _signingOut ? 'Signing out...' : 'Sign out',
                  style: AppTextStyles.body.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: _hovered ? AppColors.textSecondary : AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
