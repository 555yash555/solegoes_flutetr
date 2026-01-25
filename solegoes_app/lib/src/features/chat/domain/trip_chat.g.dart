// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TripChat _$TripChatFromJson(Map<String, dynamic> json) => _TripChat(
  chatId: json['chatId'] as String,
  tripId: json['tripId'] as String,
  tripTitle: json['tripTitle'] as String,
  tripLocation: json['tripLocation'] as String,
  tripStartDateMillis: (json['tripStartDate'] as num).toInt(),
  tripEndDateMillis: (json['tripEndDate'] as num).toInt(),
  participantIds: Map<String, bool>.from(json['participantIds'] as Map),
  participantCount: (json['participantCount'] as num).toInt(),
  lastMessage: json['lastMessage'] as String?,
  lastMessageTimeMillis: (json['lastMessageTime'] as num?)?.toInt(),
  lastMessageSenderId: json['lastMessageSenderId'] as String?,
  createdAtMillis: (json['createdAt'] as num).toInt(),
);

Map<String, dynamic> _$TripChatToJson(_TripChat instance) => <String, dynamic>{
  'chatId': instance.chatId,
  'tripId': instance.tripId,
  'tripTitle': instance.tripTitle,
  'tripLocation': instance.tripLocation,
  'tripStartDate': instance.tripStartDateMillis,
  'tripEndDate': instance.tripEndDateMillis,
  'participantIds': instance.participantIds,
  'participantCount': instance.participantCount,
  'lastMessage': instance.lastMessage,
  'lastMessageTime': instance.lastMessageTimeMillis,
  'lastMessageSenderId': instance.lastMessageSenderId,
  'createdAt': instance.createdAtMillis,
};
