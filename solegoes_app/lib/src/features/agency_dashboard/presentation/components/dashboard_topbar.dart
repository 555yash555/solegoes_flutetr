import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../features/authentication/data/auth_repository.dart';
import '../../../../theme/app_theme.dart';

class DashboardTopbar extends ConsumerWidget {
  /// True when we're in mobile layout — shows hamburger instead of greeting.
  final bool isMobile;

  /// Page title shown in mobile mode (next to hamburger).
  final String pageTitle;

  /// Called when hamburger tapped (opens the drawer).
  final VoidCallback? onMenuTap;

  const DashboardTopbar({
    super.key,
    this.isMobile = false,
    this.pageTitle = 'Dashboard',
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(authStateChangesProvider);
    final agencyName = userAsync.maybeWhen(
      data: (u) => u?.displayName.isNotEmpty == true ? u!.displayName : 'Agency',
      orElse: () => 'Agency',
    );

    final now = DateTime.now();
    final dateStr = DateFormat('EEEE, d MMM yyyy').format(now);
    final hour = now.hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 32,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgDeep.withValues(alpha: 0.88),
        border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: Row(
        children: [
          // Left
          if (isMobile) ...[
            _IconBtn(
              icon: LucideIcons.menu,
              onTap: onMenuTap ?? () {},
            ),
            const SizedBox(width: 12),
            Text(
              pageTitle,
              style: AppTextStyles.h4.copyWith(fontSize: 16),
            ),
          ] else ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$greeting, $agencyName 👋',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  dateStr,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textTertiary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],

          const Spacer(),

          // Right actions
          Row(
            children: [
              // Bell icon with notification dot
              _NotifBtn(),
              const SizedBox(width: 8),
              // Help
              _IconBtn(icon: LucideIcons.helpCircle, onTap: () {}),
              const SizedBox(width: 8),
              // Avatar
              _AgencyAvatar(agencyName: agencyName),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Small icon button (bell, help, etc.)
// ─────────────────────────────────────────────
class _IconBtn extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconBtn({required this.icon, required this.onTap});

  @override
  State<_IconBtn> createState() => _IconBtnState();
}

class _IconBtnState extends State<_IconBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: _hovered ? AppColors.surfaceHover : AppColors.surfaceOverlay,
            borderRadius: AppRadius.smAll,
            border: Border.all(color: AppColors.borderSubtle),
          ),
          alignment: Alignment.center,
          child: Icon(
            widget.icon,
            size: 17,
            color: _hovered ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Bell button with unread dot
// ─────────────────────────────────────────────
class _NotifBtn extends StatefulWidget {
  @override
  State<_NotifBtn> createState() => _NotifBtnState();
}

class _NotifBtnState extends State<_NotifBtn> {
  bool _hovered = false;

  // TODO (Phase 8): wire to real notification count
  static const bool _hasUnread = true;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {},
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: _hovered ? AppColors.surfaceHover : AppColors.surfaceOverlay,
            borderRadius: AppRadius.smAll,
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Center(
                child: Icon(
                  LucideIcons.bell,
                  size: 17,
                  color: _hovered ? AppColors.textPrimary : AppColors.textSecondary,
                ),
              ),
              if (_hasUnread)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.accentRose,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.bgDeep,
                        width: 1.5,
                      ),
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
// Agency avatar button (first letter, gradient)
// ─────────────────────────────────────────────
class _AgencyAvatar extends StatefulWidget {
  final String agencyName;
  const _AgencyAvatar({required this.agencyName});

  @override
  State<_AgencyAvatar> createState() => _AgencyAvatarState();
}

class _AgencyAvatarState extends State<_AgencyAvatar> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final initial = widget.agencyName.isNotEmpty
        ? widget.agencyName[0].toUpperCase()
        : 'A';

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {},
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: AppRadius.smAll,
            boxShadow: _hovered ? AppShadows.sm : [],
          ),
          alignment: Alignment.center,
          child: Text(
            initial,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
