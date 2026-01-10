import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking.freezed.dart';
part 'booking.g.dart';

/// Booking status enum
enum BookingStatus {
  pending,
  confirmed,
  cancelled,
  completed,
}

/// Payment status enum
enum PaymentStatus {
  pending,
  success,
  failed,
  refunded,
}

/// Booking model for trip bookings
@freezed
abstract class Booking with _$Booking {
  const factory Booking({
    required String bookingId,
    required String tripId,
    required String userId,
    required String tripTitle,
    required String tripImageUrl,
    required String tripLocation,
    required int tripDuration,
    required double amount,
    required String paymentId,
    required String paymentMethod,
    @Default(BookingStatus.confirmed) BookingStatus status,
    @Default(PaymentStatus.success) PaymentStatus paymentStatus,
    String? failureReason,
    required DateTime bookingDate,
    DateTime? tripStartDate,
    String? userEmail,
    String? userName,
  }) = _Booking;

  factory Booking.fromJson(Map<String, dynamic> json) => _$BookingFromJson(json);
}

/// Helper to create Booking from Firestore document
Booking bookingFromFirestore(DocumentSnapshot doc) {
  final data = doc.data() as Map<String, dynamic>;
  return Booking(
    bookingId: doc.id,
    tripId: data['tripId'] as String,
    userId: data['userId'] as String,
    tripTitle: data['tripTitle'] as String,
    tripImageUrl: data['tripImageUrl'] as String? ?? '',
    tripLocation: data['tripLocation'] as String? ?? '',
    tripDuration: data['tripDuration'] as int? ?? 0,
    amount: (data['amount'] as num).toDouble(),
    paymentId: data['paymentId'] as String,
    paymentMethod: data['paymentMethod'] as String? ?? 'card',
    status: BookingStatus.values.firstWhere(
      (e) => e.name == data['status'],
      orElse: () => BookingStatus.confirmed,
    ),
    paymentStatus: PaymentStatus.values.firstWhere(
      (e) => e.name == data['paymentStatus'],
      orElse: () => PaymentStatus.success,
    ),
    failureReason: data['failureReason'] as String?,
    bookingDate: (data['bookingDate'] as Timestamp).toDate(),
    tripStartDate: data['tripStartDate'] != null
        ? (data['tripStartDate'] as Timestamp).toDate()
        : null,
    userEmail: data['userEmail'] as String?,
    userName: data['userName'] as String?,
  );
}

/// Helper to convert Booking to Firestore document
Map<String, dynamic> bookingToFirestore(Booking booking) {
  return {
    'tripId': booking.tripId,
    'userId': booking.userId,
    'tripTitle': booking.tripTitle,
    'tripImageUrl': booking.tripImageUrl,
    'tripLocation': booking.tripLocation,
    'tripDuration': booking.tripDuration,
    'amount': booking.amount,
    'paymentId': booking.paymentId,
    'paymentMethod': booking.paymentMethod,
    'status': booking.status.name,
    'paymentStatus': booking.paymentStatus.name,
    'failureReason': booking.failureReason,
    'bookingDate': Timestamp.fromDate(booking.bookingDate),
    'tripStartDate': booking.tripStartDate != null
        ? Timestamp.fromDate(booking.tripStartDate!)
        : null,
    'userEmail': booking.userEmail,
    'userName': booking.userName,
  };
}
