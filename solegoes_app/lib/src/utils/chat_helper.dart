import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/trips/domain/trip.dart';
import '../features/authentication/data/auth_repository.dart';
import '../features/chat/data/chat_providers.dart';
import '../features/chat/data/chat_access_service.dart';
import '../theme/app_theme.dart';

/// Helper class for chat-related navigation and operations
class ChatHelper {
  /// Attempts to join or create a trip chat
  /// Returns true if successful, false otherwise
  static Future<bool> joinOrCreateTripChat({
    required BuildContext context,
    required WidgetRef ref,
    required String tripId,
    required String tripTitle,
    required String tripLocation,
    DateTime? tripStartDate,
    DateTime? tripEndDate,
  }) async {
    final userAsync = ref.read(authStateChangesProvider);
    final user = userAsync.value;

    if (user == null) {
      // Redirect to login
      if (context.mounted) {
        context.push('/login');
      }
      return false;
    }

    try {
      // Check if user has booked this trip
      final chatAccessService = ref.read(chatAccessServiceProvider);
      final hasAccess = await chatAccessService.canJoinChat(user.uid, tripId);

      if (!context.mounted) return false;

      if (!hasAccess) {
        // User hasn't booked - show error
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('You need to book this trip to access the chat'),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
        return false;
      }

      // User has booking - get or create chat
      final chatRepository = ref.read(chatRepositoryProvider);
      var chat = await chatRepository.getChatForTrip(tripId);

      if (chat == null) {
        // Create new chat
        chat = await chatRepository.createTripChat(
          tripId: tripId,
          tripTitle: tripTitle.replaceAll('\\n', ' '),
          tripLocation: tripLocation,
          tripStartDate: tripStartDate ?? DateTime.now(),
          tripEndDate: tripEndDate ?? DateTime.now().add(const Duration(days: 7)),
          userId: user.uid,
          userName: user.displayName ?? 'User',
        );
      } else {
        // Add user as participant if not already
        final isParticipant = chat.participantIds.containsKey(user.uid);
        if (!isParticipant) {
          await chatRepository.addParticipant(chat.chatId, user.uid);
        }
      }

      // Navigate to chat
      if (context.mounted) {
        context.push('/chat/${chat.chatId}');
      }
      return true;
    } catch (e) {
      if (!context.mounted) return false;

      // Show error
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error joining chat: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
      return false;
    }
  }
}
