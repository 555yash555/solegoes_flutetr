import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';


@freezed
abstract class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String messageId,
    required String senderId,
    required String senderName,
    String? senderAvatar,
    required String content,
    @JsonKey(name: 'timestamp') required int timestampMillis,
    @Default('text') String type,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);

  const ChatMessage._();

  /// Convert milliseconds to DateTime
  DateTime get timestamp => DateTime.fromMillisecondsSinceEpoch(timestampMillis);
}
