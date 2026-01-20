import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../theme/app_theme.dart';
import '../../../common_widgets/trip_card.dart';
import '../../../common_widgets/skeletons/trip_card_skeleton.dart';
import '../../trips/data/trip_repository.dart';
import '../domain/trip_filter.dart';

class SearchResultsScreen extends ConsumerStatefulWidget {
  final TripFilter filter;

  const SearchResultsScreen({
    super.key,
    required this.filter,
  });

  @override
  ConsumerState<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends ConsumerState<SearchResultsScreen> {
  @override
  Widget build(BuildContext context) {
    // For now, we fetch all trips and filter client-side.
    // In a production app with thousands of records, we'd use Algolia or a specific Firestore index.
    final allTripsAsync = ref.watch(allTripsProvider);

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      appBar: AppBar(
        title: const Text('Search Results'),
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: const Icon(LucideIcons.chevronLeft, size: 24),
        ),
        actions: [
          // "Modify" button to go back to filters
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surfaceOverlay,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.slidersHorizontal, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 6),
                  Text(
                    'Modify',
                    style: AppTextStyles.labelSmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: allTripsAsync.when(
        data: (trips) {
          // Filter Logic
          final filteredTrips = trips.where((trip) {
            // 1. Budget Filter
            final budget = widget.filter.budgetRange;
            if (budget != null) {
              if (trip.price < budget.start || trip.price > budget.end) {
                return false;
              }
            }

            // 2. Category Filter (OR logic: match any selected category)
            // If no categories selected, ignore this filter
            if (widget.filter.categories.isNotEmpty) {
              final tripCategories = trip.categories.map((e) => e.toLowerCase()).toList();
              final hasMatch = widget.filter.categories.any((cat) => 
                  tripCategories.contains(cat.toLowerCase()));
              if (!hasMatch) return false;
            }

            // 3. Date Filter
            final dateRange = widget.filter.dateRange;
            if (dateRange != null) {
               // Check if trip starts within the selected range
               if (trip.startDate != null) {
                 if (trip.startDate!.isBefore(dateRange.start) || trip.startDate!.isAfter(dateRange.end)) {
                   return false;
                 }
               }
            }

            return true;
          }).toList();

          if (filteredTrips.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(LucideIcons.searchX, size: 48, color: AppColors.textTertiary),
                   const SizedBox(height: 16),
                   Text('No trips found', style: AppTextStyles.h4),
                   const SizedBox(height: 8),
                   Text(
                     'Try adjusting your filters',
                     style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                   ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              mainAxisExtent: 294,
            ),
            itemCount: filteredTrips.length,
            itemBuilder: (context, index) {
              final trip = filteredTrips[index];
              return TripCard(
                tripId: trip.tripId,
                title: trip.title,
                imageUrl: trip.imageUrl,
                duration: '${trip.duration} Days',
                location: trip.location,
                price: trip.price,
                rating: trip.rating,
                startDate: trip.startDate,
                layout: TripCardLayout.grid,
              );
            },
          );
        },
        loading: () => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: 4,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (_, __) => const TripCardSkeleton(),
        ),
        error: (err, stack) => Center(
          child: Text('Error loading trips: $err', style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
