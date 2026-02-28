import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../theme/app_theme.dart';
import '../../../../common_widgets/app_button.dart';
import '../../../../common_widgets/app_snackbar.dart';
import '../../../agency/data/agency_repository.dart';
import '../../../authentication/data/auth_repository.dart';
import '../../../authentication/presentation/auth_controller.dart';

/// Agency Pending Screen — converted from design_mockups/02_agency_pending.html
/// Full-screen route (no DashboardScaffold shell).
/// Listens to agencyStreamProvider — auto-redirects on 'approved' status.
class AgencyPendingScreen extends ConsumerStatefulWidget {
  const AgencyPendingScreen({super.key});

  @override
  ConsumerState<AgencyPendingScreen> createState() =>
      _AgencyPendingScreenState();
}

class _AgencyPendingScreenState extends ConsumerState<AgencyPendingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _outerRingCtrl;
  late final AnimationController _innerRingCtrl;
  late final AnimationController _pulseCtrl;
  late final AnimationController _blinkCtrl;

  @override
  void initState() {
    super.initState();
    _outerRingCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
    _innerRingCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: false);
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _blinkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _outerRingCtrl.dispose();
    _innerRingCtrl.dispose();
    _pulseCtrl.dispose();
    _blinkCtrl.dispose();
    super.dispose();
  }

  Future<void> _signOut() async {
    await ref.read(authControllerProvider.notifier).signOut();
    if (mounted) context.go('/login');
  }

  Future<void> _launchUrl(String url) async {
    // Copy contact info to clipboard so user can act on it
    await Clipboard.setData(ClipboardData(text: url));
    if (mounted) {
      AppSnackbar.showSuccess(context, 'Copied to clipboard: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the current user to get agencyId
    final userAsync = ref.watch(authStateChangesProvider);
    final agencyId = userAsync.when(
      data: (u) => u?.agencyId,
      loading: () => null,
      error: (_, __) => null,
    );

    // Listen to agency stream — auto-redirect when approved
    if (agencyId != null) {
      ref.listen(
        agencyStreamProvider(agencyId),
        (_, next) {
          next.whenData((agency) {
            if (agency.verificationStatus == 'approved' && mounted) {
              context.go('/agency');
            }
          });
        },
      );
    }

    final agencyAsync =
        agencyId != null ? ref.watch(agencyStreamProvider(agencyId)) : null;
    final agencyName = agencyAsync?.when(
      data: (a) => a.businessName,
      loading: () => null,
      error: (_, __) => null,
    );
    final gstUploaded = agencyAsync?.when(
      data: (a) => a.documents['gstUploaded'] as bool? ?? false,
      loading: () => false,
      error: (_, __) => false,
    ) ?? false;
    final portfolioCount = agencyAsync?.when(
      data: (a) => a.documents['portfolioCount'] as int? ?? 0,
      loading: () => 0,
      error: (_, __) => 0,
    ) ?? 0;

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        child: Stack(
          children: [
            // Ambient glow blobs
            Positioned(
              top: -160,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 900,
                  height: 700,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(colors: [
                      AppColors.primary.withValues(alpha: 0.10),
                      Colors.transparent,
                    ], stops: const [0.0, 0.65]),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              right: -100,
              child: Container(
                width: 500,
                height: 500,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    AppColors.violet.withValues(alpha: 0.07),
                    Colors.transparent,
                  ], stops: const [0.0, 0.65]),
                ),
              ),
            ),
            Column(
              children: [
                _buildTopbar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 48),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 560),
                        child: Column(
                          children: [
                            _buildStatusIllustration(),
                            const SizedBox(height: 32),
                            _buildReviewBadge(),
                            const SizedBox(height: 20),
                            _buildTitle(),
                            const SizedBox(height: 12),
                            _buildSubtitle(),
                            const SizedBox(height: 36),
                            if (agencyName != null)
                              _buildDetailPills(
                                agencyName: agencyName,
                                gstUploaded: gstUploaded,
                                portfolioCount: portfolioCount,
                              ),
                            const SizedBox(height: 32),
                            _buildTimeline(),
                            const SizedBox(height: 28),
                            Divider(color: AppColors.borderSubtle),
                            const SizedBox(height: 20),
                            Text(
                              'Have documents ready or a question about your application?',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.labelSmall,
                            ),
                            const SizedBox(height: 14),
                            _buildSupportRow(), 
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopbar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final hPad = constraints.maxWidth > 600 ? 40.0 : 20.0;
        return Container(
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 20),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
          ),
          child: Row(
            children: [
              // Logo
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: AppRadius.smAll,
                ),
                alignment: Alignment.center,
                child: Text('S',
                    style: AppTextStyles.label.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800)),
              ),
              const SizedBox(width: 10),
              Text('SoleGoes', style: AppTextStyles.h4),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.4)),
                  borderRadius: AppRadius.fullAll,
                ),
                child: Text('Agency',
                    style: AppTextStyles.labelSmall
                        .copyWith(color: AppColors.primary)),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _signOut,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.logOut,
                        size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    // Hide "Sign out" label on very small screens
                    if (constraints.maxWidth > 400)
                      Text('Sign out',
                          style: AppTextStyles.labelSmall
                              .copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusIllustration() {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer spinning dashed ring
          AnimatedBuilder(
            animation: _outerRingCtrl,
            builder: (_, __) => Transform.rotate(
              angle: _outerRingCtrl.value * 2 * math.pi,
              child: CustomPaint(
                size: const Size(120, 120),
                painter: _DashedCirclePainter(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  radius: 58,
                  dashCount: 16,
                ),
              ),
            ),
          ),
          // Inner counter-spinning dashed ring
          AnimatedBuilder(
            animation: _innerRingCtrl,
            builder: (_, __) => Transform.rotate(
              angle: -_innerRingCtrl.value * 2 * math.pi,
              child: CustomPaint(
                size: const Size(88, 88),
                painter: _DashedCirclePainter(
                  color: AppColors.violet.withValues(alpha: 0.2),
                  radius: 42,
                  dashCount: 10,
                ),
              ),
            ),
          ),
          // Core icon circle (pulsing)
          AnimatedBuilder(
            animation: _pulseCtrl,
            builder: (_, child) => Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                border:
                    Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(
                        alpha: 0.25 * _pulseCtrl.value),
                    blurRadius: 24,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Icon(LucideIcons.clock,
                  color: AppColors.primary, size: 28),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.accentYellow.withValues(alpha: 0.10),
        border: Border.all(
            color: AppColors.accentYellow.withValues(alpha: 0.2)),
        borderRadius: AppRadius.fullAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _blinkCtrl,
            builder: (_, __) => Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: AppColors.accentYellow
                    .withValues(alpha: _blinkCtrl.value),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'APPLICATION UNDER REVIEW',
            style: AppTextStyles.overline.copyWith(
              color: AppColors.accentYellow,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            height: 1.2),
        children: [
          const TextSpan(text: 'You\'re in the queue,\n'),
          WidgetSpan(
            child: ShaderMask(
              shaderCallback: (b) => AppColors.primaryGradient.createShader(b),
              child: const Text(
                'Founding Partner.',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtitle() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        children: [
          const TextSpan(
              text:
                  'Your application has been received. Our team personally reviews every Founding Partner application to maintain quality. We\'ll reach out within '),
          TextSpan(
            text: '2–3 business days.',
            style: AppTextStyles.body.copyWith(
                color: AppColors.textPrimary, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailPills({
    required String agencyName,
    required bool gstUploaded,
    required int portfolioCount,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        _detailPill(LucideIcons.building2, agencyName),
        if (gstUploaded) _detailPill(LucideIcons.fileBadge, 'GST Submitted'),
        if (portfolioCount > 0)
          _detailPill(
              LucideIcons.image, '$portfolioCount Portfolio Photos'),
      ],
    );
  }

  Widget _detailPill(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceOverlay,
        border: Border.all(color: AppColors.borderSubtle),
        borderRadius: AppRadius.fullAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.textTertiary),
          const SizedBox(width: 6),
          Text(label, style: AppTextStyles.labelSmall),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    final steps = [
      (
        status: 'done',
        icon: LucideIcons.check,
        title: 'Application Submitted',
        subtitle:
            'Your profile, documents, and bank details have been securely received.',
        titleColor: AppColors.textPrimary,
      ),
      (
        status: 'active',
        icon: LucideIcons.search,
        title: 'Manual Review in Progress',
        subtitle:
            'Our team is verifying your GST certificate and portfolio. We personally vet every partner to maintain platform quality.',
        titleColor: AppColors.accentYellow,
      ),
      (
        status: 'upcoming',
        icon: null,
        title: 'Founding Partner Badge Issued',
        subtitle:
            'Once approved, your dashboard unlocks instantly. You\'ll receive your permanent Verified Founding Partner badge.',
        titleColor: AppColors.textSecondary,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        border: Border.all(color: AppColors.borderSubtle),
        borderRadius: AppRadius.lgAll,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('WHAT HAPPENS NEXT',
              style: AppTextStyles.sectionTitle.copyWith(letterSpacing: 1.0)),
          const SizedBox(height: 20),
          ...steps.asMap().entries.map((e) {
            final i = e.key;
            final step = e.value;
            final isLast = i == steps.length - 1;
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      _timelineDot(step.status, step.icon, i + 1),
                      if (!isLast)
                        Expanded(
                          child: Container(
                            width: 2,
                            color: AppColors.borderSubtle,
                            margin:
                                const EdgeInsets.symmetric(vertical: 4),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step.title,
                            style: AppTextStyles.label
                                .copyWith(color: step.titleColor),
                          ),
                          const SizedBox(height: 3),
                          Text(step.subtitle,
                              style: AppTextStyles.labelSmall),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _timelineDot(String status, IconData? icon, int number) {
    Color bg, border, fg;
    if (status == 'done') {
      bg = AppColors.success.withValues(alpha: 0.15);
      border = AppColors.success.withValues(alpha: 0.3);
      fg = AppColors.success;
    } else if (status == 'active') {
      bg = AppColors.accentYellow.withValues(alpha: 0.15);
      border = AppColors.accentYellow.withValues(alpha: 0.3);
      fg = AppColors.accentYellow;
    } else {
      bg = AppColors.surfaceOverlay;
      border = AppColors.borderSubtle;
      fg = AppColors.textTertiary;
    }

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: icon != null && status != 'upcoming'
          ? Icon(icon, size: 13, color: fg)
          : Text('$number',
              style: AppTextStyles.labelSmall
                  .copyWith(color: fg, fontWeight: FontWeight.w700)),
    );
  }

  Widget _buildSupportRow() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        AppButton(
          text: 'Email Us',
          onPressed: () =>
              _launchUrl('partners@solegoes.com'),
          variant: AppButtonVariant.secondary,
          icon: LucideIcons.mail,
          isFullWidth: false,
          size: AppButtonSize.small,
        ),
        AppButton(
          text: 'WhatsApp',
          onPressed: () => _launchUrl('+91 99999 99999'),
          variant: AppButtonVariant.secondary,
          icon: LucideIcons.messageCircle,
          isFullWidth: false,
          size: AppButtonSize.small,
        ),
        GestureDetector(
          onTap: () => context.go('/agency-login'),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.arrowLeft,
                    size: 15, color: AppColors.textTertiary),
                const SizedBox(width: 6),
                Text('Different account?',
                    style: AppTextStyles.labelSmall
                        .copyWith(color: AppColors.textTertiary)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Draws a dashed circle outline using CustomPainter
class _DashedCirclePainter extends CustomPainter {
  final Color color;
  final double radius;
  final int dashCount;

  const _DashedCirclePainter({
    required this.color,
    required this.radius,
    required this.dashCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final dashAngle = (math.pi * 2) / (dashCount * 2);

    for (int i = 0; i < dashCount; i++) {
      final startAngle = i * dashAngle * 2;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        dashAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_DashedCirclePainter old) => false;
}
