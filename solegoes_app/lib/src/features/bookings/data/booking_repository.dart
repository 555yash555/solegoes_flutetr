import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/booking.dart';

part 'booking_repository.g.dart';

/// Repository for managing bookings in Firestore
class BookingRepository {
  final FirebaseFirestore _firestore;

  BookingRepository(this._firestore);

  CollectionReference<Map<String, dynamic>> get _bookingsRef =>
      _firestore.collection('bookings');

  /// Create a new booking
  Future<Booking> createBooking({
    required String tripId,
    required String userId,
    required String tripTitle,
    required String tripImageUrl,
    required String tripLocation,
    required int tripDuration,
    required double amount,
    required String paymentId,
    required String paymentMethod,
    BookingStatus status = BookingStatus.confirmed,
    PaymentStatus paymentStatus = PaymentStatus.success,
    String? failureReason,
    String? userEmail,
    String? userName,
  }) async {
    final booking = Booking(
      bookingId: '', // Will be set by Firestore
      tripId: tripId,
      userId: userId,
      tripTitle: tripTitle,
      tripImageUrl: tripImageUrl,
      tripLocation: tripLocation,
      tripDuration: tripDuration,
      amount: amount,
      paymentId: paymentId,
      paymentMethod: paymentMethod,
      status: status,
      paymentStatus: paymentStatus,
      failureReason: failureReason,
      bookingDate: DateTime.now(),
      userEmail: userEmail,
      userName: userName,
    );

    final docRef = await _bookingsRef.add(bookingToFirestore(booking));

    return booking.copyWith(bookingId: docRef.id);
  }

  /// Get a booking by ID
  Future<Booking?> getBooking(String bookingId) async {
    final doc = await _bookingsRef.doc(bookingId).get();
    if (!doc.exists) return null;
    return bookingFromFirestore(doc);
  }

  /// Get a booking by payment ID
  Future<Booking?> getBookingByPaymentId(String paymentId) async {
    final query = await _bookingsRef
        .where('paymentId', isEqualTo: paymentId)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;
    return bookingFromFirestore(query.docs.first);
  }

  /// Get all bookings for a user
  Future<List<Booking>> getUserBookings(String userId) async {
    final query = await _bookingsRef
        .where('userId', isEqualTo: userId)
        .orderBy('bookingDate', descending: true)
        .get();

    return query.docs.map((doc) => bookingFromFirestore(doc)).toList();
  }

  /// Stream of user bookings
  Stream<List<Booking>> watchUserBookings(String userId) {
    return _bookingsRef
        .where('userId', isEqualTo: userId)
        .orderBy('bookingDate', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => bookingFromFirestore(doc)).toList());
  }

  /// Update booking status
  Future<void> updateBookingStatus(
      String bookingId, BookingStatus status) async {
    await _bookingsRef.doc(bookingId).update({'status': status.name});
  }

  /// Cancel a booking
  Future<void> cancelBooking(String bookingId) async {
    await _bookingsRef.doc(bookingId).update({
      'status': BookingStatus.cancelled.name,
    });
  }

  /// Get user's booking for a specific trip (to check if already booked)
  /// Includes confirmed, pending, and failed bookings
  Future<Booking?> getUserBookingForTrip(String tripId, String userId) async {
    final query = await _bookingsRef
        .where('tripId', isEqualTo: tripId)
        .where('userId', isEqualTo: userId)
        .where('status', whereIn: ['confirmed', 'pending'])
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;
    return bookingFromFirestore(query.docs.first);
  }

  /// Update payment status (for webhook updates)
  Future<void> updatePaymentStatus(
    String bookingId, {
    required PaymentStatus paymentStatus,
    BookingStatus? bookingStatus,
    String? paymentId,
  }) async {
    final updates = <String, dynamic>{
      'paymentStatus': paymentStatus.name,
    };
    if (bookingStatus != null) {
      updates['status'] = bookingStatus.name;
    }
    if (paymentId != null) {
      updates['paymentId'] = paymentId;
    }
    await _bookingsRef.doc(bookingId).update(updates);
  }

  /// Get booking by Razorpay order ID or payment ID for webhook handling
  Future<Booking?> getBookingByPaymentIdPrefix(String prefix) async {
    // Query for bookings where paymentId starts with the prefix
    final query = await _bookingsRef
        .where('paymentId', isGreaterThanOrEqualTo: prefix)
        .where('paymentId', isLessThan: '${prefix}z')
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;
    return bookingFromFirestore(query.docs.first);
  }
}

/// Provider for BookingRepository
@Riverpod(keepAlive: true)
BookingRepository bookingRepository(Ref ref) {
  return BookingRepository(FirebaseFirestore.instance);
}

/// Provider for user's bookings stream
@riverpod
Stream<List<Booking>> userBookings(Ref ref, String userId) {
  final repository = ref.watch(bookingRepositoryProvider);
  return repository.watchUserBookings(userId);
}

/// Provider for a single booking
@riverpod
Future<Booking?> booking(Ref ref, String bookingId) {
  final repository = ref.watch(bookingRepositoryProvider);
  return repository.getBooking(bookingId);
}

/// Provider for booking by payment ID
@riverpod
Future<Booking?> bookingByPaymentId(Ref ref, String paymentId) {
  final repository = ref.watch(bookingRepositoryProvider);
  return repository.getBookingByPaymentId(paymentId);
}

/// Provider to check if user has booked a specific trip
@riverpod
Future<Booking?> userTripBooking(Ref ref, String tripId, String userId) {
  final repository = ref.watch(bookingRepositoryProvider);
  return repository.getUserBookingForTrip(tripId, userId);
}
