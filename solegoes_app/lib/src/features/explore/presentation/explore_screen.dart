import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../theme/app_theme.dart';
import '../../../common_widgets/category_pill.dart';
import '../../trips/data/trip_repository.dart';
import '../../trips/domain/trip.dart';

/// Explore screen with search, categories, and varied trip layouts
class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allTripsAsync = ref.watch(allTripsProvider);

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            floating: true,
            backgroundColor: AppColors.bgDeep,
            title: const Text(
              'Explore',
              style: AppTextStyles.h2.copyWith(color: Colors.white),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  // TODO: Open map view
                },
                icon: const Icon(LucideIcons.map, color: Colors.white),
              ),
            ],
          ),

          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.bgSurface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search destinations, trips...',
                    hintStyle: TextStyle(color: AppColors.textHint),
                    prefixIcon: Icon(
                      LucideIcons.search,
                      color: AppColors.textHint,
                      size: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  onChanged: (value) {
                    // TODO: Implement search
                  },
                ),
              ),
            ),
          ),

          // Category Pills - Dynamically generated from trip data
          allTripsAsync.when(
            data: (allTrips) {
              // Get unique categories from trips with counts
              final categories = <String, int>{'all': allTrips.length};
              for (final trip in allTrips) {
                if (trip.categories.isNotEmpty) {
                  // A trip can have multiple categories, count each
                  for (final cat in trip.categories) {
                    if (cat.isNotEmpty) {
                      categories[cat] = (categories[cat] ?? 0) + 1;
                    }
                  }
                }
              }

              // Sort categories: 'all' first, then by count descending
              final sortedCategories = categories.entries.toList()
                ..sort((a, b) {
                  if (a.key == 'all') return -1;
                  if (b.key == 'all') return 1;
                  return b.value.compareTo(a.value);
                });

              return SliverToBoxAdapter(
                child: SizedBox(
                  height: 44,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: sortedCategories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final entry = sortedCategories[index];
                      final category = entry.key;
                      
                      // Format label
                      String label;
                      if (category == 'all') {
                        label = 'All Trips';
                      } else {
                        // Capitalize first letter
                        label = category[0].toUpperCase() + category.substring(1);
                        // Handle special cases
                        if (category == 'city') label = 'City Break';
                      }

                      return CategoryPill(
                        label: label,
                        isSelected: _selectedCategory == category,
                        onTap: () => setState(() => _selectedCategory = category),
                      );
                    },
                  ),
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(
              child: SizedBox(
                height: 44,
                child: Center(child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )),
              ),
            ),
            error: (_, __) => const SliverToBoxAdapter(child: SizedBox(height: 44)),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Trending Section Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedCategory == 'all' 
                        ? 'Trending Now' 
                        : '${_selectedCategory[0].toUpperCase()}${_selectedCategory.substring(1)} Trips',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.2,
                    ),
                  ),
                  if (_selectedCategory == 'all')
                    TextButton(
                      onPressed: () {
                        // TODO: Show all trending
                      },
                      child: Text(
                        'See All',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // Trip Cards with Varied Layouts - Filtered by category
          allTripsAsync.when(
            data: (allTrips) {
              // Filter trips by selected category
              final filteredTrips = _selectedCategory == 'all'
                  ? allTrips
                  : allTrips.where((trip) => trip.categories.contains(_selectedCategory)).toList();

              return _buildTripLayouts(filteredTrips);
            },
            loading: () => const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
            error: (error, stack) => SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    'Error loading trips: $error',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildTripLayouts(List<Trip> trips) {
    if (trips.isEmpty) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Text(
              'No trips found',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          // Determine layout pattern
          if (index == 0) {
            // First item: Large featured card
            return _buildLargeFeaturedCard(trips[0]);
          } else if (index == 1 && trips.length > 2) {
            // Second row: Two medium cards
            return _buildTwoMediumCards(
              trips.length > 1 ? trips[1] : trips[0],
              trips.length > 2 ? trips[2] : trips[0],
            );
          } else if (index == 2 && trips.length > 5) {
            // Third row: Three small cards
            return _buildThreeSmallCards(
              trips.length > 3 ? trips[3] : trips[0],
              trips.length > 4 ? trips[4] : trips[0],
              trips.length > 5 ? trips[5] : trips[0],
            );
          } else if (index == 3 && trips.length > 6) {
            // Fourth row: Horizontal scroll
            return _buildHorizontalScroll(trips.skip(6).take(5).toList());
          } else if (index > 3 && trips.length > index * 2) {
            // Remaining: Two medium cards
            final idx1 = index * 2;
            final idx2 = idx1 + 1;
            if (trips.length > idx2) {
              return _buildTwoMediumCards(trips[idx1], trips[idx2]);
            }
          }
          return const SizedBox.shrink();
        },
        childCount: (trips.length / 2).ceil() + 2,
      ),
    );
  }

  Widget _buildLargeFeaturedCard(Trip trip) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: GestureDetector(
        onTap: () => context.push('/trip/${trip.tripId}'),
        child: Container(
          height: 240,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.borderGlass),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                child: Image.network(
                  trip.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.bgSurface,
                    child: const Icon(LucideIcons.image, color: AppColors.textTertiary),
                  ),
                ),
              ),
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.scrim,
                    ],
                  ),
                ),
              ),
              // Content
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${trip.duration} Days • ${trip.location}',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
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
                                color: AppColors.textMuted,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              '₹${trip.price.toStringAsFixed(0)}',
                              style: const AppTextStyles.h2.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(AppRadius.full),
                          ),
                          child: const Text(
                            'View Trip',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Rating badge
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.scrim,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(LucideIcons.star, size: 12, color: Color(0xFFFBBF24)),
                      const SizedBox(width: 4),
                      Text(
                        '4.9',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
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

  Widget _buildTwoMediumCards(Trip trip1, Trip trip2) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          Expanded(child: _buildMediumCard(trip1)),
          const SizedBox(width: 12),
          Expanded(child: _buildMediumCard(trip2)),
        ],
      ),
    );
  }

  Widget _buildMediumCard(Trip trip) {
    return GestureDetector(
      onTap: () => context.push('/trip/${trip.tripId}'),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.borderGlass),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Image.network(
                trip.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.bgSurface,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.md),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.scrim,
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${trip.duration} Days',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹${trip.price.toStringAsFixed(0)}',
                        style: const AppTextStyles.h5.copyWith(color: Colors.white),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.shimmer,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          LucideIcons.arrowRight,
                          size: 16,
                          color: Colors.white,
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

  Widget _buildThreeSmallCards(Trip trip1, Trip trip2, Trip trip3) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          Expanded(child: _buildSmallCard(trip1)),
          const SizedBox(width: 8),
          Expanded(child: _buildSmallCard(trip2)),
          const SizedBox(width: 8),
          Expanded(child: _buildSmallCard(trip3)),
        ],
      ),
    );
  }

  Widget _buildSmallCard(Trip trip) {
    return GestureDetector(
      onTap: () => context.push('/trip/${trip.tripId}'),
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.borderGlass),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Image.network(
                trip.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.bgSurface,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.md),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.scrim,
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.location,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '₹${(trip.price / 1000).toStringAsFixed(0)}k',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
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

  Widget _buildHorizontalScroll(List<Trip> trips) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Quick Escapes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: trips.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: index < trips.length - 1 ? 12 : 0),
                child: SizedBox(
                  width: 120,
                  child: _buildSmallCard(trips[index]),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
