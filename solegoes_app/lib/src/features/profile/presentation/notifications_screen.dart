import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../theme/app_theme.dart';

/// Notification data model
class AppNotification {
  final String id;
  final String type; // 'trip', 'like', 'message', 'system'
  final String title;
  final String message;
  final String? highlightText;
  final String time;
  final bool isUnread;

  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    this.highlightText,
    required this.time,
    this.isUnread = false,
  });
}

/// Notifications screen with notification feed
/// Reference: designs/option15_notifications.html
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  // Mock notification data
  static const List<AppNotification> _todayNotifications = [
    AppNotification(
      id: '1',
      type: 'trip',
      title: 'Trip Confirmed!',
      message: 'Your booking for',
      highlightText: 'Bali Spiritual Awakening',
      time: '2 hours ago',
      isUnread: true,
    ),
    AppNotification(
      id: '2',
      type: 'like',
      title: 'Alex Chen',
      message: 'liked your trip to Ladakh.',
      time: '5 hours ago',
    ),
  ];

  static const List<AppNotification> _yesterdayNotifications = [
    AppNotification(
      id: '3',
      type: 'message',
      title: 'New message in',
      message: '',
      highlightText: 'Bali Squad 🌴',
      time: 'Yesterday',
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
            // Notification list
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Today section
                    _buildSectionTitle('Today'),
                    const SizedBox(height: 12),
                    ..._todayNotifications.map(_buildNotificationItem),
                    const SizedBox(height: 24),
                    // Yesterday section
                    _buildSectionTitle('Yesterday'),
                    const SizedBox(height: 12),
                    ..._yesterdayNotifications.map(_buildNotificationItem),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHover,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: const Icon(
                    LucideIcons.chevronLeft,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          // Mark all as read button
          GestureDetector(
            onTap: () {
              // TODO: Mark all as read
            },
            child: Text(
              'Mark all as read',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.iconMuted,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildNotificationItem(AppNotification notification) {
    final iconData = _getIconForType(notification.type);
    final iconColor = _getColorForType(notification.type);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceOverlay,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Unread indicator
          if (notification.isUnread)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 3,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          // Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              iconData,
              size: 20,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNotificationText(notification),
                const SizedBox(height: 4),
                Text(
                  notification.time,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationText(AppNotification notification) {
    final spans = <TextSpan>[];

    if (notification.title.isNotEmpty) {
      spans.add(TextSpan(
        text: notification.title,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ));
      if (notification.message.isNotEmpty || notification.highlightText != null) {
        spans.add(const TextSpan(text: ' '));
      }
    }

    if (notification.message.isNotEmpty) {
      spans.add(TextSpan(
        text: notification.message,
        style: const TextStyle(
          color: Colors.white,
        ),
      ));
      if (notification.highlightText != null) {
        spans.add(const TextSpan(text: ' '));
      }
    }

    if (notification.highlightText != null) {
      spans.add(TextSpan(
        text: notification.highlightText,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
      ));

      // Add trailing text for trip confirmation
      if (notification.type == 'trip') {
        spans.add(const TextSpan(
          text: ' has been confirmed.',
          style: TextStyle(
            color: Colors.white,
          ),
        ));
      }
    }

    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 14,
          height: 1.4,
        ),
        children: spans,
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'trip':
        return LucideIcons.zap;
      case 'like':
        return LucideIcons.heart;
      case 'message':
        return LucideIcons.messageCircle;
      default:
        return LucideIcons.bell;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'trip':
        return AppColors.primary;
      case 'like':
        return AppColors.accentRose;
      case 'message':
        return const Color(0xFF22C55E); // Green
      default:
        return AppColors.textSecondary;
    }
  }
}
