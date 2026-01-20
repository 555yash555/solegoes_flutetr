import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import 'app_card.dart';
import 'app_image.dart';

/// Layout mode for TripCard
enum TripCardLayout {
  horizontal, // For horizontal scrolling lists
  grid,       // For 2-column grids
}

/// Flexible trip card that adapts to different layout contexts
class TripCard extends StatelessWidget {
  final String tripId;
  final String title;
  final String imageUrl;
  final String duration;
  final String? location;
  final String? category;
  final String? groupSize;
  final double price;
  final double rating;
  final DateTime? startDate;
  final TripCardLayout layout;
  final double? width;  // Optional width, defaults to 260 for horizontal, null for full-width

  const TripCard({
    super.key,
    required this.tripId,
    required this.title,
    required this.imageUrl,
    required this.duration,
    this.location,
    this.category,
    this.groupSize,
    required this.price,
    required this.rating,
    this.startDate,
    this.layout = TripCardLayout.horizontal, // Default to horizontal
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    switch (layout) {
      case TripCardLayout.horizontal:
        return _HorizontalTripCard(
          tripId: tripId,
          title: title,
          imageUrl: imageUrl,
          duration: duration,
          location: location,
          category: category,
          groupSize: groupSize,
          price: price,
          rating: rating,
          startDate: startDate,
          width: width,
        );
      case TripCardLayout.grid:
        return _GridTripCard(
          tripId: tripId,
          title: title,
          imageUrl: imageUrl,
          duration: duration,
          location: location,
          category: category,
          groupSize: groupSize,
          price: price,
          rating: rating,
          startDate: startDate,
        );
    }
  }
}

/// Horizontal scrolling trip card with intrinsic sizing
class _HorizontalTripCard extends StatelessWidget {
  final String tripId;
  final String title;
  final String imageUrl;
  final String duration;
  final String? location;
  final String? category;
  final String? groupSize;
  final double price;
  final double rating;
  final DateTime? startDate;
  final double? width;

  const _HorizontalTripCard({
    required this.tripId,
    required this.title,
    required this.imageUrl,
    required this.duration,
    this.location,
    this.category,
    this.groupSize,
    required this.price,
    required this.rating,
    this.startDate,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => context.push('/trip/$tripId'),
        padding: EdgeInsets.zero,
        borderRadius: AppRadius.md,
        backgroundColor: AppColors.bgCard,
        border: Border.all(color: AppColors.borderSubtle),
        child: SizedBox(
          width: width ?? 260,  // Default to 260 if not specified
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image section
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadius.md),
              ),
              child: Stack(
                children: [
                  // Image
                  AppImage(
                    imageUrl: imageUrl,
                    height: 120, // Reduced height
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  // Rating badge
                  if (rating > 0)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.scrim,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              LucideIcons.star,
                              size: 12,
                              color: Color(0xFFFACC15),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Content section
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    // Title
                    Text(
                      title.replaceAll(r'\n', ' '), 
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2, 
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Details
                    Text(
                      [
                        duration,
                        if (location != null) location,
                        if (category != null) category,
                        if (groupSize != null) groupSize,
                      ].join(' • '),
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textPrimary.withValues(alpha: 0.6),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    
                    // Start Date badge (if available)
                    if (startDate != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceHover,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppColors.borderGlass),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(LucideIcons.calendar, size: 10, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              'Starts ${DateFormat('MMM d').format(startDate!)}',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],

                    // Price and arrow
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₹${price.toStringAsFixed(0).replaceAllMapped(
                                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                (Match m) => '${m[1]},',
                              )}',
                          style: AppTextStyles.h5.copyWith(color: AppColors.textPrimary),
                        ),
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceHover,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.borderSubtle),
                          ),
                          child: const Icon(
                            LucideIcons.arrowRight,
                            size: 14,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
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

/// Grid trip card (for 2-column layouts)
class _GridTripCard extends StatelessWidget {
  final String tripId;
  final String title;
  final String imageUrl;
  final String duration;
  final String? location;
  final String? category;
  final String? groupSize;
  final double price;
  final double rating;
  final DateTime? startDate;

  const _GridTripCard({
    required this.tripId,
    required this.title,
    required this.imageUrl,
    required this.duration,
    this.location,
    this.category,
    this.groupSize,
    required this.price,
    required this.rating,
    this.startDate,
  });

  @override
  Widget build(BuildContext context) {
    // For now, use horizontal card layout
    // TODO: Implement grid-specific layout
    return _HorizontalTripCard(
      tripId: tripId,
      title: title,
      imageUrl: imageUrl,
      duration: duration,
      location: location,
      category: category,
      groupSize: groupSize,
      price: price,
      rating: rating,
      startDate: startDate,
    );
  }
}

/// Featured trip card (large hero card)
class FeaturedTripCard extends StatelessWidget {
  final String tripId;
  final String title;
  final String imageUrl;
  final String duration;
  final String location;
  final double price;
  final bool isTrending;

  const FeaturedTripCard({
    super.key,
    required this.tripId,
    required this.title,
    required this.imageUrl,
    required this.duration,
    required this.location,
    required this.price,
    this.isTrending = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => context.push('/trip/$tripId'),
      padding: EdgeInsets.zero,
      borderRadius: AppRadius.lg,
      boxShadow: [
        BoxShadow(
          color: AppColors.overlay,
          blurRadius: 40,
          offset: const Offset(0, 10),
        ),
      ],
      child: SizedBox(
        height: 380,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              AppImage(
                imageUrl: imageUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorWidget: Container(
                  color: AppColors.bgSurface,
                  child: Center(
                    child: Icon(
                      LucideIcons.image,
                      color: AppColors.textTertiary,
                      size: 60,
                    ),
                  ),
                ),
              ),
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.shimmer,
                      AppColors.scrim,
                    ],
                  ),
                ),
              ),
              // Trending badge
              if (isTrending)
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.shimmer,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      border: Border.all(
                        color: AppColors.shimmer,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF4ADE80),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Trending Now',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              // Favorite button
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.shimmer,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.shimmer,
                    ),
                  ),
                  child: const Icon(
                    LucideIcons.heart,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              // Content
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title.replaceAll(r'\n', '\n'),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            LucideIcons.calendar,
                            size: 16,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            duration,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Icon(
                            LucideIcons.mapPin,
                            size: 16,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            location,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'STARTING FROM',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                  color: AppColors.textMuted,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '₹${price.toStringAsFixed(0).replaceAllMapped(
                                      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                      (Match m) => '${m[1]},',
                                    )}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(AppRadius.full),
                            ),
                            child: Text(
                              'View Trip',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
