import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../theme/app_theme.dart';
import '../../../common_widgets/trip_card.dart';
import '../../../common_widgets/skeletons/trip_card_skeleton.dart';
import '../../trips/data/trip_repository.dart';
import '../../trips/domain/trip.dart';

class CategoryTripsScreen extends ConsumerWidget {
  final String category;

  const CategoryTripsScreen({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Capitalize for display
    final displayTitle = category.isNotEmpty
        ? category[0].toUpperCase() + category.substring(1)
        : category;

    // We can filter the stream of all trips, or add a specific query method.
    // Filtering client-side is fine for < 1000 trips.
    final allTripsAsync = ref.watch(allTripsProvider);

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            backgroundColor: AppColors.bgDeep,
            leading: IconButton(
              icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            title: Text(
              '$displayTitle Trips',
              style: AppTextStyles.h3.copyWith(color: Colors.white),
            ),
            pinned: true,
          ),

          // Trip List
          allTripsAsync.when(
            data: (allTrips) {
              final categoryTrips = allTrips.where((trip) {
                // Case-insensitive check
                return trip.categories.any((c) =>
                    c.toLowerCase() == category.toLowerCase());
              }).toList();

              if (categoryTrips.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'No trips found in this category',
                      style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    mainAxisExtent: 280, // Increased to prevent overflow
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final trip = categoryTrips[index];
                      return TripCard(
                        tripId: trip.tripId,
                        title: trip.title,
                        imageUrl: trip.imageUrl,
                        duration: '${trip.duration} Days',
                        location: trip.location,
                        price: trip.price,
                        rating: trip.rating,
                        width: null, // Allow expanding to grid cell
                        startDate: trip.startDate,
                      );
                    },
                    childCount: categoryTrips.length,
                  ),
                ),
              );
            },
            loading: () => SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.6,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => const TripCardSkeleton(),
                  childCount: 6,
                ),
              ),
            ),
            error: (err, stack) => SliverFillRemaining(
              child: Center(
                child: Text('Error: $err',
                    style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
