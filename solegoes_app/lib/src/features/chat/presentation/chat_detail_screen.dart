import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../theme/app_theme.dart';
import '../../authentication/data/auth_repository.dart';
import '../../trips/data/trip_repository.dart';
import '../data/chat_providers.dart';
import '../domain/chat_message.dart' as domain;
import '../domain/trip_chat.dart';

/// Mock message data model
class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String? senderAvatarUrl;
  final String content;
  final String time;
  final bool isMe;
  final Color? senderColor;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    this.senderAvatarUrl,
    required this.content,
    required this.time,
    this.isMe = false,
    this.senderColor,
  });
}

/// Chat detail screen with messages
/// Reference: designs/option15_chat_detail.html
class ChatDetailScreen extends ConsumerStatefulWidget {
  final String? chatId;
  final String? tripId;

  // Constructor for direct chat access with chatId
  const ChatDetailScreen({
    super.key,
    required String chatId,
  })  : chatId = chatId,
        tripId = null;

  // Constructor for instant navigation with tripId
  const ChatDetailScreen.fromTripId({
    super.key,
    required String tripId,
  })  : tripId = tripId,
        chatId = null;

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  // Track if we've already triggered chat creation for a tripId
  final Set<String> _chatCreationTriggered = {};

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
   if (text.isEmpty) return;

    final authUser = ref.read(authStateChangesProvider).value;
    if (authUser == null) return;

    // Get chatId - either from direct chatId or from tripChat lookup
    String? chatId = widget.chatId;
    if (chatId == null && widget.tripId != null) {
      // If using tripId, try to get chatId from provider
      final chatAsync = ref.read(tripChatProvider(widget.tripId!));
      chatId = chatAsync.value?.chatId;
    }
    
    if (chatId == null) return; // Can't send without chatId

    final repository = ref.read(chatRepositoryProvider);

    try {
      await repository.sendMessage(
        chatId: chatId,
        senderId: authUser.uid,
        senderName: authUser.displayName ?? 'User',
        senderAvatar: authUser.photoUrl,
        content: text,
      );

      _messageController.clear();

      // Scroll to bottom after sending
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      // Show error message 
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message: $e')),
        );
      }
    }
  }

  String _formatTime(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final amPm = date.hour >= 12 ? 'PM' : 'AM';
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute $amPm';
  }

  @override
  Widget build(BuildContext context) {
    // If constructed with tripId, look up the chat first
    if (widget.tripId != null) {
      return _buildWithTripId(context, widget.tripId!);
    }
    
    // Normal flow with chatId
    return _buildWithChatId(context, widget.chatId!);
  }

  /// Build chat screen when navigating with tripId (instant navigation)
  Widget _buildWithTripId(BuildContext context, String tripId) {
    final chatAsync = ref.watch(tripChatProvider(tripId));

    return chatAsync.when(
      loading: () => Scaffold(
        backgroundColor: AppColors.bgDeep,
        body: Column(
          children: [
            _buildHeaderSkeleton(),
            Expanded(child: _buildShimmerLoading()),
            _buildInputArea(),
          ],
        ),
      ),
      error: (error, stack) => Scaffold(
        backgroundColor: AppColors.bgDeep,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(LucideIcons.chevronLeft),
            onPressed: () => context.pop(),
          ),
          title: const Text('Chat'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.alertCircle, size: 64, color: AppColors.error),
              const SizedBox(height: 16),
              Text(
                'Error loading chat',
                style: TextStyle(color: AppColors.textMuted),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: TextStyle(color: AppColors.textTertiary, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      data: (chat) {
        if (chat == null) {
          // No chat exists - create it automatically
          return _buildCreatingChat(tripId);
        }
        
        // Chat exists - render with chatId
        return _buildWithChatId(context, chat.chatId);
      },
    );
  }

  /// Shows loading state while creating chat for the first time
  Widget _buildCreatingChat(String tripId) {
    // Get trip details for chat creation
    final tripAsync = ref.watch(tripProvider(tripId));
    
    return tripAsync.when(
      loading: () => Scaffold(
        backgroundColor: AppColors.bgDeep,
        body: Column(
          children: [
            _buildHeaderSkeleton(),
            Expanded(child: _buildShimmerLoading()),
            _buildInputArea(),
          ],
        ),
      ),
      error: (error, stack) => Scaffold(
        backgroundColor: AppColors.bgDeep,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(LucideIcons.chevronLeft),
            onPressed: () => context.pop(),
          ),
          title: const Text('Chat'),
        ),
        body: Center(
          child: Text('Error loading trip: $error'),
        ),
      ),
      data: (trip) {
        if (trip == null) {
          return Scaffold(
            backgroundColor: AppColors.bgDeep,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(LucideIcons.chevronLeft),
                onPressed: () => context.pop(),
              ),
              title: const Text('Chat'),
            ),
            body: const Center(
              child: Text('Trip not found'),
            ),
          );
        }
        
        // Only trigger chat creation once per tripId
        if (!_chatCreationTriggered.contains(tripId)) {
          _chatCreationTriggered.add(tripId);
          // Schedule creation for after build completes
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _createChatForTrip(tripId, trip);
          });
        }
        
        // Show loading while chat is being created
        return Scaffold(
          backgroundColor: AppColors.bgDeep,
          body: Column(
            children: [
              _buildHeaderSkeleton(),
              Expanded(child: _buildShimmerLoading()),
              _buildInputArea(),
            ],
          ),
        );
      },
    );
  }

  /// Creates chat for trip (called once when chat doesn't exist)
  Future<void> _createChatForTrip(String tripId, trip) async {
    final user = ref.read(authStateChangesProvider).value;
    if (user == null) return;

    final chatRepository = ref.read(chatRepositoryProvider);
    
    try {
      await chatRepository.createTripChat(
        tripId: tripId,
        tripTitle: trip.title.replaceAll('\\n', ' '),
        tripLocation: trip.location,
        tripStartDate: trip.startDate ?? DateTime.now(),
        tripEndDate: trip.endDate ?? DateTime.now().add(const Duration(days: 7)),
        userId: user.uid,
        userName: user.displayName ?? 'User',
      );
      
      // Chat created! Provider will auto-refresh and show the chat
      ref.invalidate(tripChatProvider(tripId));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating chat: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  /// Build chat screen with chatId (normal flow)
  Widget _buildWithChatId(BuildContext context, String chatId) {
    // Watch messages from Firebase
    final messagesAsync = ref.watch(chatMessagesProvider(chatId));

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Column(
        children: [
          // Header
          _buildHeaderForChatId(context, chatId),
          // Messages - with Firebase data
          Expanded(
            child: messagesAsync.when(
              loading: () => _buildShimmerLoading(),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.alertCircle, size: 64, color: AppColors.error),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading messages',
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              data: (messages) => _buildMessageListWithData(messages),
            ),
          ),
          // Input area
          _buildInputAreaForChatId(chatId),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Date header shimmer
        Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.3, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Container(
                  width: 80,
                  height: 24,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHover,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                ),
              );
            },
            onEnd: () => setState(() {}), // Restart animation
          ),
        ),
        // Message bubbles shimmer
        ...[1, 2, 3, 4].map((i) => TweenAnimationBuilder<double>(
          key: ValueKey(i),
          tween: Tween(begin: 0.3, end: 1.0),
          duration: Duration(milliseconds: 800 + (i * 100)),
          curve: Curves.easeInOut,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: i % 2 == 0 ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    if (i % 2 == 1) ...[
                      // Avatar for received messages
                      Container(
                        width: 32,
                        height: 32,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceHover,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                    // Message bubble
                    Container(
                      width: 200,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceHover,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          onEnd: () => setState(() {}), // Restart animation
        )),
      ],
    );
  }

  Widget _buildHeaderForChatId(BuildContext context, String chatId) {
    // Watch chat data for header info
    final chatAsync = ref.watch(chatByIdProvider(chatId));

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 8,
            left: 8,
            right: 16,
            bottom: 12,
          ),
          decoration: BoxDecoration(
            color: AppColors.bgDeep.withValues(alpha: 0.8),
            border: const Border(
              bottom: BorderSide(color: AppColors.borderGlass),
            ),
          ),
          child: chatAsync.when(
            loading: () => _buildHeaderSkeleton(),
            error: (_, __) => _buildHeaderSkeleton(),
            data: (chat) {
              if (chat == null) return _buildHeaderSkeleton();
              
             return Row(
            children: [
              // Back button
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    LucideIcons.chevronLeft,
                    size: 24,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Group avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.2),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: const Icon(
                  LucideIcons.users,
                  size: 20,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 12),
              // Chat info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat.tripTitle,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF22C55E),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${chat.participantCount} members',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // More button
              GestureDetector(
                onTap: () {
                  // Show options menu
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    LucideIcons.moreVertical,
                    size: 20,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSkeleton() {
    return Row(
      children: [
        // Back button
        GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.chevronLeft,
              size: 24,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Group avatar placeholder
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.surfaceOverlay,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        // Chat info placeholder
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 120,
                height: 14,
                decoration: BoxDecoration(
                  color: AppColors.surfaceOverlay,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: 80,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.surfaceOverlay,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessageListWithData(List<domain.ChatMessage> messages) {
    final authUser = ref.watch(authStateChangesProvider).value;
    
    if (messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.messageCircle, size: 64, color: AppColors.textHint),
            const SizedBox(height: 16),
            Text(
              'No messages yet',
              style: AppTextStyles.h5,
            ),
            const SizedBox(height: 8),
            Text(
              'Start the conversation!',
              style: TextStyle(color: AppColors.textMuted),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: messages.length + 1, // +1 for date header
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildDateHeader('Today');
        }
        final message = messages[index - 1];
        final isMe = authUser != null && message.senderId == authUser.uid;
        return _buildMessageFromDomain(message, isMe);
      },
    );
  }

  Widget _buildMessageFromDomain(domain.ChatMessage message, bool isMe) {
    // Format time
    final time = _formatTime(message.timestamp);

    if (isMe) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(4),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  message.content,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      // Received message
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Avatar
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.surfacePressed),
              ),
              child: Center(
                child: Text(
                  message.senderName.isNotEmpty ? message.senderName[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Message content
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sender name
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 4),
                    child: Text(
                      message.senderName,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  // Bubble
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.bgSurface,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(4),
                      ),
                      border: Border.all(color: AppColors.borderGlass),
                    ),
                    child: Text(
                      message.content,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildDateHeader(String date) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.surfaceHover,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(color: AppColors.surfaceHover),
        ),
        child: Text(
          date,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: AppColors.textHint,
          ),
        ),
      ),
    );
  }


  // Wrapper for input area when using chatId
  Widget _buildInputAreaForChatId(String chatId) => _buildInputArea();

  Widget _buildInputArea() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.only(
            left: 12,
            right: 12,
            top: 12,
            bottom: MediaQuery.of(context).padding.bottom + 12,
          ),
          decoration: BoxDecoration(
            color: AppColors.bgDeep.withValues(alpha: 0.95),
            border: const Border(
              top: BorderSide(color: AppColors.borderGlass),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Attach button
              GestureDetector(
                onTap: () {
                  // Show attachment options
                },
                child: Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.only(bottom: 2),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHover,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.surfacePressed),
                  ),
                  child: Icon(
                    LucideIcons.plus,
                    size: 20,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Text field
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 100),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHover,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.surfacePressed),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: 'Send a message...',
                            hintStyle: TextStyle(
                              fontSize: 15,
                              color: AppColors.textHint,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      // Emoji button
                      GestureDetector(
                        onTap: () {
                          // Show emoji picker
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8, bottom: 8),
                          child: Icon(
                            LucideIcons.smile,
                            size: 20,
                            color: AppColors.textHint,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Send button
              GestureDetector(
                onTap: _sendMessage,
                child: Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.only(bottom: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(
                    LucideIcons.send,
                    size: 18,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
