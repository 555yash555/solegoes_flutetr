import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../theme/app_theme.dart';
import '../../authentication/data/auth_repository.dart';
import '../../bookings/data/booking_repository.dart';
import '../../trips/data/trip_repository.dart';
import '../../trips/domain/trip.dart';
import '../data/razorpay_service.dart';

/// Payment method data model
class PaymentMethod {
  final String id;
  final String name;
  final IconData icon;
  final String category;

  const PaymentMethod({
    required this.id,
    required this.name,
    required this.icon,
    required this.category,
  });
}

/// Payment method selection screen
/// Reference: designs/option15_payment_method.html
class PaymentMethodScreen extends ConsumerStatefulWidget {
  final String tripId;

  const PaymentMethodScreen({
    super.key,
    required this.tripId,
  });

  @override
  ConsumerState<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends ConsumerState<PaymentMethodScreen> {
  String _selectedMethodId = 'credit_card';
  late RazorpayService _razorpayService;
  bool _isProcessing = false;

  // Store trip details for payment and booking
  Trip? _currentTrip;

  final List<PaymentMethod> _cardsAndUpi = const [
    PaymentMethod(
      id: 'credit_card',
      name: 'Credit/Debit Card',
      icon: LucideIcons.creditCard,
      category: 'cards_upi',
    ),
    PaymentMethod(
      id: 'upi',
      name: 'UPI',
      icon: LucideIcons.smartphone,
      category: 'cards_upi',
    ),
  ];

  final List<PaymentMethod> _wallets = const [
    PaymentMethod(
      id: 'paytm',
      name: 'Paytm',
      icon: LucideIcons.wallet,
      category: 'wallets',
    ),
    PaymentMethod(
      id: 'phonepe',
      name: 'PhonePe',
      icon: LucideIcons.wallet,
      category: 'wallets',
    ),
    PaymentMethod(
      id: 'gpay',
      name: 'Google Pay',
      icon: LucideIcons.wallet,
      category: 'wallets',
    ),
  ];

  final List<PaymentMethod> _banking = const [
    PaymentMethod(
      id: 'netbanking',
      name: 'Net Banking',
      icon: LucideIcons.landmark,
      category: 'banking',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initRazorpay();
  }

  void _initRazorpay() {
    _razorpayService = RazorpayService();

    _razorpayService.onPaymentSuccess = (PaymentSuccessResponse response) {
      _handlePaymentSuccess(response);
    };

    _razorpayService.onPaymentError = (PaymentFailureResponse response) {
      _handlePaymentError(response);
    };

    _razorpayService.onExternalWallet = (ExternalWalletResponse response) {
      _handleExternalWallet(response);
    };
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final paymentId = response.paymentId ?? 'pay_${DateTime.now().millisecondsSinceEpoch}';

    // Save booking to Firebase
    try {
      final userAsync = ref.read(authStateChangesProvider);
      final user = userAsync.value;
      final trip = _currentTrip;

      if (user != null && trip != null) {
        final bookingRepo = ref.read(bookingRepositoryProvider);
        final booking = await bookingRepo.createBooking(
          tripId: trip.tripId,
          userId: user.uid,
          tripTitle: trip.title.replaceAll('\n', ' '),
          tripImageUrl: trip.imageUrl,
          tripLocation: trip.location,
          tripDuration: trip.duration,
          amount: trip.price,
          paymentId: paymentId,
          paymentMethod: _selectedMethodId,
          userEmail: user.email,
          userName: user.displayName,
        );

        setState(() => _isProcessing = false);

        // Navigate to confirmation with booking ID
        if (mounted) {
          context.push('/payment-confirmation/${booking.bookingId}');
        }
      } else {
        // Fallback if user/trip not found
        setState(() => _isProcessing = false);
        if (mounted) {
          context.push('/payment-confirmation/$paymentId');
        }
      }
    } catch (e) {
      debugPrint('Error saving booking: $e');
      setState(() => _isProcessing = false);
      // Still navigate to confirmation even if saving fails
      if (mounted) {
        context.push('/payment-confirmation/$paymentId');
      }
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() => _isProcessing = false);

    // Show error snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          response.message ?? 'Payment failed. Please try again.',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.accentRose,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // External wallet selected (like Paytm, PhonePe)
    debugPrint('External wallet selected: ${response.walletName}');
  }

  @override
  void dispose() {
    _razorpayService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tripAsync = ref.watch(tripProvider(widget.tripId));

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: tripAsync.when(
        data: (trip) {
          if (trip == null) {
            return const Center(
              child: Text(
                'Trip not found',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }

          // Store trip details for payment
          _currentTrip = trip;

          return Stack(
            children: [
              // Content
              CustomScrollView(
                slivers: [
                  // Header
                  SliverToBoxAdapter(
                    child: _buildHeader(context),
                  ),
                  // Payment options
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Select Payment Method',
                            style: AppTextStyles.h2.copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          // Razorpay test mode indicator
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.amber.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  LucideIcons.testTube,
                                  size: 14,
                                  color: Colors.amber.shade300,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Test Mode - Use test cards',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.amber.shade300,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Cards & UPI section
                          _buildSectionTitle('Cards & UPI'),
                          const SizedBox(height: 12),
                          ..._cardsAndUpi.map((method) => _buildPaymentOption(method)),

                          const SizedBox(height: 24),

                          // Wallets section
                          _buildSectionTitle('Wallets'),
                          const SizedBox(height: 12),
                          ..._wallets.map((method) => _buildPaymentOption(method)),

                          const SizedBox(height: 24),

                          // Banking section
                          _buildSectionTitle('Banking'),
                          const SizedBox(height: 12),
                          ..._banking.map((method) => _buildPaymentOption(method)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Bottom CTA
              _buildBottomCTA(trip.price),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (_, __) => const Center(
          child: Text(
            'Failed to load trip',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 16,
      ),
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
          const Expanded(
            child: Text(
              'Payment Method',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 40), // Spacer for alignment
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.textHint,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildPaymentOption(PaymentMethod method) {
    final isSelected = _selectedMethodId == method.id;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMethodId = method.id;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.surfaceOverlay,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderSubtle,
          ),
        ),
        child: Row(
          children: [
            // Icon
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.surfaceHover,
                shape: BoxShape.circle,
              ),
              child: Icon(
                method.icon,
                size: 20,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 16),
            // Name
            Expanded(
              child: Text(
                method.name,
                style: AppTextStyles.h5.copyWith(color: Colors.white),
              ),
            ),
            // Radio
            _buildRadio(isSelected),
          ],
        ),
      ),
    );
  }

  Widget _buildRadio(bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.textTertiary,
          width: 2,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildBottomCTA(double price) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).padding.bottom + 16,
        ),
        decoration: BoxDecoration(
          color: AppColors.bgDeep,
          border: const Border(
            top: BorderSide(color: AppColors.borderGlass),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Total amount row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Amount',
                  style: AppTextStyles.labelLarge.copyWith(color: AppColors.textMuted),
                ),
                Text(
                  '₹${price.toStringAsFixed(0).replaceAllMapped(
                        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                        (Match m) => '${m[1]},',
                      )}',
                  style: AppTextStyles.h2.copyWith(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Proceed button
            GestureDetector(
              onTap: _isProcessing ? null : _proceedToPay,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: _isProcessing ? null : AppColors.primaryGradient,
                  color: _isProcessing ? AppColors.bgSurface : null,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  boxShadow: _isProcessing
                      ? null
                      : [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                ),
                child: _isProcessing
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Processing...',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    : const Text(
                        'Proceed to Pay',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _proceedToPay() {
    setState(() => _isProcessing = true);

    final trip = _currentTrip;
    if (trip == null) {
      setState(() => _isProcessing = false);
      return;
    }

    // Get user email from auth provider
    final userAsync = ref.read(authStateChangesProvider);
    final user = userAsync.value;
    final userEmail = user?.email ?? 'test@example.com';
    final userPhone = user?.phoneNumber;

    // Open Razorpay checkout
    _razorpayService.openCheckout(
      amount: trip.price,
      tripTitle: trip.title.replaceAll('\n', ' '),
      userEmail: userEmail,
      userPhone: userPhone,
    );
  }
}
