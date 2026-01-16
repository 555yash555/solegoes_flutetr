import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../theme/app_theme.dart';
import '../../trips/domain/trip.dart';
import '../../trips/data/trip_repository.dart';
import '../../payments/data/razorpay_service.dart';
import '../../authentication/data/auth_repository.dart';
import '../data/booking_repository.dart';
import '../domain/booking.dart';

/// Booking screen where users select style, boarding/dropping points
/// All steps are optional - adapts based on what the trip offers
class TripBookingScreen extends ConsumerStatefulWidget {
  final String tripId;

  const TripBookingScreen({
    super.key,
    required this.tripId,
  });

  @override
  ConsumerState<TripBookingScreen> createState() => _TripBookingScreenState();
}

class _TripBookingScreenState extends ConsumerState<TripBookingScreen> {
  int _currentStep = 0;
  String? _selectedStyleId;
  TripPoint? _selectedBoardingPoint;
  TripPoint? _selectedDroppingPoint;
  
  late RazorpayService _razorpayService;
  bool _isProcessing = false;
  Trip? _currentTrip;
  
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
      debugPrint('External wallet: ${response.walletName}');
    };
  }
  
  @override
  void dispose() {
    _razorpayService.dispose();
    super.dispose();
  }
  
  // Determine which steps are available
  List<int> _getAvailableSteps(Trip trip) {
    final steps = <int>[];
    
    // Step 0: Style selection (only if pricing styles exist)
    if (trip.pricingStyles.isNotEmpty) {
      steps.add(0);
    }
    
    // Step 1: Boarding point (only if boarding points exist)
    if (trip.boardingPoints.isNotEmpty) {
      steps.add(1);
    }
    
    // Step 2: Dropping point (only if dropping points exist)
    if (trip.droppingPoints.isNotEmpty) {
      steps.add(2);
    }
    
    // Step 3: Review (always shown)
    steps.add(3);
    
    return steps;
  }
  
  int _getActualStepIndex(Trip trip) {
    final availableSteps = _getAvailableSteps(trip);
    return availableSteps.indexOf(_currentStep);
  }
  
  int _getTotalSteps(Trip trip) {
    return _getAvailableSteps(trip).length;
  }

  @override
  Widget build(BuildContext context) {
    final tripAsync = ref.watch(tripProvider(widget.tripId));

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      appBar: AppBar(
        title: const Text('Book Your Trip'),
        backgroundColor: AppColors.bgDeep,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft),
          onPressed: () => context.pop(),
        ),
      ),
      body: tripAsync.when(
        data: (trip) {
          if (trip == null) {
            return const Center(child: Text('Trip not found'));
          }
          
          // If no customization needed, go straight to payment
          final availableSteps = _getAvailableSteps(trip);
          if (availableSteps.length == 1 && availableSteps.first == 3) {
            // Only review step - skip to payment immediately
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _navigateToPayment(trip);
            });
            return const Center(child: CircularProgressIndicator());
          }
          
          return _buildBookingFlow(trip);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildBookingFlow(Trip trip) {
    final availableSteps = _getAvailableSteps(trip);
    
    return Column(
      children: [
        // Progress indicator (only if there are steps to show)
        if (availableSteps.length > 1)
          _buildProgressIndicator(trip),
        
        // Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: _buildCurrentStep(trip),
          ),
        ),
        
        // Bottom action buttons
        _buildBottomActions(trip),
      ],
    );
  }

  Widget _buildProgressIndicator(Trip trip) {
    final availableSteps = _getAvailableSteps(trip);
    final currentIndex = _getActualStepIndex(trip);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        border: Border(
          bottom: BorderSide(color: AppColors.borderSubtle),
        ),
      ),
      child: Row(
        children: [
          for (int i = 0; i < availableSteps.length; i++) ...[
            if (i > 0) _buildStepConnector(i <= currentIndex),
            _buildStepIndicator(
              _getStepLabel(availableSteps[i]),
              _getStepIcon(availableSteps[i]),
              isActive: i == currentIndex,
              isCompleted: i < currentIndex,
            ),
          ],
        ],
      ),
    );
  }

  String _getStepLabel(int step) {
    switch (step) {
      case 0: return 'Style';
      case 1: return 'Pickup';
      case 2: return 'Drop';
      case 3: return 'Review';
      default: return '';
    }
  }

  IconData _getStepIcon(int step) {
    switch (step) {
      case 0: return LucideIcons.sparkles;
      case 1: return LucideIcons.mapPin;
      case 2: return LucideIcons.mapPinOff;
      case 3: return LucideIcons.checkCircle;
      default: return LucideIcons.circle;
    }
  }

  Widget _buildStepIndicator(String label, IconData icon, {required bool isActive, required bool isCompleted}) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isCompleted
                ? AppColors.primary
                : isActive
                    ? AppColors.primary.withValues(alpha: 0.2)
                    : AppColors.surfaceHover,
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive || isCompleted
                  ? AppColors.primary
                  : AppColors.borderSubtle,
              width: 2,
            ),
          ),
          child: Icon(
            isCompleted ? LucideIcons.check : icon,
            size: 20,
            color: isCompleted || isActive
                ? Colors.white
                : AppColors.textTertiary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive ? AppColors.primary : AppColors.textTertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildStepConnector(bool isCompleted) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 20),
        color: isCompleted ? AppColors.primary : AppColors.borderSubtle,
      ),
    );
  }

  Widget _buildCurrentStep(Trip trip) {
    switch (_currentStep) {
      case 0:
        return _buildStyleSelection(trip);
      case 1:
        return _buildBoardingPointSelection(trip);
      case 2:
        return _buildDroppingPointSelection(trip);
      case 3:
        return _buildReviewStep(trip);
      default:
        return const SizedBox();
    }
  }

  // Step 0: Style Selection
  Widget _buildStyleSelection(Trip trip) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Your Style',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Select the package that suits your preferences',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        ...trip.pricingStyles.map((style) => _buildStyleCard(style)),
      ],
    );
  }

  Widget _buildStyleCard(TripStyle style) {
    final isSelected = _selectedStyleId == style.styleId;

    return GestureDetector(
      onTap: () => setState(() => _selectedStyleId = style.styleId),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.bgSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderSubtle,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        style.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        style.description,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${style.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      'per person',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Accommodation & Meal tags
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildTag(_getAccommodationLabel(style.accommodationType), LucideIcons.bed),
                ...style.mealOptions.map((meal) => _buildTag(meal, LucideIcons.utensils)),
              ],
            ),
            const SizedBox(height: 16),
            // Inclusions
            ...style.inclusions.take(3).map((inclusion) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Icon(
                        LucideIcons.checkCircle2,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          inclusion,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            if (style.inclusions.length > 3)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '+${style.inclusions.length - 3} more',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceHover,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _getAccommodationLabel(String type) {
    switch (type) {
      case 'sharing-3':
        return '3-Sharing';
      case 'sharing-2':
        return '2-Sharing';
      case 'private':
        return 'Private Room';
      default:
        return type;
    }
  }

  // Step 1: Boarding Point Selection
  Widget _buildBoardingPointSelection(Trip trip) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Boarding Point',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Choose where you\'ll join the trip',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        ...trip.boardingPoints.map((point) => _buildPointCard(
              point,
              isSelected: _selectedBoardingPoint == point,
              onTap: () => setState(() => _selectedBoardingPoint = point),
            )),
      ],
    );
  }

  // Step 2: Dropping Point Selection
  Widget _buildDroppingPointSelection(Trip trip) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Dropping Point',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Choose where you\'ll end the trip',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        ...trip.droppingPoints.map((point) => _buildPointCard(
              point,
              isSelected: _selectedDroppingPoint == point,
              onTap: () => setState(() => _selectedDroppingPoint = point),
            )),
      ],
    );
  }

  Widget _buildPointCard(TripPoint point, {required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.bgSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderSubtle,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.surfaceHover,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                LucideIcons.mapPin,
                size: 20,
                color: isSelected ? Colors.white : AppColors.textTertiary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    point.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    point.address,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDateTime(point.dateTime),
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                LucideIcons.checkCircle2,
                color: AppColors.primary,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  // Step 3: Review
  Widget _buildReviewStep(Trip trip) {
    final selectedStyle = trip.pricingStyles.isNotEmpty && _selectedStyleId != null
        ? trip.pricingStyles.firstWhere(
            (s) => s.styleId == _selectedStyleId,
            orElse: () => trip.pricingStyles.first,
          )
        : null;
    
    final price = selectedStyle?.price ?? trip.price;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Review Your Booking',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 24),
        
        // Trip Info
        _buildReviewSection(
          'Trip Details',
          [
            _buildReviewRow('Destination', trip.title),
            _buildReviewRow('Duration', '${trip.duration} Days'),
            if (selectedStyle != null)
              _buildReviewRow('Package', selectedStyle.name),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Journey Details (only if points are selected)
        if (_selectedBoardingPoint != null || _selectedDroppingPoint != null)
          ...[
            _buildReviewSection(
              'Journey Details',
              [
                if (_selectedBoardingPoint != null)
                  _buildReviewRow('Boarding', _selectedBoardingPoint!.name),
                if (_selectedDroppingPoint != null)
                  _buildReviewRow('Dropping', _selectedDroppingPoint!.name),
              ],
            ),
            const SizedBox(height: 16),
          ],
        
        // Price Breakdown
        _buildReviewSection(
          'Price Breakdown',
          [
            _buildReviewRow('Base Price', '₹${price.toStringAsFixed(0)}'),
            _buildReviewRow('Taxes & Fees', '₹0', isSubdued: true),
            const Divider(color: AppColors.borderSubtle, height: 24),
            _buildReviewRow(
              'Total Amount',
              '₹${price.toStringAsFixed(0)}',
              isBold: true,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReviewSection(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildReviewRow(String label, String value, {bool isBold = false, bool isSubdued = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: isSubdued ? AppColors.textTertiary : AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: isBold ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(Trip trip) {
    final canProceed = _canProceedToNextStep(trip);
    final availableSteps = _getAvailableSteps(trip);
    final currentIndex = _getActualStepIndex(trip);
    final isLastStep = currentIndex == availableSteps.length - 1;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        border: Border(
          top: BorderSide(color: AppColors.borderSubtle),
        ),
      ),
      child: Row(
        children: [
          if (currentIndex > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _currentStep = availableSteps[currentIndex - 1];
                  });
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: AppColors.borderSubtle),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Back'),
              ),
            ),
          if (currentIndex > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: canProceed ? () => _handleNextStep(trip) : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                isLastStep ? 'Proceed to Payment' : 'Continue',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _canProceedToNextStep(Trip trip) {
    switch (_currentStep) {
      case 0:
        return _selectedStyleId != null;
      case 1:
        return _selectedBoardingPoint != null;
      case 2:
        return _selectedDroppingPoint != null;
      case 3:
        return true;
      default:
        return false;
    }
  }

  void _handleNextStep(Trip trip) {
    final availableSteps = _getAvailableSteps(trip);
    final currentIndex = _getActualStepIndex(trip);
    
    if (currentIndex < availableSteps.length - 1) {
      // Move to next available step
      setState(() {
        _currentStep = availableSteps[currentIndex + 1];
      });
    } else {
      // Last step - navigate to payment
      _navigateToPayment(trip);
    }
  }
  
  void _navigateToPayment(Trip trip) {
    final userAsync = ref.read(authStateChangesProvider);
    final user = userAsync.value;
    
    if (user == null) {
      context.push('/login');
      return;
    }
    
    final selectedStyle = trip.pricingStyles.isNotEmpty && _selectedStyleId != null
        ? trip.pricingStyles.firstWhere((s) => s.styleId == _selectedStyleId)
        : null;
    
    final price = selectedStyle?.price ?? trip.price;
    
    setState(() {
      _isProcessing = true;
      _currentTrip = trip;
    });
    
    // Open Razorpay payment
    _razorpayService.openCheckout(
      amount: price,
      tripTitle: trip.title.replaceAll('\n', ' ').trim(),
      userEmail: user.email ?? 'guest@solegoes.com',
      userPhone: user.phoneNumber,
    );
  }
  
  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final paymentId = response.paymentId ?? 'pay_${DateTime.now().millisecondsSinceEpoch}';
    
    try {
      final userAsync = ref.read(authStateChangesProvider);
      final user = userAsync.value;
      final trip = _currentTrip;
      
      if (user != null && trip != null) {
        final bookingRepo = ref.read(bookingRepositoryProvider);
        
        final selectedStyle = trip.pricingStyles.isNotEmpty && _selectedStyleId != null
            ? trip.pricingStyles.firstWhere((s) => s.styleId == _selectedStyleId)
            : null;
        
        final price = selectedStyle?.price ?? trip.price;
        
        // Convert TripPoint to SelectedTripPoint
        SelectedTripPoint? boardingPoint;
        if (_selectedBoardingPoint != null) {
          boardingPoint = SelectedTripPoint(
            name: _selectedBoardingPoint!.name,
            address: _selectedBoardingPoint!.address,
            dateTime: _selectedBoardingPoint!.dateTime,
          );
        }
        
        SelectedTripPoint? droppingPoint;
        if (_selectedDroppingPoint != null) {
          droppingPoint = SelectedTripPoint(
            name: _selectedDroppingPoint!.name,
            address: _selectedDroppingPoint!.address,
            dateTime: _selectedDroppingPoint!.dateTime,
          );
        }
        
        // Create booking
        final booking = await bookingRepo.createBooking(
          tripId: trip.tripId,
          userId: user.uid,
          tripTitle: trip.title,
          tripImageUrl: trip.imageUrl,
          tripLocation: trip.location,
          tripDuration: trip.duration,
          amount: price,
          paymentId: paymentId,
          paymentMethod: 'razorpay',
          userEmail: user.email,
          userName: user.displayName,
          selectedStyleId: selectedStyle?.styleId,
          selectedStyleName: selectedStyle?.name,
          selectedBoardingPoint: boardingPoint,
          selectedDroppingPoint: droppingPoint,
        );
        
        setState(() => _isProcessing = false);
        
        if (mounted) {
          // Navigate to confirmation
          context.go('/payment-confirmation/${booking.bookingId}');
        }
      }
    } catch (e) {
      debugPrint('Error creating booking: $e');
      setState(() => _isProcessing = false);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating booking: $e')),
        );
      }
    }
  }
  
  Future<void> _handlePaymentError(PaymentFailureResponse response) async {
    setState(() => _isProcessing = false);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment failed: ${response.message ?? "Unknown error"}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${dateTime.day} ${months[dateTime.month - 1]}, ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
