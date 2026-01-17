import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../theme/app_theme.dart';
import '../../authentication/data/auth_repository.dart';
import '../../bookings/data/booking_repository.dart';
import '../../bookings/domain/booking.dart' show Booking, BookingStatus, PaymentStatus, SelectedTripPoint;
import '../../payments/data/razorpay_service.dart';
import '../data/trip_repository.dart';
import '../domain/trip.dart';
import '../../../common_widgets/image_gallery_screen.dart';

/// Trip detail screen showing full trip information
/// Reference: designs/option15_trip_detail.html
class TripDetailScreen extends ConsumerStatefulWidget {
  final String tripId;

  const TripDetailScreen({super.key, required this.tripId});

  @override
  ConsumerState<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends ConsumerState<TripDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showHeader = false;
  int? _expandedDayIndex;

  // Razorpay integration
  late RazorpayService _razorpayService;
  bool _isProcessing = false;
  bool _hasNavigated = false; // Prevent duplicate navigation
  Trip? _currentTrip;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
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
      debugPrint('External wallet selected: ${response.walletName}');
    };
  }


  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // This handler is kept for backward compatibility but shouldn't be called
    // since we now use the booking screen flow
    debugPrint('Payment success: ${response.paymentId}');
    
    setState(() {
      _isProcessing = false;
    });
  }

  Future<void> _handlePaymentError(PaymentFailureResponse response) async {
    // Prevent duplicate handling
    if (_hasNavigated) return;

    final failureMessage = response.message ?? 'Payment failed';
    final errorCode = response.code?.toString() ?? 'unknown';

    try {
      final userAsync = ref.read(authStateChangesProvider);
      final user = userAsync.value;
      final trip = _currentTrip;

      if (user != null && trip != null) {
        final bookingRepo = ref.read(bookingRepositoryProvider);
        final booking = await bookingRepo.createBooking(
          tripId: trip.tripId,
          userId: user.uid,
          tripTitle: trip.title.replaceAll('\\n', ' '),
          tripImageUrl: trip.imageUrl,
          tripLocation: trip.location,
          tripDuration: trip.duration,
          amount: trip.price,
          paymentId: 'failed_${DateTime.now().millisecondsSinceEpoch}',
          paymentMethod: 'razorpay',
          status: BookingStatus.pending,
          paymentStatus: PaymentStatus.failed,
          failureReason: 'Error $errorCode: $failureMessage',
          userEmail: user.email,
          userName: user.displayName,
        );

        setState(() => _isProcessing = false);

        // Invalidate booking provider to refresh data
        ref.invalidate(userTripBookingProvider(trip.tripId, user.uid));

        // Navigate to confirmation showing failed status
        if (mounted && !_hasNavigated) {
          _hasNavigated = true;
          context.push('/payment-confirmation/${booking.bookingId}');
        }
        return;
      }
    } catch (e) {
      debugPrint('Error saving failed booking: $e');
    }

    setState(() => _isProcessing = false);

    // Fallback: show snackbar if couldn't save booking
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            failureMessage,
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
  }

  void _proceedToPay(Trip trip) {
    final userAsync = ref.read(authStateChangesProvider);
    final user = userAsync.value;

    if (user == null) {
      // Redirect to login
      context.push('/login');
      return;
    }

    // Navigate to booking screen
    context.push('/trip/${trip.tripId}/book');
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _razorpayService.dispose();
    super.dispose();
  }

  void _onScroll() {
    final showHeader = _scrollController.offset > 50;
    if (showHeader != _showHeader) {
      setState(() => _showHeader = showHeader);
    }
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
              child: Text('Trip not found', style: TextStyle(color: Colors.white)),
            );
          }
          return Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // Hero Image
                  _buildHeroSliver(trip),
                  // Content
                  SliverToBoxAdapter(
                    child: _buildContent(trip),
                  ),
                ],
              ),
              // Floating Header
              _buildFloatingHeader(trip),
              // Bottom CTA
              _buildBottomCTA(trip),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (_, __) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(LucideIcons.alertTriangle, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              const Text('Failed to load trip', style: TextStyle(color: Colors.white)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(tripProvider(widget.tripId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSliver(Trip trip) {
    return SliverAppBar(
      expandedHeight: 340,
      pinned: false,
      floating: false,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ImageGalleryScreen(
                  imageUrls: [trip.imageUrl],
                  initialIndex: 0,
                ),
              ),
            );
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Hero Image
              Image.network(
                trip.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.bgSurface,
                  child: const Icon(LucideIcons.image, color: AppColors.textTertiary, size: 60),
                ),
              ),
              // Gradient overlay - ignore pointer
              IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.shimmer,
                        AppColors.scrim,
                        AppColors.bgDeep,
                      ],
                      stops: const [0.0, 0.6, 1.0],
                    ),
                  ),
                ),
              ),
              // Content overlay - ignore pointer
              Positioned(
                bottom: 24,
                left: 16,
                right: 16,
                child: IgnorePointer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Trending badge
                      if (trip.isTrending)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSelected,
                            borderRadius: BorderRadius.circular(AppRadius.full),
                            border: Border.all(color: AppColors.shimmer),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF4ADE80),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Filling Fast',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 12),
                      // Title
                      Text(
                        trip.title.replaceAll('\\n', '\n'),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Location & Duration
                      Row(
                        children: [
                          Icon(LucideIcons.mapPin, size: 16, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text(
                            trip.location,
                            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                          ),
                          const SizedBox(width: 16),
                          Icon(LucideIcons.calendar, size: 16, color: const Color(0xFFEC4899)),
                          const SizedBox(width: 4),
                          Text(
                            '${trip.duration} Days',
                            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingHeader(Trip trip) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 200),
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 8,
          left: 16,
          right: 16,
          bottom: 8,
        ),
        decoration: BoxDecoration(
          color: _showHeader ? AppColors.scrim : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: _showHeader ? AppColors.borderGlass : Colors.transparent,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Back button
            GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.iconMuted,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.surfacePressed),
                ),
                child: const Icon(LucideIcons.arrowLeft, size: 20, color: Colors.white),
              ),
            ),
            // Title (only when scrolled)
            if (_showHeader)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    trip.title.replaceAll('\\n', ' '),
                    style: const AppTextStyles.h5.copyWith(color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            // Action buttons
            Row(
              children: [
                _buildHeaderButton(LucideIcons.share2),
                const SizedBox(width: 12),
                _buildHeaderButton(LucideIcons.heart),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderButton(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.iconMuted,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.surfacePressed),
      ),
      child: Icon(icon, size: 20, color: Colors.white),
    );
  }

  Widget _buildContent(Trip trip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 180),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Stats
          _buildQuickStats(trip),
          const SizedBox(height: 24),

          // Who's Going
          _buildWhosGoing(trip),
          const SizedBox(height: 32),

          // Description
          _buildDescription(trip),
          const SizedBox(height: 32),

          // Itinerary
          _buildItinerary(trip),
          const SizedBox(height: 32),

          // Gallery
          if (trip.imageUrls.length > 1) ...[
            _buildGallery(trip),
            const SizedBox(height: 32),
          ],

          // Inclusions
          _buildInclusions(trip),
          const SizedBox(height: 32),

          // Host Info
          _buildHostInfo(trip),
          const SizedBox(height: 32),

          // Location
          _buildLocationSection(trip),
          const SizedBox(height: 32),

          // Cancellation Policy
          _buildCancellationPolicy(),
        ],
      ),
    );
  }

  Widget _buildQuickStats(Trip trip) {
    // Extract spots number from groupSize string like "Group of 12"
    final spotsMatch = RegExp(r'\d+').firstMatch(trip.groupSize);
    final spots = spotsMatch?.group(0) ?? '12';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceHover,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.borderGlass),
        ),
        child: Row(
          children: [
            // Rating
            Expanded(
              child: Column(
                children: [
                  Text(
                    trip.rating.toString(),
                    style: const AppTextStyles.h2.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rating',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: AppColors.surfacePressed,
            ),
            // Spots
            Expanded(
              child: Column(
                children: [
                  Text(
                    spots,
                    style: const AppTextStyles.h2.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Spots',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: AppColors.surfacePressed,
            ),
            // Level
            Expanded(
              child: Column(
                children: [
                  const Text(
                    'Easy',
                    style: AppTextStyles.h2.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Level',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWhosGoing(Trip trip) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Who's Going",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.2,
                ),
              ),
              Text(
                'See All',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceHover,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.borderGlass),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Avatar stack
                SizedBox(
                  width: 140,
                  height: 40,
                  child: Stack(
                    children: List.generate(4, (index) {
                      return Positioned(
                        left: index * 28.0,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.bgDeep, width: 2),
                            image: DecorationImage(
                              image: NetworkImage('https://i.pravatar.cc/150?img=${index + 1}'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    })..add(
                      Positioned(
                        left: 4 * 28.0,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.surfacePressed,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.bgDeep, width: 2),
                          ),
                          child: const Center(
                            child: Text(
                              '+8',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Join Chat button
                GestureDetector(
                  onTap: () {
                    // TODO: Navigate to trip chat
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceOverlay,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      border: Border.all(color: AppColors.borderGlass),
                    ),
                    child: const Text(
                      'Join Chat',
                      style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(Trip trip) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About This Trip',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            trip.description,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItinerary(Trip trip) {
    if (trip.itinerary.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Itinerary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 16),
          ...trip.itinerary.asMap().entries.map((entry) {
            final index = entry.key;
            final day = entry.value;
            final isExpanded = _expandedDayIndex == index;

            // Colors for day badges
            final colors = [
              const Color(0xFFA855F7), // Purple
              const Color(0xFFEC4899), // Pink
              const Color(0xFF06B6D4), // Cyan
              const Color(0xFF22C55E), // Green
              const Color(0xFFF59E0B), // Amber
              const Color(0xFF3B82F6), // Blue
              const Color(0xFFEF4444), // Red
            ];
            final dayColor = colors[index % colors.length];

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _expandedDayIndex = isExpanded ? null : index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHover,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderGlass),
                  ),
                  child: Column(
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: dayColor.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  (day['day'] ?? index + 1).toString().padLeft(2, '0'),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: dayColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                day['title'] ?? 'Day ${index + 1}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                            AnimatedRotation(
                              duration: const Duration(milliseconds: 200),
                              turns: isExpanded ? 0.5 : 0,
                              child: Icon(
                                LucideIcons.chevronDown,
                                size: 20,
                                color: AppColors.textHint,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Expandable content
                      AnimatedCrossFade(
                        duration: const Duration(milliseconds: 200),
                        crossFadeState: isExpanded
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        firstChild: const SizedBox.shrink(),
                        secondChild: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceOverlay,
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(AppRadius.lg),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(color: AppColors.borderGlass),
                              const SizedBox(height: 8),
                              Text(
                                day['description'] ?? '',
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.6,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              if (day['activities'] != null) ...[
                                const SizedBox(height: 16),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: (day['activities'] as List<dynamic>).map((activity) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceHover,
                                        borderRadius: BorderRadius.circular(AppRadius.full),
                                      ),
                                      child: Text(
                                        activity.toString(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                              if (day['meals'] != null) ...[
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(LucideIcons.utensils, size: 14, color: AppColors.textMuted),
                                    const SizedBox(width: 8),
                                    Text(
                                      day['meals'].toString(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildGallery(Trip trip) {
    // Use additional sample images for the gallery grid
    final galleryImages = [
      // First image is for video thumbnail (large)
      'https://images.unsplash.com/photo-1518548419970-58e3b4079ab2?w=800&q=80',
      // Grid images
      ...trip.imageUrls,
      // Add more sample images if needed
      'https://images.unsplash.com/photo-1559628376-f3fe5f782a2e?w=600&q=80',
      'https://images.unsplash.com/photo-1573790387438-4da905039392?w=600&q=80',
      'https://images.unsplash.com/photo-1552733407-5d5c46c3bb3b?w=600&q=80',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Vibes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 16),
          // Large video/image at top (spanning full width)
          GestureDetector(
            onTap: () {
              // TODO: Open video player
            },
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.borderGlass),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    child: Image.network(
                      galleryImages[0],
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.bgSurface,
                        child: const Icon(LucideIcons.image, color: AppColors.textTertiary, size: 40),
                      ),
                    ),
                  ),
                  // Play button overlay
                  Center(
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.shimmer,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.iconMuted),
                      ),
                      child: const Icon(
                        LucideIcons.play,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // Watch Experience label
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.scrim,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.surfacePressed),
                      ),
                      child: const Text(
                        'Watch Experience',
                        style: AppTextStyles.labelSmall.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // 2x2 Grid of images
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildGalleryImage(galleryImages.length > 1 ? galleryImages[1] : galleryImages[0], 1, galleryImages),
                    const SizedBox(height: 12),
                    _buildGalleryImage(galleryImages.length > 3 ? galleryImages[3] : galleryImages[0], 3, galleryImages),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: [
                    _buildGalleryImage(galleryImages.length > 2 ? galleryImages[2] : galleryImages[0], 2, galleryImages),
                    const SizedBox(height: 12),
                    _buildGalleryImage(galleryImages.length > 4 ? galleryImages[4] : galleryImages[0], 4, galleryImages),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryImage(String imageUrl, int index, List<String> allImages) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ImageGalleryScreen(
              imageUrls: allImages,
              initialIndex: index,
            ),
          ),
        );
      },
      child: AspectRatio(
        aspectRatio: 4 / 5,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: AppColors.bgSurface,
              child: const Icon(LucideIcons.image, color: AppColors.textTertiary),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInclusions(Trip trip) {
    if (trip.inclusions.isEmpty) return const SizedBox.shrink();

    final icons = [
      LucideIcons.bed,
      LucideIcons.utensils,
      LucideIcons.bus,
      LucideIcons.camera,
      LucideIcons.shield,
      LucideIcons.ticket,
      LucideIcons.sparkles,
    ];

    final iconColors = [
      const Color(0xFF22C55E),
      const Color(0xFFF59E0B),
      const Color(0xFF3B82F6),
      const Color(0xFFEC4899),
      const Color(0xFF06B6D4),
      const Color(0xFFA855F7),
      const Color(0xFFEF4444),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "What's Included",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceHover,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.borderGlass),
            ),
            child: Column(
              children: [
                for (int i = 0; i < trip.inclusions.length; i += 2)
                  Padding(
                    padding: EdgeInsets.only(bottom: i + 2 < trip.inclusions.length ? 16 : 0),
                    child: Row(
                      children: [
                        // First item in row
                        Expanded(
                          child: _buildInclusionItem(
                            trip.inclusions[i],
                            icons[i % icons.length],
                            iconColors[i % iconColors.length],
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Second item in row (if exists)
                        Expanded(
                          child: i + 1 < trip.inclusions.length
                              ? _buildInclusionItem(
                                  trip.inclusions[i + 1],
                                  icons[(i + 1) % icons.length],
                                  iconColors[(i + 1) % iconColors.length],
                                )
                              : const SizedBox.shrink(),
                        ),
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

  Widget _buildInclusionItem(String text, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.labelMedium.copyWith(color: AppColors.textPrimary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }


  Widget _buildHostInfo(Trip trip) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Meet Your Host',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surfaceHover,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.borderGlass),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.borderGlass, width: 2),
                        image: const DecorationImage(
                          image: NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&q=80'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trip.agencyName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              if (trip.isVerifiedAgency) ...[
                                const Icon(LucideIcons.shieldCheck, size: 12, color: Color(0xFF22C55E)),
                                const SizedBox(width: 4),
                                const Text(
                                  'Verified Agency',
                                  style: AppTextStyles.labelSmall.copyWith(color: const Color(0xFF22C55E)),
                                ),
                                const SizedBox(width: 8),
                              ],
                              Text(
                                '${trip.rating} Rating',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'We specialize in curating immersive travel experiences for solo travelers. Our guides are locals who know the hidden gems.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceOverlay,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    border: Border.all(color: AppColors.borderGlass),
                  ),
                  child: const Center(
                    child: Text(
                      'Contact Host',
                      style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection(Trip trip) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Location',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.borderGlass),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  child: Image.network(
                    trip.imageUrl,
                    fit: BoxFit.cover,
                    colorBlendMode: BlendMode.saturation,
                    color: Colors.grey,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.iconMuted,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                ),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.scrim,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      border: Border.all(color: AppColors.shimmer),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(LucideIcons.map, size: 16, color: AppColors.textPrimary),
                        const SizedBox(width: 8),
                        const Text(
                          'View on Map',
                          style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(LucideIcons.mapPin, size: 14, color: AppColors.textHint),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${trip.location} (Exact location provided after booking)',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCancellationPolicy() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceHover,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.borderGlass),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(LucideIcons.info, size: 16, color: Color(0xFF3B82F6)),
                const SizedBox(width: 8),
                Text(
                  'Cancellation Policy',
                  style: AppTextStyles.labelLarge.copyWith(color: AppColors.textPrimary),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Free cancellation up to 14 days before the trip start date. 50% refund up to 7 days before. No refund within 7 days.',
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomCTA(Trip trip) {
    // Format price with Indian numbering (lakhs)
    String formatPrice(double price) {
      final priceInt = price.toInt();
      if (priceInt >= 1000) {
        return '₹${(priceInt / 1000).toStringAsFixed(0)}k';
      }
      return '₹$priceInt';
    }

    // Check if user has already booked this trip
    final userAsync = ref.watch(authStateChangesProvider);
    final user = userAsync.value;

    // Only check booking if user is logged in
    final existingBookingAsync = user != null
        ? ref.watch(userTripBookingProvider(trip.tripId, user.uid))
        : const AsyncValue<Booking?>.data(null);

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).padding.bottom + 16,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF050505).withValues(alpha: 0.85),
              border: const Border(
                top: BorderSide(color: AppColors.borderGlass),
              ),
            ),
            child: existingBookingAsync.when(
              data: (existingBooking) {
                // If already booked, show "Already Booked" button
                if (existingBooking != null) {
                  return _buildAlreadyBookedCTA(existingBooking);
                }
                // Show Book Now button
                return _buildBookNowCTA(trip, formatPrice);
              },
              loading: () => _buildBookNowCTA(trip, formatPrice),
              error: (_, __) => _buildBookNowCTA(trip, formatPrice),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlreadyBookedCTA(Booking booking) {
    return Row(
      children: [
        // Booking status - Expanded to take remaining space
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: booking.status == BookingStatus.confirmed
                          ? const Color(0xFF22C55E)
                          : const Color(0xFFEAB308),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      booking.status == BookingStatus.confirmed
                          ? 'Booking Confirmed'
                          : 'Booking Pending',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: booking.status == BookingStatus.confirmed
                            ? const Color(0xFF22C55E)
                            : const Color(0xFFEAB308),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'You have already booked this trip',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textMuted,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // View Booking button
        GestureDetector(
          onTap: () => context.push('/payment-confirmation/${booking.bookingId}'),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surfacePressed,
              borderRadius: BorderRadius.circular(AppRadius.full),
              border: Border.all(color: AppColors.borderGlass),
            ),
            child: const Text(
              'View Booking',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBookNowCTA(Trip trip, String Function(double) formatPrice) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Price section
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Total Price',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '₹${trip.price.toStringAsFixed(0).replaceAllMapped(
                        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                        (Match m) => '${m[1]},',
                      )}',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  formatPrice(trip.price * 1.2),
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textHint,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
          ],
        ),
        // Book Now button
        GestureDetector(
          onTap: _isProcessing ? null : () => _proceedToPay(trip),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Processing...',
                        style: AppTextStyles.h5.copyWith(color: Colors.white),
                      ),
                    ],
                  )
                : const Text(
                    'Book Now',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
