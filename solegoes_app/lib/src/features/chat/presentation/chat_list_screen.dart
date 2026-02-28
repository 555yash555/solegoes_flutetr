import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../common_widgets/app_shimmer.dart';
import '../../../theme/app_theme.dart';
import '../../authentication/data/auth_repository.dart';
import '../data/chat_providers.dart';
import '../domain/trip_chat.dart';

/// Mock chat data model
class ChatConversation {
  final String id;
  final String name;
  final String? avatarUrl;
  final String lastMessage;
  final String lastMessageTime;
  final int unreadCount;
  final bool isGroup;
  final bool isOnline;
  final String? gradientStart;
  final String? gradientEnd;

  const ChatConversation({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    this.isGroup = false,
    this.isOnline = false,
    this.gradientStart,
    this.gradientEnd,
  });
}

/// Chat list screen with conversations
/// Reference: designs/option15_chat_list.html
class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            // Search bar
            _buildSearchBar(),
            // Chat list - now with real Firebase data
            Expanded(
              child: _buildChatListWithData(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Messages',
            style: AppTextStyles.h4.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          GestureDetector(
            onTap: () {
              // TODO: New message
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surfaceHover,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: const Icon(
                LucideIcons.edit,
                size: 20,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceHover,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Row(
          children: [
            Icon(
              LucideIcons.search,
              size: 20,
              color: AppColors.textHint,
            ),
            const SizedBox(width: 12),
            Text(
              'Search messages...',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatListWithData(BuildContext context, WidgetRef ref) {
    // Get current user from auth
    final authUser = ref.watch(authStateChangesProvider).value;
    
    if (authUser == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.messageCircle, size: 64, color: AppColors.textHint),
            const SizedBox(height: 16),
            Text(
              'Please sign in to view your chats',
              style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
            ),
          ],
        ),
      );
    }

    // Watch user's chats from Firebase
    final chatsAsync = ref.watch(userChatsProvider(authUser.uid));

    return chatsAsync.when(
      loading: () => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: List.generate(5, (index) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                AppShimmer.circle(size: 48),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppShimmer(
                        width: double.infinity,
                        height: 16,
                        borderRadius: 4,
                      ),
                      const SizedBox(height: 8),
                      AppShimmer(
                        width: 200,
                        height: 14,
                        borderRadius: 4,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ),
      ),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.alertCircle, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              'Error loading chats',
              style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
            ),
            const SizedBox(height: 8),
            Text(
              'Unable to load chats',
              style: AppTextStyles.caption.copyWith(color: AppColors.textHint),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      data: (chats) {
        if (chats.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LucideIcons.messageCircle, size: 64, color: AppColors.textHint),
                const SizedBox(height: 16),
                Text(
                  'No chats yet',
                  style: AppTextStyles.h5,
                ),
                const SizedBox(height: 8),
                Text(
                  'Book a trip to join trip group chats!',
                  style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: chats.length,
          itemBuilder: (context, index) {
            final chat = chats[index];
            return _buildChatItemFromTripChat(context, chat);
          },
        );
      },
    );
  }

  Widget _buildChatItemFromTripChat(BuildContext context, TripChat chat) {
    // Format time
    final lastMsgTime = chat.lastMessageTime;
    String timeDisplay = '';
    if (lastMsgTime != null) {
      final now = DateTime.now();
      final diff = now.difference(lastMsgTime);
      
      if (diff.inMinutes < 60) {
        timeDisplay = '${diff.inMinutes}m ago';
      } else if (diff.inHours < 24) {
        timeDisplay = '${diff.inHours}h ago';
      } else if (diff.inDays == 1) {
        timeDisplay = 'Yesterday';
      } else {
        timeDisplay = '${diff.inDays}d ago';
      }
    }

    return GestureDetector(
      onTap: () => context.push('/chat/${chat.chatId}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceOverlay,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Row(
          children: [
            // Group avatar with gradient
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  chat.tripTitle.isNotEmpty ? chat.tripTitle[0].toUpperCase() : 'T',
                  style: AppTextStyles.h4.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          chat.tripTitle,
                          style: AppTextStyles.h5,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (timeDisplay.isNotEmpty)
                        Text(
                          timeDisplay,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textHint,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chat.lastMessage ?? 'No messages yet',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textMuted,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${chat.participantCount} participants • ${chat.tripLocation}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
