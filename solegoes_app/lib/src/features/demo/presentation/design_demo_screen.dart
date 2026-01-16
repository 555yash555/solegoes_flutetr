import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../theme/app_theme.dart';
import '../../../common_widgets/app_snackbar.dart';

/// Demo screen to verify design system elements
/// This screen showcases colors, typography, buttons, inputs, icons, etc.
class DesignDemoScreen extends StatefulWidget {
  const DesignDemoScreen({super.key});

  @override
  State<DesignDemoScreen> createState() => _DesignDemoScreenState();
}

class _DesignDemoScreenState extends State<DesignDemoScreen> {
  bool _pill1Selected = true;
  bool _pill2Selected = false;
  bool _pill3Selected = false;
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  _buildIconButton(LucideIcons.chevronLeft),
                  const SizedBox(width: AppSpacing.sm),
                  const Expanded(
                    child: Text(
                      'Design System Demo',
                      style: AppTextStyles.h3,
                    ),
                  ),
                  _buildIconButton(LucideIcons.settings),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // ===== COLORS =====
              _buildSectionTitle('COLORS'),
              const SizedBox(height: AppSpacing.sm),
              _buildColorRow(),
              const SizedBox(height: AppSpacing.lg),

              // ===== TYPOGRAPHY =====
              _buildSectionTitle('TYPOGRAPHY'),
              const SizedBox(height: AppSpacing.sm),
              const Text('H1 - Plus Jakarta Sans', style: AppTextStyles.h1),
              const SizedBox(height: AppSpacing.xs),
              const Text('H2 - Plus Jakarta Sans', style: AppTextStyles.h2),
              const SizedBox(height: AppSpacing.xs),
              const Text('H3 - Plus Jakarta Sans', style: AppTextStyles.h3),
              const SizedBox(height: AppSpacing.xs),
              const Text('Body Large', style: AppTextStyles.bodyLarge),
              const SizedBox(height: AppSpacing.xs),
              const Text('Body Regular', style: AppTextStyles.body),
              const SizedBox(height: AppSpacing.xs),
              const Text('Body Small', style: AppTextStyles.bodySmall),
              const SizedBox(height: AppSpacing.xs),
              const Text('Label', style: AppTextStyles.label),
              const SizedBox(height: AppSpacing.xs),
              const Text('Caption', style: AppTextStyles.caption),
              const SizedBox(height: AppSpacing.sm),
              // Gradient text
              ShaderMask(
                shaderCallback: (bounds) =>
                    AppColors.primaryGradient.createShader(bounds),
                child: const Text(
                  'Gradient Text',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // ===== BUTTONS =====
              _buildSectionTitle('BUTTONS'),
              const SizedBox(height: AppSpacing.sm),

              // Primary Button (Gradient)
              _buildPrimaryButton(
                'Primary Button',
                onPressed: () => AppSnackbar.showSuccess(
                    context, 'Primary button pressed!'),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Secondary Button
              _buildSecondaryButton(
                'Secondary Button',
                onPressed: () =>
                    AppSnackbar.showInfo(context, 'Secondary button pressed!'),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Social Buttons
              Row(
                children: [
                  Expanded(child: _buildSocialButton('Google', isGoogle: true)),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: _buildSocialButton('Apple', isGoogle: false)),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),

              // Ghost Button
              _buildGhostButton('Ghost Button'),
              const SizedBox(height: AppSpacing.lg),

              // ===== INPUTS =====
              _buildSectionTitle('INPUTS'),
              const SizedBox(height: AppSpacing.sm),

              // Text Label
              const Text('Email or Phone', style: AppTextStyles.label),
              const SizedBox(height: AppSpacing.xs),

              // Input with icon
              _buildInputWithIcon(
                hintText: 'Enter your email',
                icon: LucideIcons.mail,
                controller: _textController,
              ),
              const SizedBox(height: AppSpacing.md),

              const Text('Password', style: AppTextStyles.label),
              const SizedBox(height: AppSpacing.xs),
              _buildInputWithIcon(
                hintText: 'Enter your password',
                icon: LucideIcons.lock,
                obscureText: true,
              ),
              const SizedBox(height: AppSpacing.lg),

              // ===== OTP INPUTS =====
              _buildSectionTitle('OTP INPUT'),
              const SizedBox(height: AppSpacing.sm),
              _buildOtpInput(),
              const SizedBox(height: AppSpacing.lg),

              // ===== PILLS / CHIPS =====
              _buildSectionTitle('PILLS / CHIPS'),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  _buildPill('Adventure', _pill1Selected, () {
                    setState(() => _pill1Selected = !_pill1Selected);
                  }),
                  _buildPill('Beach', _pill2Selected, () {
                    setState(() => _pill2Selected = !_pill2Selected);
                  }),
                  _buildPill('Culture', _pill3Selected, () {
                    setState(() => _pill3Selected = !_pill3Selected);
                  }),
                  _buildPill('Mountains', false, () {}),
                  _buildPill('City', false, () {}),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // ===== GLASS CARD =====
              _buildSectionTitle('GLASS CARD'),
              const SizedBox(height: AppSpacing.sm),
              _buildGlassCard(),
              const SizedBox(height: AppSpacing.lg),

              // ===== LIST ITEMS =====
              _buildSectionTitle('LIST GROUP'),
              const SizedBox(height: AppSpacing.sm),
              _buildListGroup(),
              const SizedBox(height: AppSpacing.lg),

              // ===== ICONS =====
              _buildSectionTitle('LUCIDE ICONS'),
              const SizedBox(height: AppSpacing.sm),
              _buildIconsRow(),
              const SizedBox(height: AppSpacing.lg),

              // ===== SNACKBARS =====
              _buildSectionTitle('SNACKBARS'),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: _buildSecondaryButton(
                      'Error',
                      onPressed: () => AppSnackbar.showError(
                          context, 'Something went wrong!'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: _buildSecondaryButton(
                      'Success',
                      onPressed: () =>
                          AppSnackbar.showSuccess(context, 'Action completed!'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: _buildSecondaryButton(
                      'Info',
                      onPressed: () =>
                          AppSnackbar.showInfo(context, 'Here is some info'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // ===== NAV ISLAND PREVIEW =====
              _buildSectionTitle('NAV ISLAND'),
              const SizedBox(height: AppSpacing.sm),
              _buildNavIslandPreview(),

              const SizedBox(height: 100), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  // ===== BUILDER METHODS =====

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.sectionTitle,
    );
  }

  Widget _buildColorRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildColorBox('BG Deep', AppColors.bgDeep),
          _buildColorBox('Surface', AppColors.bgSurface),
          _buildColorBox('Primary', AppColors.primary),
          _buildColorBox('Violet', AppColors.violet),
          _buildColorBox('Blue', AppColors.accentBlue),
          _buildColorBox('Teal', AppColors.accentTeal),
          _buildColorBox('Rose', AppColors.accentRose),
          _buildColorBox('Green', AppColors.accentGreen),
        ],
      ),
    );
  }

  Widget _buildColorBox(String name, Color color) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              borderRadius: AppRadius.smAll,
              border: Border.all(color: AppColors.borderGlass),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.bgGlassLight,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _buildPrimaryButton(String text, {VoidCallback? onPressed}) {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: AppRadius.mdAll,
        boxShadow: AppShadows.primaryGlow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: AppRadius.mdAll,
          child: Center(
            child: Text(text, style: AppTextStyles.button),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(String text, {VoidCallback? onPressed}) {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.bgGlassLight,
        borderRadius: AppRadius.mdAll,
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: AppRadius.mdAll,
          child: Center(
            child: Text(
              text,
              style: AppTextStyles.button.copyWith(color: AppColors.textPrimary),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(String text, {required bool isGoogle}) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.bgGlassLight,
        borderRadius: AppRadius.mdAll,
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: AppRadius.mdAll,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isGoogle)
                const Icon(LucideIcons.chrome, size: 20, color: Colors.white)
              else
                const Icon(LucideIcons.apple, size: 20, color: Colors.white),
              const SizedBox(width: AppSpacing.sm),
              Text(
                text,
                style: AppTextStyles.button.copyWith(color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGhostButton(String text) {
    return TextButton(
      onPressed: () {},
      child: Text(
        text,
        style: AppTextStyles.button.copyWith(color: AppColors.textSecondary),
      ),
    );
  }

  Widget _buildInputWithIcon({
    required String hintText,
    required IconData icon,
    TextEditingController? controller,
    bool obscureText = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgGlassLight,
        borderRadius: AppRadius.mdAll,
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Icon(icon, color: AppColors.textTertiary, size: 20),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              style: AppTextStyles.body,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: AppColors.textPlaceholder),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        final isFilled = index < 3;
        return Container(
          width: 48,
          height: 56,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isFilled ? AppColors.bgGlassLight : AppColors.bgGlassLight,
            borderRadius: AppRadius.mdAll,
            border: Border.all(
              color: isFilled ? AppColors.borderGlass : AppColors.borderSubtle,
            ),
          ),
          child: Center(
            child: Text(
              isFilled ? '${index + 1}' : '',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPill(String text, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.pillActiveBg
              : AppColors.bgGlassLight,
          borderRadius: AppRadius.mdAll,
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.borderSubtle,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    blurRadius: 15,
                  )
                ]
              : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildGlassCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.bgGlassLight,
        borderRadius: AppRadius.mdAll,
        border: Border.all(color: AppColors.borderSubtle),
        boxShadow: AppShadows.sm,
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: AppRadius.smAll,
              gradient: AppColors.primaryGradient,
            ),
            child: const Icon(LucideIcons.plane, color: Colors.white),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Bali Adventure', style: AppTextStyles.label),
                const SizedBox(height: 4),
                Text(
                  '7 days • Starting ₹45,000',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          const Icon(LucideIcons.chevronRight, color: AppColors.textTertiary),
        ],
      ),
    );
  }

  Widget _buildListGroup() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgGlassLight,
        borderRadius: AppRadius.mdAll,
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        children: [
          _buildListItem(LucideIcons.user, 'Profile', true),
          _buildDivider(),
          _buildListItem(LucideIcons.settings, 'Settings', false),
          _buildDivider(),
          _buildListItem(LucideIcons.bell, 'Notifications', false),
        ],
      ),
    );
  }

  Widget _buildListItem(IconData icon, String title, bool hasNotification) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.bgGlassLight,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.textPrimary, size: 18),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(title, style: AppTextStyles.body),
          ),
          if (hasNotification)
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.accentRose,
                shape: BoxShape.circle,
              ),
            ),
          const SizedBox(width: AppSpacing.xs),
          const Icon(LucideIcons.chevronRight, color: AppColors.textTertiary, size: 20),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: AppColors.borderSubtle,
    );
  }

  Widget _buildIconsRow() {
    final icons = [
      LucideIcons.home,
      LucideIcons.compass,
      LucideIcons.plus,
      LucideIcons.messageCircle,
      LucideIcons.user,
      LucideIcons.mail,
      LucideIcons.lock,
      LucideIcons.heart,
      LucideIcons.star,
      LucideIcons.search,
    ];

    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: icons.map((icon) {
        return Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.bgGlassLight,
            borderRadius: AppRadius.smAll,
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: Icon(icon, color: AppColors.textPrimary, size: 20),
        );
      }).toList(),
    );
  }

  Widget _buildNavIslandPreview() {
    return SizedBox(
      height: 72, // Height for nav + FAB overflow
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // Nav bar container
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.bgGlass,
              borderRadius: AppRadius.fullAll,
              border: Border.all(color: AppColors.borderGlass),
              boxShadow: AppShadows.navIsland,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(LucideIcons.home, true),
                _buildNavItem(LucideIcons.compass, false),
                const SizedBox(width: 48), // Space for FAB
                _buildNavItem(LucideIcons.messageCircle, false),
                _buildNavItem(LucideIcons.user, false),
              ],
            ),
          ),
          // FAB - positioned to overlap top of nav bar
          Positioned(
            top: 4,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.bgDeep, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(LucideIcons.plus, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isActive) {
    // Active item gets a rounded rectangle background
    if (isActive) {
      return Container(
        width: 44,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.pillActiveBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.3),
          ),
        ),
        child: Icon(
          icon,
          color: AppColors.primary,
          size: 20,
        ),
      );
    }
    // Inactive items - just icon
    return SizedBox(
      width: 44,
      height: 36,
      child: Icon(
        icon,
        color: AppColors.textTertiary,
        size: 20,
      ),
    );
  }
}
