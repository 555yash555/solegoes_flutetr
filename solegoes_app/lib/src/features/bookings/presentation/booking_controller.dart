import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../shared/global_error_controller.dart';
import '../data/booking_repository.dart';
import '../domain/booking.dart';
import '../../trips/domain/trip.dart';

part 'booking_controller.g.dart';

/// Controller for managing booking operations
/// Handles booking creation with AsyncValue for consistent error handling
@Riverpod(keepAlive: true)
class BookingController extends _$BookingController {
  @override
  FutureOr<void> build() {
    // Initial state
  }

  /// Create a booking after successful payment
  Future<Booking?> createBooking({
    required Trip trip,
    required String userId,
    required String userEmail,
    required String? userName,
    required String paymentId,
    required double amount,
    String? selectedStyleId,
    String? selectedStyleName,
    SelectedTripPoint? boardingPoint,
    SelectedTripPoint? droppingPoint,
    BookingStatus status = BookingStatus.confirmed,
    PaymentStatus paymentStatus = PaymentStatus.success,
    String? failureReason,
  }) async {
    // Check if provider is still mounted
    if (!ref.mounted) return null;
    
    // Set loading state
    state = const AsyncLoading();

    Booking? result;

    // AsyncValue.guard auto-catches errors
    state = await AsyncValue.guard(() async {
      result = await ref.read(bookingRepositoryProvider).createBooking(
            tripId: trip.tripId,
            userId: userId,
            tripTitle: trip.title,
            tripImageUrl: trip.imageUrl,
            tripLocation: trip.location,
            tripDuration: trip.duration,
            amount: amount,
            paymentId: paymentId,
            paymentMethod: 'razorpay',
            userEmail: userEmail,
            userName: userName,
            selectedStyleId: selectedStyleId,
            selectedStyleName: selectedStyleName,
            selectedBoardingPoint: boardingPoint,
            selectedDroppingPoint: droppingPoint,
            status: status,
            paymentStatus: paymentStatus,
            failureReason: failureReason,
          );
    });

    // Check again after async gap
    if (!ref.mounted) return null;

    // Report error to global handler
    if (state.hasError) {
      ref.read(globalErrorProvider.notifier).setException(state.error!);
      return null;
    }

    return result;
  }

  /// Create pending booking for failed payment (with retry option)
  Future<Booking?> createPendingBooking({
    required Trip trip,
    required String userId,
    required String userEmail,
    required String? userName,
    required double amount,
    required String failureReason,
    String? selectedStyleId,
    String? selectedStyleName,
    SelectedTripPoint? boardingPoint,
    SelectedTripPoint? droppingPoint,
  }) async {
    return createBooking(
      trip: trip,
      userId: userId,
      userEmail: userEmail,
      userName: userName,
      paymentId: 'pending_${DateTime.now().millisecondsSinceEpoch}',
      amount: amount,
      selectedStyleId: selectedStyleId,
      selectedStyleName: selectedStyleName,
      boardingPoint: boardingPoint,
      droppingPoint: droppingPoint,
      status: BookingStatus.pending,
      paymentStatus: PaymentStatus.failed,
      failureReason: failureReason,
    );
  }

  /// Check if booking was successful
  bool get wasSuccessful => !state.hasError;

  /// Check if booking is in progress
  bool get isLoading => state.isLoading;
}
