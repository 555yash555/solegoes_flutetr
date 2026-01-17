import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../theme/app_theme.dart';

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

  // Mock data - In real app, this would come from Firestore
  static const List<ChatConversation> _mockChats = [
    ChatConversation(
      id: 'bali_squad',
      name: 'Bali Squad 🌴',
      lastMessage: 'Sarah: Anyone up for surfing tomorrow?',
      lastMessageTime: '2m ago',
      unreadCount: 3,
      isGroup: true,
      isOnline: true,
      gradientStart: '0xFF8B5CF6',
      gradientEnd: '0xFF6366F1',
    ),
    ChatConversation(
      id: 'alex_chen',
      name: 'Alex Chen',
      avatarUrl: 'https://i.pravatar.cc/150?img=12',
      lastMessage: 'Hey! Are you joining the Ladakh trip?',
      lastMessageTime: '1h ago',
      unreadCount: 0,
      isGroup: false,
      isOnline: false,
    ),
    ChatConversation(
      id: 'priya_patel',
      name: 'Priya Patel',
      avatarUrl: 'https://i.pravatar.cc/150?img=5',
      lastMessage: 'Thanks for the recommendation!',
      lastMessageTime: 'Yesterday',
      unreadCount: 0,
      isGroup: false,
      isOnline: false,
    ),
  ];

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
            // Chat list
            Expanded(
              child: _buildChatList(context),
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
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
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
                color: Colors.white,
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
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _mockChats.length,
      itemBuilder: (context, index) {
        final chat = _mockChats[index];
        return _buildChatItem(context, chat);
      },
    );
  }

  Widget _buildChatItem(BuildContext context, ChatConversation chat) {
    return GestureDetector(
      onTap: () => context.push('/chat/${chat.id}'),
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
            // Avatar
            _buildAvatar(chat),
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
                          chat.name,
                          style: AppTextStyles.h5.copyWith(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        chat.lastMessageTime,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chat.lastMessage,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textMuted,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            // Unread badge
            if (chat.unreadCount > 0) ...[
              const SizedBox(width: 12),
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    chat.unreadCount.toString(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(ChatConversation chat) {
    return Stack(
      children: [
        if (chat.isGroup)
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(int.parse(chat.gradientStart ?? '0xFF8B5CF6')),
                  Color(int.parse(chat.gradientEnd ?? '0xFF6366F1')),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                chat.name.isNotEmpty ? chat.name[0].toUpperCase() : 'G',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          )
        else
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: ClipOval(
              child: chat.avatarUrl != null
                  ? Image.network(
                      chat.avatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildAvatarFallback(chat.name),
                    )
                  : _buildAvatarFallback(chat.name),
            ),
          ),
        // Online indicator
        if (chat.isOnline)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: const Color(0xFF22C55E),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.bgDeep,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAvatarFallback(String name) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';
    return Container(
      color: AppColors.primary,
      child: Center(
        child: Text(
          initial,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
