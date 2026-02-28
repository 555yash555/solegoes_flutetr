import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../theme/app_theme.dart';
import '../../../../common_widgets/app_button.dart';
import '../../../../common_widgets/app_text_field.dart';
import '../../../../common_widgets/app_snackbar.dart';
import '../../../agency/domain/agency.dart';
import '../../../authentication/data/auth_repository.dart';
import '../../../authentication/presentation/auth_controller.dart';

/// Agency Signup Screen — 3-step wizard
/// Converted from design_mockups/01_agency_signup.html
/// Desktop: 420px brand panel (left) + scrollable form panel (right)
/// Mobile: form only (brand panel hidden)
class AgencySignupScreen extends ConsumerStatefulWidget {
  const AgencySignupScreen({super.key});

  @override
  ConsumerState<AgencySignupScreen> createState() =>
      _AgencySignupScreenState();
}

class _AgencySignupScreenState extends ConsumerState<AgencySignupScreen> {
  int _currentStep = 0; // 0-indexed: 0=Company, 1=Documents, 2=Bank
  bool _isSubmitting = false;

  // ── Step 1 controllers ──
  final _businessNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  bool _obscurePassword = true;
  String _teamSize = '';
  final _yearsCtrl = TextEditingController();
  final List<String> _selectedSpecialties = [];

  // ── Step 2 ──
  // In a real implementation: file_picker + Firebase Storage uploads
  bool _gstUploaded = false;
  int _portfolioCount = 0;

  // ── Step 3 controllers ──
  final _accountHolderCtrl = TextEditingController();
  final _bankNameCtrl = TextEditingController();
  final _ifscCtrl = TextEditingController();
  final _accountNumberCtrl = TextEditingController();
  bool _obscureAccountNumber = true;
  bool _agreedToTerms = false;

  static const _specialties = [
    'Mountain Treks',
    'Beach Getaways',
    'Camping',
    'Wellness',
    'Adventure Sports',
    'Eco Tourism',
    'Heritage & Culture',
    'International',
    'Winter Trips',
    'Budget Travel',
  ];

  static const _teamSizeOptions = [
    '1–5 people',
    '6–15 people',
    '16–50 people',
    '50+ people',
  ];

  bool _isLoadingDraft = false;

  @override
  void initState() {
    super.initState();
    _loadDraft();
  }

  Future<void> _loadDraft() async {
    final uid = ref.read(authRepositoryProvider).currentUser?.uid;
    if (uid == null) return;
    
    setState(() => _isLoadingDraft = true);
    
    try {
      final doc = await FirebaseFirestore.instance.collection('agency_drafts').doc(uid).get();
      if (!doc.exists) {
        if (mounted) setState(() => _isLoadingDraft = false);
        return;
      }
      
      final data = doc.data()!;
      _businessNameCtrl.text = data['businessName'] ?? '';
      _emailCtrl.text = data['email'] ?? '';
      _phoneCtrl.text = data['phone'] ?? '';
      _descriptionCtrl.text = data['description'] ?? '';
      final years = data['yearsExperience'];
      _yearsCtrl.text = years != null && years > 0 ? years.toString() : '';
      _teamSize = data['teamSize'] ?? '';
      
      if (data['specialties'] != null) {
        _selectedSpecialties.clear();
        _selectedSpecialties.addAll(List<String>.from(data['specialties']));
      }
      
      _gstUploaded = data['gstUploaded'] ?? false;
      _portfolioCount = data['portfolioCount'] ?? 0;
      
      _accountHolderCtrl.text = data['bankAccountHolder'] ?? '';
      _bankNameCtrl.text = data['bankName'] ?? '';
      _ifscCtrl.text = data['bankIfsc'] ?? '';
      _accountNumberCtrl.text = data['bankAccountNumber'] ?? '';
      _agreedToTerms = data['agreedToTerms'] ?? false;
      
      // Navigate to the correct step they were on
      _currentStep = data['currentStep'] ?? 0;
      
      if (mounted) setState(() {});
    } catch (_) {
      // ignore
    } finally {
      if (mounted) setState(() => _isLoadingDraft = false);
    }
  }

  Future<void> _saveDraft() async {
    final uid = ref.read(authRepositoryProvider).currentUser?.uid;
    if (uid == null) return;
    
    try {
      await FirebaseFirestore.instance.collection('agency_drafts').doc(uid).set({
        'currentStep': _currentStep,
        'businessName': _businessNameCtrl.text.trim(),
        'email': _emailCtrl.text.trim(),
        'phone': _phoneCtrl.text.trim(),
        'description': _descriptionCtrl.text.trim(),
        'yearsExperience': int.tryParse(_yearsCtrl.text.trim()) ?? 0,
        'teamSize': _teamSize,
        'specialties': _selectedSpecialties,
        'gstUploaded': _gstUploaded,
        'portfolioCount': _portfolioCount,
        'bankAccountHolder': _accountHolderCtrl.text.trim(),
        'bankName': _bankNameCtrl.text.trim(),
        'bankIfsc': _ifscCtrl.text.trim(),
        'bankAccountNumber': _accountNumberCtrl.text.trim(),
        'agreedToTerms': _agreedToTerms,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (_) {
      // ignore
    }
  }

  @override
  void dispose() {
    _businessNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _descriptionCtrl.dispose();
    _yearsCtrl.dispose();
    _accountHolderCtrl.dispose();
    _bankNameCtrl.dispose();
    _ifscCtrl.dispose();
    _accountNumberCtrl.dispose();
    super.dispose();
  }

  bool _validateStep1() {
    if (_businessNameCtrl.text.trim().isEmpty) {
      AppSnackbar.showError(context, 'Please enter your business name');
      return false;
    }
    if (_emailCtrl.text.trim().isEmpty) {
      AppSnackbar.showError(context, 'Please enter your email');
      return false;
    }
    if (_phoneCtrl.text.trim().isEmpty) {
      AppSnackbar.showError(context, 'Please enter your phone number');
      return false;
    }

    if (ref.read(authRepositoryProvider).currentUser == null) {
      if (_passwordCtrl.text.trim().isEmpty) {
        AppSnackbar.showError(context, 'Please enter a password');
        return false;
      }
      if (_passwordCtrl.text.trim().length < 6) {
        AppSnackbar.showError(context, 'Password must be at least 6 characters');
        return false;
      }
    }
    return true;
  }

  bool _validateStep2() {
    if (!_gstUploaded) {
      AppSnackbar.showError(
          context, 'Please upload your GST certificate to proceed');
      return false;
    }
    return true;
  }

  bool _validateStep3() {
    if (_accountHolderCtrl.text.trim().isEmpty) {
      AppSnackbar.showError(context, 'Please enter account holder name');
      return false;
    }
    if (_bankNameCtrl.text.trim().isEmpty) {
      AppSnackbar.showError(context, 'Please select a bank');
      return false;
    }
    if (_ifscCtrl.text.trim().isEmpty) {
      AppSnackbar.showError(context, 'Please enter IFSC code');
      return false;
    }
    if (_accountNumberCtrl.text.trim().isEmpty) {
      AppSnackbar.showError(context, 'Please enter account number');
      return false;
    }
    if (!_agreedToTerms) {
      AppSnackbar.showError(context, 'Please agree to the terms to continue');
      return false;
    }
    return true;
  }

  Future<void> _nextStep() async {
    bool valid = false;
    if (_currentStep == 0) valid = _validateStep1();
    if (_currentStep == 1) valid = _validateStep2();
    if (_currentStep == 2) {
      if (_validateStep3()) _submitApplication();
      return;
    }

    if (valid && _currentStep == 0 && ref.read(authRepositoryProvider).currentUser == null) {
      setState(() => _isSubmitting = true);
      final user = await ref.read(authControllerProvider.notifier).createUserWithEmailAndPassword(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
        displayName: _businessNameCtrl.text.trim(),
        phoneNumber: _phoneCtrl.text.trim(),
      );
      if (mounted) setState(() => _isSubmitting = false);
      if (user == null) return; // Stay on step 1 on failure
    }

    if (valid) {
      setState(() => _currentStep++);
      _saveDraft();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _saveDraft();
    } else {
      context.go('/agency-login');
    }
  }

  Future<void> _submitApplication() async {
    final uid = ref.read(authRepositoryProvider).currentUser?.uid;
    if (uid == null) {
      AppSnackbar.showError(context, 'You must be signed in to apply');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final agencyId = FirebaseFirestore.instance.collection('agencies').doc().id;

      final agency = Agency(
        agencyId: agencyId,
        ownerUid: uid,
        businessName: _businessNameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        description: _descriptionCtrl.text.trim(),
        specialties: List<String>.from(_selectedSpecialties),
        teamSize: _teamSize,
        yearsExperience: int.tryParse(_yearsCtrl.text.trim()) ?? 0,
        verificationStatus: 'pending',
        bankAccountHolder: _accountHolderCtrl.text.trim(),
        bankName: _bankNameCtrl.text.trim(),
        bankIfsc: _ifscCtrl.text.trim().toUpperCase(),
        // Mask account number — keep last 4 digits only
        bankAccountNumberMasked:
            _accountNumberCtrl.text.trim().length > 4
                ? '••••${_accountNumberCtrl.text.trim().substring(_accountNumberCtrl.text.trim().length - 4)}'
                : '••••',
        documents: {
          'gstUploaded': _gstUploaded,
          'portfolioCount': _portfolioCount,
        },
      );

      await ref.read(authRepositoryProvider).registerAgency(
            agency: agency,
            uid: uid,
          );

      // Clear the draft once successfully submitted
      try {
        await FirebaseFirestore.instance.collection('agency_drafts').doc(uid).delete();
      } catch (_) {}

      if (mounted) {
        context.go('/agency-pending');
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(context, 'Failed to submit application. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingDraft) {
      return Scaffold(
        backgroundColor: AppColors.bgDeep,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 900;
        return Scaffold(
          backgroundColor: AppColors.bgDeep,
          body: SafeArea(
            child: isDesktop
                ? _buildDesktopLayout(constraints)
                : _buildMobileLayout(),
          ),
          bottomNavigationBar: isDesktop
              ? null
              : SafeArea(
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 24, left: 20, right: 20, top: 20),
                    decoration: BoxDecoration(
                      color: AppColors.bgDeep,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 680),
                      child: _buildMobileStepNav(),
                    ),
                  ),
                ),
        );
      },
    );
  }

  // ─── Desktop: fixed brand panel left + scrollable form right ───
  Widget _buildDesktopLayout(BoxConstraints constraints) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Brand panel: fixed width, clips to screen height
        SizedBox(
          width: 420,
          height: constraints.maxHeight,
          child: _buildBrandPanel(),
        ),
        // Form: scrollable right column
        Expanded(
          child: SizedBox(
            height: constraints.maxHeight,
            child: Column(
              children: [
                _buildFormTopbar(true),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStepper(true),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 28),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 680),
                              child: _buildCurrentStep(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: AppColors.bgDeep,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 680),
                        child: _buildStepNav(true),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─── Mobile: single scrollable column, no brand panel ───
  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildFormTopbar(false),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStepper(false),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 56),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 680),
                      child: _buildCurrentStep(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─── Brand Panel (desktop only, 420px) ───

  Widget _buildBrandPanel() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        border: Border(
            right: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: Stack(
        children: [
          // Ambient glows
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.primary.withValues(alpha: 0.18),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: AppRadius.smAll,
                      ),
                      alignment: Alignment.center,
                      child: Text('S',
                          style: AppTextStyles.label.copyWith(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800)),
                    ),
                    const SizedBox(width: 10),
                    Text('SoleGoes',
                        style: AppTextStyles.h4.copyWith(
                            color: AppColors.textPrimary)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
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
                  ],
                ),
                const SizedBox(height: 48),
                // Eyebrow
                Text('Founding Partner Program',
                    style: AppTextStyles.labelSmall
                        .copyWith(color: AppColors.primary, letterSpacing: 0.5)),
                const SizedBox(height: 14),
                // Headline
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        height: 1.2),
                    children: [
                      const TextSpan(text: 'Grow your agency\nwith the '),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: ShaderMask(
                          shaderCallback: (b) =>
                              AppColors.primaryGradient.createShader(b),
                          child: const Text('next generation',
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  height: 1.2)),
                        ),
                      ),
                      const TextSpan(text: '\nof travelers.'),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'We are building India\'s most premium platform for Gen Z solo travelers. Apply now, secure your Founding Partner badge.',
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(height: 36),
                // Benefits
                _brandBenefit(
                  iconData: LucideIcons.zap,
                  iconColor: AppColors.primary,
                  iconBg: AppColors.primary.withValues(alpha: 0.12),
                  title: 'Publish in minutes',
                  subtitle: 'Our 6-step wizard lets you add itineraries, pricing instantly.',
                ),
                const SizedBox(height: 16),
                _brandBenefit(
                  iconData: LucideIcons.users,
                  iconColor: AppColors.accentTeal,
                  iconBg: AppColors.accentTeal.withValues(alpha: 0.12),
                  title: 'Reach Gen Z Solo Travelers',
                  subtitle: 'We handle the marketing to attract 20–35 year olds.',
                ),
                const SizedBox(height: 16),
                _brandBenefit(
                  iconData: LucideIcons.indianRupee,
                  iconColor: AppColors.accentYellow,
                  iconBg: AppColors.accentYellow.withValues(alpha: 0.10),
                  title: 'Guaranteed Automatic Payouts',
                  subtitle: 'RBI-compliant payments settled directly to your bank.',
                ),
                const SizedBox(height: 16),
                _brandBenefit(
                  iconData: LucideIcons.shieldCheck,
                  iconColor: AppColors.success,
                  iconBg: AppColors.success.withValues(alpha: 0.12),
                  title: 'Founding Partner Status',
                  subtitle: 'Lock in your Verified Partner badge for higher conversions.',
                ),
                const SizedBox(height: 40),
                // Stats strip
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.borderSubtle),
                    borderRadius: AppRadius.mdAll,
                  ),
                  child: Row(
                    children: [
                      _brandStat('Zero', 'Listing Fees'),
                      Container(width: 1, height: 60, color: AppColors.borderSubtle),
                      _brandStat('First', 'Mover Advantage'),
                      Container(width: 1, height: 60, color: AppColors.borderSubtle),
                      _brandStat('Founding', 'Partner Badge'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _brandBenefit({
    required IconData iconData,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: AppRadius.smAll,
          ),
          child: Icon(iconData, color: iconColor, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.label),
              const SizedBox(height: 2),
              Text(subtitle, style: AppTextStyles.labelSmall),
            ],
          ),
        ),
      ],
    );
  }

  Widget _brandStat(String value, String label) => Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            children: [
              ShaderMask(
                shaderCallback: (b) => AppColors.primaryGradient.createShader(b),
                child: Text(value,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white)),
              ),
              const SizedBox(height: 2),
              Text(label,
                  style: AppTextStyles.labelSmall,
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      );




  Widget _buildFormTopbar(bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 40 : 20,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgDeep.withValues(alpha: 0.85),
        border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            GestureDetector(
              onTap: _prevStep,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.arrowLeft,
                      size: 18, color: AppColors.textPrimary),
                  const SizedBox(width: 6),
                  Text('Back',
                      style: AppTextStyles.label
                          .copyWith(color: AppColors.textPrimary)),
                ],
              ),
            )
          else
            const SizedBox.shrink(),
          const Spacer(),
          // Mobile logo (shown when brand panel is hidden)
          if (!isDesktop) ...[
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: AppRadius.smAll),
              alignment: Alignment.center,
              child: Text('S',
                  style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w800)),
            ),
            const SizedBox(width: 8),
            Text('SoleGoes',
                style: AppTextStyles.label.copyWith(
                    color: AppColors.textPrimary)),
            const Spacer(),
          ],
          Text(
            'Step ${_currentStep + 1} / 3',
            style: AppTextStyles.labelSmall
                .copyWith(color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper(bool isDesktop) {
    final labels = ['Company Details', 'Documents', 'Bank Details'];
    return Padding(
      padding: EdgeInsets.fromLTRB(
          isDesktop ? 40 : 20, 28, isDesktop ? 40 : 20, 0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Stack(
            children: [
              Positioned(
                top: 15, // center of 32px circle
                left: 0,
                right: 0,
                child: Row(
                  children: [
                    const Expanded(flex: 1, child: SizedBox()),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 2,
                        color: 1 <= _currentStep
                            ? AppColors.primary
                            : AppColors.borderSubtle,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 2,
                        color: 2 <= _currentStep
                            ? AppColors.primary
                            : AppColors.borderSubtle,
                      ),
                    ),
                    const Expanded(flex: 1, child: SizedBox()),
                  ],
                ),
              ),
              Row(
                children: List.generate(3, (i) {
                  final isDone = i < _currentStep;
                  final isActive = i == _currentStep;
                  return Expanded(
                    child: Column(
                      children: [
                        _stepCircle(i + 1, isDone: isDone, isActive: isActive),
                        const SizedBox(height: 8),
                        Text(
                          labels[i],
                          style: AppTextStyles.labelSmall.copyWith(
                            color: i <= _currentStep
                                ? AppColors.primary
                                : AppColors.textTertiary,
                            fontWeight: i == _currentStep
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stepCircle(int number, {required bool isDone, required bool isActive}) {
    Color bg, border, fg;
    if (isDone) {
      bg = AppColors.primary.withValues(alpha: 0.15);
      border = AppColors.primary.withValues(alpha: 0.4);
      fg = AppColors.primary;
    } else if (isActive) {
      bg = AppColors.primary;
      border = AppColors.primary;
      fg = Colors.white;
    } else {
      bg = AppColors.bgSurface;
      border = AppColors.borderSubtle;
      fg = AppColors.textTertiary;
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: isDone
          ? Icon(LucideIcons.check, size: 16, color: fg)
          : Text('$number',
              style: AppTextStyles.labelSmall
                  .copyWith(color: fg, fontWeight: FontWeight.w700)),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildStep1();
      case 1:
        return _buildStep2();
      case 2:
        return _buildStep3();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildMobileStepNav() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            if (_currentStep > 0) ...[
              Expanded(
                flex: 1,
                child: AppButton(
                  text: 'Back',
                  onPressed: _prevStep,
                  variant: AppButtonVariant.secondary,
                  icon: LucideIcons.arrowLeft,
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              flex: _currentStep > 0 ? 2 : 1,
              child: AppButton(
                text: _currentStep == 2
                    ? 'Submit Application'
                    : _currentStep == 0
                        ? 'Apply for Early Access'
                        : 'Secure Your Spot',
                onPressed: _nextStep,
                isLoading: _isSubmitting,
                variant: AppButtonVariant.primary,
                trailingIcon: _currentStep == 2 ? LucideIcons.send : LucideIcons.arrowRight,
              ),
            ),
          ],
        ),
        if (_currentStep == 0) ...[
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Have an account? ',
                  style: AppTextStyles.labelSmall
                      .copyWith(color: AppColors.textTertiary)),
              GestureDetector(
                onTap: () => context.go('/agency-login'),
                child: Text('Sign in',
                    style: AppTextStyles.label
                        .copyWith(color: AppColors.primary)),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildStepNav(bool isDesktop) {
    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: Container(
        padding: const EdgeInsets.only(top: 24),
        decoration: BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.borderSubtle))),
        child: _buildMobileStepNav(),
      ),
    );
  }


  // ── Step 1: Company Details ──

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepTag(LucideIcons.building2, 'Company Details'),
        const SizedBox(height: 14),
        Text('Apply for Founding Partner access', style: AppTextStyles.h3),
        const SizedBox(height: 6),
        Text(
          'Complete your profile to secure your Founding Partner badge and first access to our traveler community.',
          style: AppTextStyles.bodySmall,
        ),
        const SizedBox(height: 28),
        // Business name
        _fieldLabel('Business Name', required: true),
        const SizedBox(height: 8),
        AppTextField(
          controller: _businessNameCtrl,
          hint: 'e.g. Mountain Wanderers Pvt Ltd',
          icon: LucideIcons.building2,
        ),
        const SizedBox(height: 18),
        // Email + Phone (2-col on wider, stack on mobile)
        LayoutBuilder(
          builder: (ctx, box) => box.maxWidth > 500
              ? Row(
                  children: [
                    Expanded(child: _emailPhoneField(isEmail: true)),
                    const SizedBox(width: 16),
                    Expanded(child: _emailPhoneField(isEmail: false)),
                  ],
                )
              : Column(
                  children: [
                    _emailPhoneField(isEmail: true),
                    const SizedBox(height: 18),
                    _emailPhoneField(isEmail: false),
                  ],
                ),
        ),
        if (ref.watch(authRepositoryProvider).currentUser == null) ...[
          const SizedBox(height: 18),
          _fieldLabel('Password', required: true),
          const SizedBox(height: 8),
          AppTextField(
            controller: _passwordCtrl,
            hint: 'Choose a strong password',
            icon: LucideIcons.lock,
            obscureText: _obscurePassword,
            suffixIcon: GestureDetector(
              onTap: () => setState(() => _obscurePassword = !_obscurePassword),
              child: Icon(
                _obscurePassword ? LucideIcons.eye : LucideIcons.eyeOff,
                size: 20,
                color: AppColors.textTertiary,
              ),
            ),
          ),
        ],
        const SizedBox(height: 18),
        // Description
        _fieldLabel('Agency Description'),
        const SizedBox(height: 8),
        AppTextField(
          controller: _descriptionCtrl,
          hint: 'What makes your trips special? Describe your style and experience...',
          maxLines: 3,
        ),
        const SizedBox(height: 18),
        // Specialties
        _fieldLabel('Specialties'),
        const SizedBox(height: 4),
        Text('Select all that apply — shown on your public profile',
            style: AppTextStyles.caption),
        const SizedBox(height: 8),
        _buildSpecialtiesGrid(),
        const SizedBox(height: 18),
        // Team size + Years (2-col)
        LayoutBuilder(
          builder: (ctx, box) => box.maxWidth > 500
              ? Row(
                  children: [
                    Expanded(child: _buildTeamSizeDropdown()),
                    const SizedBox(width: 16),
                    Expanded(child: _buildYearsField()),
                  ],
                )
              : Column(
                  children: [
                    _buildTeamSizeDropdown(),
                    const SizedBox(height: 18),
                    _buildYearsField(),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _emailPhoneField({required bool isEmail}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(isEmail ? 'Email' : 'Phone', required: true),
        const SizedBox(height: 8),
        AppTextField(
          controller: isEmail ? _emailCtrl : _phoneCtrl,
          hint: isEmail ? 'hello@agency.com' : '+91 98765 43210',
          icon: isEmail ? LucideIcons.mail : LucideIcons.phone,
          keyboardType: isEmail
              ? TextInputType.emailAddress
              : TextInputType.phone,
        ),
      ],
    );
  }

  Widget _buildSpecialtiesGrid() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgGlassLight,
        border: Border.all(color: AppColors.borderSubtle),
        borderRadius: AppRadius.mdAll,
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _specialties.map((s) {
          final selected = _selectedSpecialties.contains(s);
          return GestureDetector(
            onTap: () => setState(() {
              selected
                  ? _selectedSpecialties.remove(s)
                  : _selectedSpecialties.add(s);
            }),
            child: AnimatedContainer(
              duration: AppDurations.fast,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primary.withValues(alpha: 0.15)
                    : AppColors.surfaceOverlay,
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.borderSubtle,
                ),
                borderRadius: AppRadius.fullAll,
              ),
              child: Text(
                s,
                style: AppTextStyles.labelSmall.copyWith(
                  color: selected
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTeamSizeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('Team Size'),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _teamSize.isEmpty ? null : _teamSize,
          dropdownColor: AppColors.bgSurface,
          icon: const Icon(LucideIcons.chevronDown,
              size: 18, color: AppColors.textTertiary),
          style: AppTextStyles.body,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.bgGlassLight,
            border: OutlineInputBorder(
              borderRadius: AppRadius.mdAll,
              borderSide: BorderSide(color: AppColors.borderSubtle),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.mdAll,
              borderSide: BorderSide(color: AppColors.borderSubtle),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.mdAll,
              borderSide: const BorderSide(color: AppColors.primary),
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 14),
            hintText: 'Select range',
            hintStyle: AppTextStyles.bodySmall,
          ),
          items: _teamSizeOptions
              .map((o) => DropdownMenuItem(
                    value: o,
                    child: Text(o, style: AppTextStyles.body),
                  ))
              .toList(),
          onChanged: (v) => setState(() => _teamSize = v ?? ''),
        ),
      ],
    );
  }

  Widget _buildYearsField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('Years of Experience'),
        const SizedBox(height: 8),
        AppTextField(
          controller: _yearsCtrl,
          hint: 'e.g. 5',
          icon: LucideIcons.calendar,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  // ── Step 2: Documents ──

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepTag(LucideIcons.fileText, 'Documents'),
        const SizedBox(height: 14),
        Text('Verify your agency', style: AppTextStyles.h3),
        const SizedBox(height: 6),
        Text(
          'These documents help us approve your Founding Partner application and build trust with travelers.',
          style: AppTextStyles.bodySmall,
        ),
        const SizedBox(height: 28),

        // GST Certificate
        _fieldLabel('GST Certificate', required: true),
        const SizedBox(height: 4),
        Text('PDF, JPG or PNG — max 5 MB', style: AppTextStyles.caption),
        const SizedBox(height: 8),
        _gstUploaded ? _buildGstUploadedState() : _buildGstUploadZone(),
        const SizedBox(height: 24),

        // Portfolio Photos
        _fieldLabel('Portfolio Photos'),
        const SizedBox(height: 4),
        Text('Showcase your best trips — up to 5 photos',
            style: AppTextStyles.caption),
        const SizedBox(height: 8),
        _buildPortfolioUploadZone(),
        const SizedBox(height: 24),

        // Security callout
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            border:
                Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
            borderRadius: AppRadius.mdAll,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(LucideIcons.shieldCheck,
                  color: AppColors.primary, size: 18),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your documents are secure',
                        style: AppTextStyles.label),
                    const SizedBox(height: 3),
                    Text(
                      'Stored encrypted in Firebase Storage. Only accessed by our verification team — never shared publicly.',
                      style: AppTextStyles.labelSmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGstUploadZone() {
    return GestureDetector(
      onTap: () => setState(() {
        // In production: file_picker integration
        _gstUploaded = true;
      }),
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: AppColors.bgGlassLight,
          border: Border.all(
              color: AppColors.borderGlass, style: BorderStyle.solid),
          borderRadius: AppRadius.mdAll,
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: AppRadius.mdAll,
              ),
              child: Icon(LucideIcons.fileBadge,
                  color: AppColors.primary, size: 22),
            ),
            const SizedBox(height: 12),
            Text('Click to upload GST certificate',
                style: AppTextStyles.label),
            const SizedBox(height: 4),
            Text('or drag and drop here', style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }

  Widget _buildGstUploadedState() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.08),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
        borderRadius: AppRadius.mdAll,
      ),
      child: Row(
        children: [
          Icon(LucideIcons.fileCheck, color: AppColors.success, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('GST_Certificate.pdf', style: AppTextStyles.label),
                const SizedBox(height: 2),
                Text('Uploaded', style: AppTextStyles.caption),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _gstUploaded = false),
            child: Icon(LucideIcons.x,
                size: 16, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioUploadZone() {
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() {
            if (_portfolioCount < 5) _portfolioCount++;
          }),
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppColors.bgGlassLight,
              border: Border.all(
                  color: AppColors.borderGlass, style: BorderStyle.solid),
              borderRadius: AppRadius.mdAll,
            ),
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: AppRadius.mdAll,
                  ),
                  child: Icon(LucideIcons.imagePlus,
                      color: AppColors.primary, size: 22),
                ),
                const SizedBox(height: 12),
                Text('Upload trip photos', style: AppTextStyles.label),
                const SizedBox(height: 4),
                Text('These appear on your agency profile',
                    style: AppTextStyles.caption),
              ],
            ),
          ),
        ),
        if (_portfolioCount > 0) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.bgGlassLight,
              border: Border.all(color: AppColors.borderSubtle),
              borderRadius: AppRadius.mdAll,
            ),
            child: Row(
              children: [
                Icon(LucideIcons.image,
                    color: AppColors.primary, size: 18),
                const SizedBox(width: 10),
                Text('$_portfolioCount / 5 photos selected',
                    style: AppTextStyles.label),
                const Spacer(),
                GestureDetector(
                  onTap: () => setState(() => _portfolioCount = 0),
                  child: Icon(LucideIcons.x,
                      size: 16, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // ── Step 3: Bank Details ──

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepTag(LucideIcons.landmark, 'Bank Details'),
        const SizedBox(height: 14),
        Text('Set up payouts', style: AppTextStyles.h3),
        const SizedBox(height: 6),
        Text(
          'No subscription fees. No listing fees. You only pay a small commission when we bring you a confirmed booking.',
          style: AppTextStyles.bodySmall,
        ),
        const SizedBox(height: 28),

        // Info callout
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            border:
                Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
            borderRadius: AppRadius.mdAll,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(LucideIcons.info, color: AppColors.primary, size: 18),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Zero listing fees. Zero subscription. SoleGoes only earns when you earn — a small commission per confirmed booking, settled via RBI-compliant infrastructure.',
                  style: AppTextStyles.labelSmall,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Account Holder Name
        _fieldLabel('Account Holder Name', required: true),
        const SizedBox(height: 8),
        AppTextField(
          controller: _accountHolderCtrl,
          hint: 'As on bank account',
          icon: LucideIcons.user,
        ),
        const SizedBox(height: 18),

        // Bank Name + IFSC (2-col)
        LayoutBuilder(
          builder: (ctx, box) => box.maxWidth > 500
              ? Row(
                  children: [
                    Expanded(child: _buildBankNameDropdown()),
                    const SizedBox(width: 16),
                    Expanded(child: _buildIfscField()),
                  ],
                )
              : Column(
                  children: [
                    _buildBankNameDropdown(),
                    const SizedBox(height: 18),
                    _buildIfscField(),
                  ],
                ),
        ),
        const SizedBox(height: 18),

        // Account Number
        _fieldLabel('Account Number', required: true),
        const SizedBox(height: 8),
        AppTextField(
          controller: _accountNumberCtrl,
          hint: 'Enter account number',
          icon: LucideIcons.creditCard,
          obscureText: _obscureAccountNumber,
          keyboardType: TextInputType.number,
          suffixIcon: GestureDetector(
            onTap: () => setState(
                () => _obscureAccountNumber = !_obscureAccountNumber),
            child: Icon(
              _obscureAccountNumber ? LucideIcons.eyeOff : LucideIcons.eye,
              size: 20,
              color: AppColors.textTertiary,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Stored encrypted — displayed as ••••1234 in your dashboard.',
          style: AppTextStyles.caption,
        ),
        const SizedBox(height: 24),

        // Terms agreement
        GestureDetector(
          onTap: () => setState(() => _agreedToTerms = !_agreedToTerms),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: AppDurations.fast,
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: _agreedToTerms
                      ? AppColors.primary
                      : Colors.transparent,
                  border: Border.all(
                    color: _agreedToTerms
                        ? AppColors.primary
                        : AppColors.borderGlass,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: _agreedToTerms
                    ? const Icon(LucideIcons.check,
                        size: 14, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: AppTextStyles.labelSmall,
                    children: [
                      const TextSpan(text: 'I agree to SoleGoes '),
                      TextSpan(
                        text: 'Agency Partner Terms',
                        style: AppTextStyles.labelSmall
                            .copyWith(color: AppColors.primary),
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: AppTextStyles.labelSmall
                            .copyWith(color: AppColors.primary),
                      ),
                      const TextSpan(
                        text:
                            '. Founding Partner applications are reviewed within 2–3 business days.',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBankNameDropdown() {
    const banks = [
      'State Bank of India',
      'HDFC Bank',
      'ICICI Bank',
      'Axis Bank',
      'Kotak Mahindra Bank',
      'Other',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('Bank Name', required: true),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _bankNameCtrl.text.isEmpty ? null : _bankNameCtrl.text,
          dropdownColor: AppColors.bgSurface,
          icon: const Icon(LucideIcons.chevronDown,
              size: 18, color: AppColors.textTertiary),
          style: AppTextStyles.body,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.bgGlassLight,
            border: OutlineInputBorder(
                borderRadius: AppRadius.mdAll,
                borderSide: BorderSide(color: AppColors.borderSubtle)),
            enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.mdAll,
                borderSide: BorderSide(color: AppColors.borderSubtle)),
            focusedBorder: OutlineInputBorder(
                borderRadius: AppRadius.mdAll,
                borderSide: const BorderSide(color: AppColors.primary)),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 14),
            hintText: 'Select bank',
            hintStyle: AppTextStyles.bodySmall,
          ),
          items: banks
              .map((b) => DropdownMenuItem(
                    value: b,
                    child: Text(b, style: AppTextStyles.body),
                  ))
              .toList(),
          onChanged: (v) => setState(() => _bankNameCtrl.text = v ?? ''),
        ),
      ],
    );
  }

  Widget _buildIfscField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('IFSC Code', required: true),
        const SizedBox(height: 8),
        AppTextField(
          controller: _ifscCtrl,
          hint: 'e.g. SBIN0001234',
          icon: LucideIcons.hash,
        ),
      ],
    );
  }

  // ─── Helpers ───

  Widget _stepTag(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        borderRadius: AppRadius.fullAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            label.toUpperCase(),
            style: AppTextStyles.overline
                .copyWith(color: AppColors.primary, letterSpacing: 0.5),
          ),
        ],
      ),
    );
  }

  Widget _fieldLabel(String label, {bool required = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: AppTextStyles.label),
        if (required) ...[
          const SizedBox(width: 4),
          Text(' *',
              style:
                  AppTextStyles.label.copyWith(color: AppColors.accentRose)),
        ],
      ],
    );
  }
}
