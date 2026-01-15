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

/// Selected point with date/time for booking
@freezed
abstract class SelectedTripPoint with _$SelectedTripPoint {
  const factory SelectedTripPoint({
    required String name,
    required String address,
    required DateTime dateTime,
  }) = _SelectedTripPoint;

  factory SelectedTripPoint.fromJson(Map<String, dynamic> json) =>
      _$SelectedTripPointFromJson(json);
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
    // Trip style/package selection
    String? selectedStyleId,
    String? selectedStyleName,
    // Boarding and dropping point details
    SelectedTripPoint? selectedBoardingPoint,
    SelectedTripPoint? selectedDroppingPoint,
  }) = _Booking;

  factory Booking.fromJson(Map<String, dynamic> json) => _$BookingFromJson(json);
}

/// Helper to parse SelectedTripPoint from Firestore
SelectedTripPoint? _parseSelectedTripPoint(Map<String, dynamic>? data) {
  if (data == null) return null;
  return SelectedTripPoint(
    name: data['name'] as String? ?? '',
    address: data['address'] as String? ?? '',
    dateTime: data['dateTime'] is Timestamp
        ? (data['dateTime'] as Timestamp).toDate()
        : DateTime.tryParse(data['dateTime'] as String? ?? '') ?? DateTime.now(),
  );
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
    selectedStyleId: data['selectedStyleId'] as String?,
    selectedStyleName: data['selectedStyleName'] as String?,
    selectedBoardingPoint: _parseSelectedTripPoint(
      data['selectedBoardingPoint'] as Map<String, dynamic>?,
    ),
    selectedDroppingPoint: _parseSelectedTripPoint(
      data['selectedDroppingPoint'] as Map<String, dynamic>?,
    ),
  );
}

/// Helper to convert SelectedTripPoint to Firestore
Map<String, dynamic>? _selectedTripPointToFirestore(SelectedTripPoint? point) {
  if (point == null) return null;
  return {
    'name': point.name,
    'address': point.address,
    'dateTime': Timestamp.fromDate(point.dateTime),
  };
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
    'selectedStyleId': booking.selectedStyleId,
    'selectedStyleName': booking.selectedStyleName,
    'selectedBoardingPoint': _selectedTripPointToFirestore(booking.selectedBoardingPoint),
    'selectedDroppingPoint': _selectedTripPointToFirestore(booking.selectedDroppingPoint),
  };
}
