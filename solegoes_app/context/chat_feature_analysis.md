# Chat Feature

**Status:** Backend complete, UI integration pending

---

## Architecture

- **Database:** Firebase Realtime Database (not Firestore) for real-time streaming
- **Path:** `trip_chats/{chatId}/messages/{messageId}`
- **Access rule:** Only users with a confirmed booking can join a trip chat

## What's Done

| Layer | Status | File |
|-------|--------|------|
| TripChat model | Done | `lib/src/features/chat/domain/trip_chat.dart` |
| ChatMessage model | Done | `lib/src/features/chat/domain/chat_message.dart` |
| ChatRepository | Done | `lib/src/features/chat/data/chat_repository.dart` |
| ChatAccessService | Done | `lib/src/features/chat/data/chat_access_service.dart` |
| Riverpod Providers | Done | `lib/src/features/chat/data/chat_providers.dart` |
| Chat List UI | Done (mock data) | `lib/src/features/chat/presentation/chat_list_screen.dart` |
| Chat Detail UI | Done (mock data) | `lib/src/features/chat/presentation/chat_detail_screen.dart` |
| Seed data | Done | `seed_trips_screen.dart` (Step 4) |
| Navigation routes | Done | `/chat`, `/chat/:chatId`, `/trip-chat/:tripId` |

## What's Pending

| Task | Priority | Details |
|------|----------|---------|
| Chat List -> Firebase | HIGH | Replace `_mockChats` with `userChatsProvider(userId)` |
| Chat Detail -> Firebase | HIGH | Replace mock messages with `chatMessagesProvider(chatId)` |
| Trip Detail "Join Chat" | HIGH | Wire up booking validation + navigate |
| Send message | MEDIUM | Connect text field to `chatRepository.sendMessage()` |
| New message creation | MEDIUM | `// TODO: New message` at chat_list_screen.dart:115 |
| Attachments | LOW | Image/file upload not started |

## Access Flow

```
User taps "Chat" on booking card
  -> Navigate to /trip-chat/:tripId (instant, shimmer loading)
  -> ChatDetailScreen checks access via chatAccessService
  -> Gets or creates chat via chatRepository
  -> Streams messages in real-time
```

## Business Rule

Only booked users can join chat:
- Booking status: `confirmed` or `pending` (not `cancelled`)
- Payment status: `success` (not `failed`)
- One group chat per trip (same dates)
