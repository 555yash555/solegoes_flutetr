import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../common_widgets/app_button.dart';
import '../../../common_widgets/app_card.dart';
import '../../../common_widgets/app_image.dart';
import '../../../theme/app_theme.dart';
import '../../bookings/domain/booking.dart';
import 'dart:ui';

class BookingCard extends StatelessWidget {
  final Booking booking;

  const BookingCard({
    super.key,
    required this.booking,
  });

  bool get isPast =>
      booking.status == BookingStatus.completed ||
      booking.status == BookingStatus.cancelled;

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.confirmed:
        return const Color(0xFF22C55E); // Vivid Green
      case BookingStatus.pending:
        return const Color(0xFFEAB308); // Yellow
      case BookingStatus.cancelled:
        return AppColors.accentRose;
      case BookingStatus.completed:
        return AppColors.primary;
    }
  }

  String _getStatusText(BookingStatus status) {
    switch (status) {
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.cancelled:
        return 'Cancelled';
      case BookingStatus.completed:
        return 'Completed';
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => context.push('/trip/${booking.tripId}'),
      padding: EdgeInsets.zero,
      borderRadius: AppRadius.md,
      backgroundColor: AppColors.bgCard,
      border: Border.all(color: AppColors.borderSubtle),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section with Glass Badge
          SizedBox(
            height: 160,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppRadius.md),
                  ),
                  child: AppImage(
                    imageUrl: booking.tripImageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    color: isPast ? Colors.grey : null,
                    colorBlendMode: isPast ? BlendMode.saturation : null,
                  ),
                ),
                // Glassmorphic Status Badge
                Positioned(
                  top: 12,
                  right: 12,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getStatusColor(booking.status).withOpacity(0.9),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Text(
                          _getStatusText(booking.status),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black, // High contrast
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Content Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title & Duration Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        booking.tripTitle,
                        style: AppTextStyles.h4,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${booking.tripDuration} Days',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Date & Location Row
                Row(
                  children: [
                    Icon(LucideIcons.calendar,
                        size: 14, color: AppColors.textTertiary),
                    const SizedBox(width: 6),
                    Text(
                      _formatDate(booking.bookingDate),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(LucideIcons.mapPin,
                        size: 14, color: AppColors.textTertiary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        booking.tripLocation,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Actions
                if (!isPast)
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          text: 'View Details',
                          onPressed: () => context.push('/trip/${booking.tripId}'),
                          variant: AppButtonVariant.outline, // Subtle
                          size: AppButtonSize.small,
                          isFullWidth: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppButton(
                          text: 'Chat',
                          onPressed: () {
                             ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Chat feature coming soon!'),
                                backgroundColor: AppColors.primary,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            );
                          },
                          variant: AppButtonVariant.primary, // Emphasis
                          size: AppButtonSize.small,
                          isFullWidth: true,
                        ),
                      ),
                    ],
                  ),
                   if (isPast)
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          text: 'View Details',
                          onPressed: () => context.push('/trip/${booking.tripId}'),
                          variant: AppButtonVariant.outline,
                          size: AppButtonSize.small,
                          isFullWidth: true,
                        ),
                      ),
                      if (booking.status == BookingStatus.completed) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppButton(
                            text: 'Book Again',
                            onPressed: () => context.push('/trip/${booking.tripId}'),
                            variant: AppButtonVariant.primary,
                            size: AppButtonSize.small,
                            isFullWidth: true,
                          ),
                        ),
                      ],
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
