// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Booking _$BookingFromJson(Map<String, dynamic> json) => _Booking(
  bookingId: json['bookingId'] as String,
  tripId: json['tripId'] as String,
  userId: json['userId'] as String,
  tripTitle: json['tripTitle'] as String,
  tripImageUrl: json['tripImageUrl'] as String,
  tripLocation: json['tripLocation'] as String,
  tripDuration: (json['tripDuration'] as num).toInt(),
  amount: (json['amount'] as num).toDouble(),
  paymentId: json['paymentId'] as String,
  paymentMethod: json['paymentMethod'] as String,
  status:
      $enumDecodeNullable(_$BookingStatusEnumMap, json['status']) ??
      BookingStatus.confirmed,
  paymentStatus:
      $enumDecodeNullable(_$PaymentStatusEnumMap, json['paymentStatus']) ??
      PaymentStatus.success,
  failureReason: json['failureReason'] as String?,
  bookingDate: DateTime.parse(json['bookingDate'] as String),
  tripStartDate: json['tripStartDate'] == null
      ? null
      : DateTime.parse(json['tripStartDate'] as String),
  userEmail: json['userEmail'] as String?,
  userName: json['userName'] as String?,
);

Map<String, dynamic> _$BookingToJson(_Booking instance) => <String, dynamic>{
  'bookingId': instance.bookingId,
  'tripId': instance.tripId,
  'userId': instance.userId,
  'tripTitle': instance.tripTitle,
  'tripImageUrl': instance.tripImageUrl,
  'tripLocation': instance.tripLocation,
  'tripDuration': instance.tripDuration,
  'amount': instance.amount,
  'paymentId': instance.paymentId,
  'paymentMethod': instance.paymentMethod,
  'status': _$BookingStatusEnumMap[instance.status]!,
  'paymentStatus': _$PaymentStatusEnumMap[instance.paymentStatus]!,
  'failureReason': instance.failureReason,
  'bookingDate': instance.bookingDate.toIso8601String(),
  'tripStartDate': instance.tripStartDate?.toIso8601String(),
  'userEmail': instance.userEmail,
  'userName': instance.userName,
};

const _$BookingStatusEnumMap = {
  BookingStatus.pending: 'pending',
  BookingStatus.confirmed: 'confirmed',
  BookingStatus.cancelled: 'cancelled',
  BookingStatus.completed: 'completed',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.success: 'success',
  PaymentStatus.failed: 'failed',
  PaymentStatus.refunded: 'refunded',
};
