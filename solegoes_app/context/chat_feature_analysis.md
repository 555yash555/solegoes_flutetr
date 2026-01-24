# Chat Feature Analysis & Implementation Requirements

Complete breakdown of the chat feature, current status, and what needs to be built.

---

## Current Status: What's Already Done ✅

### 1. UI Screens (Fully Implemented)

#### Chat List Screen (`chat_list_screen.dart`)
- **Route:** `/chat`
- **Features:**
  - List of all chat conversations
  - Search bar (visual only)
  - Unread message badges
  - Online status indicators
  - Group chat vs direct message differentiation
- **Current Data:** Mock/hardcoded data (3 sample chats)

#### Chat Detail Screen (`chat_detail_screen.dart`)
- **Route:** `/chat/:chatId`  
- **Features:**
  - Message history display
  - Send/receive message interface
  - User avatars with colors
  - Attachment button (visual only)
  - Emoji picker button (visual only)
  - Auto-scroll to bottom on new message
- **Current Data:** Mock messages, no Firebase integration

### 2. Navigation Routes (✅ Configured)

```dart
// In app_router.dart:

// Chat list
GoRoute(
  path: '/chat',
  name: AppRoute.chatList.name,
  builder: (context, state) => const ChatListScreen(),
)

// Chat detail
GoRoute(
  path: '/chat/:chatId',
  name: AppRoute.chatDetail.name,
  builder: (context, state) {
    final chatId = state.pathParameters['chatId']!;
    return ChatDetailScreen(chatId: chatId);
  },
)
```

### 3. Bottom Navigation (✅ Accessible)

Chat tab is already in the bottom navigation bar, users can tab to it.

---

## Business Requirements: What chat SHOULD Do

### Core Rule: **Only Booked Trips Can Join Chat**

Users should only be able to chat with others who have:
1. **Booked the same trip** (confirmed booking)
2. **Selected the same trip dates** (startDate/endDate match)
3. **Payment status:** Confirmed or Pending (not Failed)

### Chat Types

1. **Trip Group Chat**
   - One chat room per trip batch (same dates)
   - All users with confirmed bookings can join
   - Discussions about trip logistics, meeting up, etc.

2. **Direct Messages** (Future enhancement)
   - 1-on-1 chats between trip participants
   - Not implemented yet

---

## Data Model (From `seed_trips_screen.dart`)

### Trip Data Structure
```dart
{
  'tripId': String,  // e.g., 'FYFiLSTUnbDaFE4jJCLm'
  'title': String,
  'location': String,
  'startDate': Timestamp,
  'endDate': Timestamp,
  'duration': int,
  // ... other trip fields
}
```

### Booking Data Structure (From booking system)
```dart
{
  'bookingId': String,
  'userId': String,          // Current user's ID
  'tripId': String,          // Links to trip
  'status': BookingStatus,   // pending, confirmed, cancelled
  'paymentStatus': PaymentStatus,  // pending, success, failed
  'createdAt': Timestamp,
  // ... other booking fields
}
```

### Required Chat Data Structure (Missing - Need to Create)

**Firebase Realtime Database uses JSON paths, not Firestore collections.**

```json
{
  "trip_chats": {
    "chat_abc123": {
      "tripId": "FYFiLSTUnbDaFE4jJCLm",
      "tripTitle": "Bali Spiritual Awakening",
      "tripLocation": "Ubud, Bali",
      "tripStartDate": 1738656000000,
      "tripEndDate": 1739260800000,
      
      "participantIds": {
        "user1_uid": true,
        "user2_uid": true,
        "user3_uid": true
      },
      "participantCount": 3,
      
      "lastMessage": "Anyone up for surfing?",
      "lastMessageTime": 1738656789000,
      "lastMessageSenderId": "user2_uid",
      
      "createdAt": 1738656000000,
      
      "messages": {
        "msg_001": {
          "senderId": "user1_uid",
          "senderName": "Sarah",
          "senderAvatar": "https://...",
          "content": "Hey everyone! So excited! 🎉",
          "timestamp": 1738656100000,
          "type": "text"
        },
        "msg_002": {
          "senderId": "user2_uid",
          "senderName": "Mike",
          "senderAvatar": "https://...",
          "content": "Anyone up for surfing?",
          "timestamp": 1738656789000,
          "type": "text"
        }
      }
    }
  }
}
```

**Key Points:**
- Messages are **nested under** `trip_chats/{chatId}/messages`
- `participantIds` uses object with userId as key, value = true (for efficient lookups)
- Timestamps are Unix milliseconds (Firebase `.timestamp` ServerValue)
- Path to messages: `trip_chats/chat_abc123/messages`

---

## Missing Pieces: What Needs to be Built

### 1. Trip Detail Screen - Join Chat Button Logic ❌

**Current Code (Line 657-674 in `trip_detail_screen.dart`):**
```dart
GestureDetector(
  onTap: () {
    // TODO: Navigate to trip chat
  },
  child: Container(
    /* ... */
    child: Text('Join Chat', style: AppTextStyles.labelLarge),
  ),
),
```

**What It Should Do:**
1. Check if user has a confirmed booking for this trip
2. If YES → Navigate to trip chat (or create chat if first user)
3. If NO → Show dialog: "Book this trip to join the chat"

### 2. Chat Creation Logic ❌

When first user with booking tries to join chat:
1. Create Firestore document in `trip_chats` collection
2. Add user to `participantIds`
3. Create welcome message

When subsequent users join:
1. Find existing chat for this tripId + dates
2. Add user to `participantIds` if not already there
3. Navigate to chat

### 3. Chat Repository ❌

Need to create:
- `lib/src/features/chat/data/chat_repository.dart`
- Methods:
  - `getChatForTrip(tripId, startDate, endDate)`  
  - `createTripChat(trip, userId, userName)`
  - `addParticipantToChat(chatId, userId)`
  - `sendMessage(chatId, message)`
  - `watchMessages(chatId)` → Stream of messages
  - `watchUserChats(userId)` → Stream of user's chat list

### 4. Chat Domain Models ❌

Need to create:
- `lib/src/features/chat/domain/trip_chat.dart`
- `lib/src/features/chat/domain/chat_message.dart`

With Freezed + JSON serialization for type safety.

### 5. Access Control Logic ❌

Firebase Realtime Database Security Rules needed:
```json
{
  "rules": {
    "trip_chats": {
      "$chatId": {
        ".read": "auth != null && data.child('participantIds').child(auth.uid).val() == true",
        ".write": "auth != null && data.child('participantIds').child(auth.uid).val() == true",
        
        "messages": {
          "$messageId": {
            ".read": "auth != null && root.child('trip_chats').child($chatId).child('participantIds').child(auth.uid).val() == true",
            ".write": "auth != null && root.child('trip_chats').child($chatId).child('participantIds').child(auth.uid).val() == true"
          }
        }
      }
    }
  }
}
```

---

## Implementation Roadmap

### Phase 1: Data Layer (Backend Logic)

**1. Create Domain Models**
```dart
// lib/src/features/chat/domain/trip_chat.dart
@freezed
class TripChat with _$TripChat {
  factory TripChat({
    required String chatId,
    required String tripId,
    required String tripTitle,
    /* ... */
  }) = _TripChat;
  
  factory TripChat.fromJson(Map<String, dynamic> json) => _$TripChatFromJson(json);
}
```

**2. Create Chat Repository**
```dart
// lib/src/features/chat/data/chat_repository.dart
import 'package:firebase_database/firebase_database.dart';

class ChatRepository {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  
  Future<TripChat?> getChatForTrip(String tripId, DateTime startDate, DateTime endDate) async {
    // Query trip_chats where tripId matches
    final snapshot = await _database.child('trip_chats')
      .orderByChild('tripId')
      .equalTo(tripId)
      .once();
    
    // Filter by dates and return first match
    // (Realtime DB doesn't support multiple orderBy, so filter in code)
  }
  
  Future<TripChat> createTripChat(Trip trip, String userId, String userName) async {
    final chatRef = _database.child('trip_chats').push();
    
    await chatRef.set({
      'tripId': trip.tripId,
      'tripTitle': trip.title,
      'participantIds': {userId: true},
      'participantCount': 1,
      'lastMessage': 'Chat created',
      'lastMessageTime': ServerValue.timestamp,
      'createdAt': ServerValue.timestamp,
    });
    
    return TripChat.fromJson({...});
  }
  
  Stream<List<ChatMessage>> watchMessages(String chatId) {
    return _database
      .child('trip_chats')
      .child(chatId)
      .child('messages')
      .onValue
      .map((event) {
        final data = event.snapshot.value as Map<dynamic, dynamic>?;
        // Convert to ChatMessage list
      });
  }
  
  Future<void> sendMessage(String chatId, ChatMessage message) async {
    final messageRef = _database
      .child('trip_chats/$chatId/messages')
      .push();
    
    await messageRef.set({
      'senderId': message.senderId,
      'content': message.content,
      'timestamp': ServerValue.timestamp,
    });
    
    // Update chat metadata
    await _database.child('trip_chats/$chatId').update({
      'lastMessage': message.content,
      'lastMessageTime': ServerValue.timestamp,
    });
  }
}
```

**3. Create Riverpod Providers**
```dart
@riverpod
ChatRepository chatRepository(Ref ref) {
  return ChatRepository(FirebaseFirestore.instance);
}

@riverpod
Future<TripChat?> tripChat(Ref ref, String tripId) {
  final repository = ref.watch(chatRepositoryProvider);
  // Get chat for this trip
}

@riverpod
Stream<List<ChatMessage>> chatMessages(Ref ref, String chatId) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.watchMessages(chatId);
}
```

### Phase 2: Business Logic (Access Control)

**1. Booking Validation Service**
```dart
class ChatAccessService {
  /// Check if user can access chat for this trip
  Future<bool> canJoinChat(String userId, String tripId) async {
    final booking = await _getBookingForUser(userId, tripId);
    
    if (booking == null) return false;
    
    // Only confirmed or pending bookings
    if (booking.status == BookingStatus.cancelled) return false;
    if (booking.paymentStatus == PaymentStatus.failed) return false;
    
    return true;
  }
}
```

**2. Integrate with Trip Detail Button**
```dart
GestureDetector(
  onTap: () async {
    final user = ref.read(authStateChangesProvider).value;
    if (user == null) {
      context.push('/login');
      return;
    }
    
    final canJoin = await ref.read(chatAccessServiceProvider)
      .canJoinChat(user.uid, trip.tripId);
    
    if (!canJoin) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Book Trip First'),
          content: Text('You need to book this trip to join the chat'),
          actions: [/* ... */],
        ),
      );
      return;
    }
    
    // User can join - get or create chat
    final chat = await ref.read(tripChatProvider(trip.tripId).future);
    
    if (chat == null) {
      // First user - create chat
      final newChat = await ref.read(chatRepositoryProvider)
        .createTripChat(trip, user.uid, user.displayName ?? 'Anonymous');
      context.push('/chat/${newChat.chatId}');
    } else {
      // Chat exists - add user and navigate
      await ref.read(chatRepositoryProvider)
        .addParticipantToChat(chat.chatId, user.uid);
      context.push('/chat/${chat.chatId}');
    }
  },
  child: /* Join Chat button */,
),
```

### Phase 3: Update UI Screens

**1. Update Chat List Screen**
- Replace mock data with Riverpod provider
- Show only chats user has access to
- Real-time updates with StreamProvider

**2. Update Chat Detail Screen**
- Replace mock messages with Firestore stream
- Implement real send message functionality
- Show typing indicators (optional)
- Load user profile data for avatars

---

## Security Considerations

1. **Firestore Rules:** Users can only read chats they're participants of
2. **Booking Verification:** Always check booking status server-side
3. **Message Validation:** Sanitize message content before saving
4. **Rate Limiting:** Prevent spam (Firebase App Check or Cloud Functions)

---

## Testing Strategy

1. **Create test bookings** in seed_trips_screen
2. **Test scenarios:**
   - User with booking can join chat
   - User without booking sees "Book first" dialog
   - Multiple users in same chat see each other's messages
   - Only booked users appear in participant list
   - Chat persists across app restarts

---

## Summary: Current vs Required

| Feature | Current Status | Required | Priority |
|---------|---------------|----------|----------|
| Chat UI | ✅ Complete | - | - |
| Navigation | ✅ Complete | - | - |
| Firebase Integration | ❌ Mock data | Real Firestore | **HIGH** |
| Booking Validation | ❌ Missing | Check booking status | **HIGH** |
| Chat Creation | ❌ Missing | Auto-create on first join | **HIGH** |
| Access Control | ❌ Missing | Firestore rules + logic | **MEDIUM** |
| Message Sending | ❌ Local only | Save to Firestore | **MEDIUM** |
| User Profiles in Chat | ❌ Mock avatars | Real user data | **LOW** |
| Attachments | ❌ Missing | Image/file upload | **LOW** |

**Next Step:** Start with Phase 1 - Build the data layer (domain models + repository + providers).
