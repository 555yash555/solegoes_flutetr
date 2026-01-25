import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/trip_chat.dart';
import '../domain/chat_message.dart';
import 'chat_repository.dart';
import 'chat_access_service.dart';

part 'chat_providers.g.dart';

/// Provider for ChatRepository instance
@riverpod
ChatRepository chatRepository(Ref ref) {
  return ChatRepository(FirebaseDatabase.instance.ref());
}

/// Provider for ChatAccessService instance
@riverpod
ChatAccessService chatAccessService(Ref ref) {
  return ChatAccessService(FirebaseFirestore.instance);
}

/// Provider to watch all chats for the current user
@riverpod
Stream<List<TripChat>> userChats(Ref ref, String userId) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.watchUserChats(userId);
}

/// Provider to watch messages for a specific chat
@riverpod
Stream<List<ChatMessage>> chatMessages(Ref ref, String chatId) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.watchMessages(chatId);
}

/// Provider to get a chat by its chatId
@riverpod
Future<TripChat?> chatById(Ref ref, String chatId) async {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.getChatById(chatId);
}

/// Provider to get a chat for a specific trip
@riverpod
Future<TripChat?> tripChat(Ref ref, String tripId) async {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.getChatForTrip(tripId);
}
