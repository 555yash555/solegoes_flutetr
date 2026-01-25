import 'package:freezed_annotation/freezed_annotation.dart';

part 'trip_chat.freezed.dart';
part 'trip_chat.g.dart';

/// Represents a trip group chat in Firebase Realtime Database
@freezed
abstract class TripChat with _$TripChat {
  const factory TripChat({
    required String chatId,
    required String tripId,
    required String tripTitle,
    required String tripLocation,
    @JsonKey(name: 'tripStartDate') required int tripStartDateMillis,
    @JsonKey(name: 'tripEndDate') required int tripEndDateMillis,
    required Map<String, bool> participantIds,
    required int participantCount,
    String? lastMessage,
    @JsonKey(name: 'lastMessageTime') int? lastMessageTimeMillis,
    String? lastMessageSenderId,
    @JsonKey(name: 'createdAt') required int createdAtMillis,
  }) = _TripChat;

  factory TripChat.fromJson(Map<String, dynamic> json) =>
      _$TripChatFromJson(json);

  const TripChat._();

  /// Convert milliseconds to DateTime
  DateTime get tripStartDate =>
      DateTime.fromMillisecondsSinceEpoch(tripStartDateMillis);
  DateTime get tripEndDate =>
      DateTime.fromMillisecondsSinceEpoch(tripEndDateMillis);
  DateTime? get lastMessageTime => lastMessageTimeMillis != null
      ? DateTime.fromMillisecondsSinceEpoch(lastMessageTimeMillis!)
      : null;
  DateTime get createdAt => DateTime.fromMillisecondsSinceEpoch(createdAtMillis);
}
