import 'package:firebase_database/firebase_database.dart';
import '../domain/trip_chat.dart';
import '../domain/chat_message.dart';

/// Repository for managing chat data in Firebase Realtime Database
class ChatRepository {
  final DatabaseReference _database;

  ChatRepository(this._database);

  /// Get chat by its ID
  Future<TripChat?> getChatById(String chatId) async {
    try {
      final snapshot = await _database.child('trip_chats').child(chatId).once();

      if (snapshot.snapshot.value == null) {
        return null;
      }

      final chatData = Map<String, dynamic>.from(snapshot.snapshot.value as Map);
      chatData['chatId'] = chatId;

      return TripChat.fromJson(chatData);
    } catch (e) {
      print('Error getting chat by ID: $e');
      return null;
    }
  }

  /// Get chat for a specific trip
  Future<TripChat?> getChatForTrip(String tripId) async {
    try {
      final snapshot = await _database
          .child('trip_chats')
          .orderByChild('tripId')
          .equalTo(tripId)
          .limitToFirst(1)
          .once();

      if (snapshot.snapshot.value == null) {
        return null;
      }

      final chatsData = snapshot.snapshot.value as Map<dynamic, dynamic>;
      final firstChatEntry = chatsData.entries.first;
      final chatId = firstChatEntry.key;
      final chatData = Map<String, dynamic>.from(firstChatEntry.value);
      chatData['chatId'] = chatId;

      return TripChat.fromJson(chatData);
    } catch (e) {
      print('Error getting chat for trip: $e');
      return null;
    }
  }

  /// Create a new trip chat
  Future<TripChat> createTripChat({
    required String tripId,
    required String tripTitle,
    required String tripLocation,
    required DateTime tripStartDate,
    required DateTime tripEndDate,
    required String userId,
    required String userName,
  }) async {
    final chatRef = _database.child('trip_chats').push();
    final chatId = chatRef.key!;
    final now = DateTime.now().millisecondsSinceEpoch;

    final chatData = {
      'tripId': tripId,
      'tripTitle': tripTitle,
      'tripLocation': tripLocation,
      'tripStartDate': tripStartDate.millisecondsSinceEpoch,
      'tripEndDate': tripEndDate.millisecondsSinceEpoch,
      'participantIds': {userId: true},
      'participantCount': 1,
      'lastMessage': 'Chat created',
      'lastMessageTime': ServerValue.timestamp,
      'lastMessageSenderId': userId,
      'createdAt': ServerValue.timestamp,
    };

    await chatRef.set(chatData);

    // Fetch the created chat to get server timestamps
    final snapshot = await chatRef.once();
    final data = Map<String, dynamic>.from(snapshot.snapshot.value as Map);
    data['chatId'] = chatId;

    return TripChat.fromJson(data);
  }

  /// Add a participant to an existing chat
  Future<void> addParticipant(String chatId, String userId) async {
    final chatRef = _database.child('trip_chats/$chatId');

    // Add to participantIds
    await chatRef.child('participantIds/$userId').set(true);

    // Increment participant count atomically
    await chatRef.child('participantCount').runTransaction((currentValue) {
      final count = (currentValue as int?) ?? 0;
      return Transaction.success(count + 1);
    });
  }

  /// Watch all chats for a specific user
  Stream<List<TripChat>> watchUserChats(String userId) {
    return _database.child('trip_chats').onValue.map((event) {
      final chats = <TripChat>[];
      final data = event.snapshot.value;

      if (data == null) return chats;

      final chatsMap = Map<String, dynamic>.from(data as Map);

      for (final entry in chatsMap.entries) {
        final chatId = entry.key;
        final chatData = Map<String, dynamic>.from(entry.value);

        // Check if user is a participant
        final participants = chatData['participantIds'] as Map?;
        if (participants != null && participants.containsKey(userId)) {
          chatData['chatId'] = chatId;
          try {
            chats.add(TripChat.fromJson(chatData));
          } catch (e) {
            print('Error parsing chat $chatId: $e');
          }
        }
      }

      // Sort by last message time (most recent first)
      chats.sort((a, b) {
        final aTime = a.lastMessageTimeMillis ?? 0;
        final bTime = b.lastMessageTimeMillis ?? 0;
        return bTime.compareTo(aTime);
      });

      return chats;
    });
  }

  /// Watch messages for a specific chat
  Stream<List<ChatMessage>> watchMessages(String chatId) {
    return _database
        .child('trip_chats/$chatId/messages')
        .orderByChild('timestamp')
        .onValue
        .map((event) {
      final messages = <ChatMessage>[];
      final data = event.snapshot.value;

      if (data == null) return messages;

      final messagesMap = Map<String, dynamic>.from(data as Map);

      for (final entry in messagesMap.entries) {
        final messageId = entry.key;
        final messageData = Map<String, dynamic>.from(entry.value);
        messageData['messageId'] = messageId;

        try {
          messages.add(ChatMessage.fromJson(messageData));
        } catch (e) {
          print('Error parsing message $messageId: $e');
        }
      }

      // Sort by timestamp (oldest first for chat display)
      messages.sort((a, b) => a.timestampMillis.compareTo(b.timestampMillis));

      return messages;
    });
  }

  /// Send a message to a chat
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String senderName,
    String? senderAvatar,
    required String content,
  }) async {
    final messageRef = _database.child('trip_chats/$chatId/messages').push();

    final messageData = {
      'senderId': senderId,
      'senderName': senderName,
      'senderAvatar': senderAvatar,
      'content': content,
      'timestamp': ServerValue.timestamp,
      'type': 'text',
    };

    await messageRef.set(messageData);

    // Update chat metadata
    await _database.child('trip_chats/$chatId').update({
      'lastMessage': content,
      'lastMessageTime': ServerValue.timestamp,
      'lastMessageSenderId': senderId,
    });
  }

  /// Check if user has access to a chat (is a participant)
  Future<bool> userHasAccessToChat(String userId, String chatId) async {
    try {
      final snapshot =
          await _database.child('trip_chats/$chatId/participantIds/$userId').once();
      return snapshot.snapshot.value == true;
    } catch (e) {
      print('Error checking chat access: $e');
      return false;
    }
  }
}
