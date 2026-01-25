// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => _ChatMessage(
  messageId: json['messageId'] as String,
  senderId: json['senderId'] as String,
  senderName: json['senderName'] as String,
  senderAvatar: json['senderAvatar'] as String?,
  content: json['content'] as String,
  timestampMillis: (json['timestamp'] as num).toInt(),
  type: json['type'] as String? ?? 'text',
);

Map<String, dynamic> _$ChatMessageToJson(_ChatMessage instance) =>
    <String, dynamic>{
      'messageId': instance.messageId,
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'senderAvatar': instance.senderAvatar,
      'content': instance.content,
      'timestamp': instance.timestampMillis,
      'type': instance.type,
    };
