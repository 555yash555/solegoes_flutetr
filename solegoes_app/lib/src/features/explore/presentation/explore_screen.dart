import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../theme/app_theme.dart';
import '../../../common_widgets/app_text_field.dart';
import '../../../common_widgets/trip_card.dart';
import '../../../common_widgets/skeletons/trip_card_skeleton.dart';
import '../../trips/data/trip_repository.dart';
import '../../trips/domain/trip.dart';
import 'category_card.dart';

/// Explore screen with Search, Category Grid, and Trending section
class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check for autofocus query param (handles navigation from Home even if widget is alive)
    WidgetsBinding.instance.addPostFrameCallback((_) {
       try {
         final state = GoRouterState.of(context);
         if (state.uri.queryParameters['autofocus'] == 'true' && !_searchFocusNode.hasFocus) {
           _searchFocusNode.requestFocus();
         }
       } catch (_) {
         // Ignore if valid context/state not found
       }
    });

    final allTripsAsync = ref.watch(allTripsProvider);
    final trendingTripsAsync = ref.watch(trendingTripsProvider);

    final isSearching = _searchController.text.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            floating: true,
            backgroundColor: AppColors.bgDeep,
            title: Text(
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
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: AppTextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                hint: 'Where to next?',
                icon: LucideIcons.search,
                onChanged: (value) {
                  setState(() {});
                },
                suffixIcon: isSearching
                  ? IconButton(
                      icon: const Icon(LucideIcons.x, size: 16, color: Colors.white),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                    )
                  : null,
              ),
            ),
          ),

          if (isSearching)
            allTripsAsync.when(
              data: (allTrips) {
                 final query = _searchController.text.toLowerCase();
                 final results = allTrips.where((trip) {
                   return trip.title.toLowerCase().contains(query) ||
                          trip.location.toLowerCase().contains(query) ||
                          trip.categories.any((c) => c.toLowerCase().contains(query));
                 }).toList();

                 if (results.isEmpty) {
                   return SliverFillRemaining(
                     child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(LucideIcons.search, size: 48, color: Colors.white24),
                            const SizedBox(height: 16),
                            Text(
                              'No matching trips found',
                              style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                     ),
                   );
                 }

                 return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final trip = results[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: TripCard(
                              tripId: trip.tripId,
                              title: trip.title,
                              imageUrl: trip.imageUrl,
                              duration: '${trip.duration} Days',
                              location: trip.location,
                              price: trip.price,
                              rating: trip.rating,
                              width: double.infinity,
                              startDate: trip.startDate,
                            ),
                          );
                        },
                        childCount: results.length,
                      ),
                    ),
                 );
              },
              loading: () => const SliverFillRemaining(child: Center(child: CircularProgressIndicator())), // Or skeleton
              error: (_,__) => const SliverToBoxAdapter(),
            )
          else ...[
            // Category Grid Section
            allTripsAsync.when(
              data: (allTrips) {
                // 1. Extract unique categories
                final uniqueCategories = <String>{};
                for (final trip in allTrips) {
                  uniqueCategories.addAll(trip.categories.where((c) => c.isNotEmpty));
                }

                final categories = uniqueCategories.toList()..sort();

                if (categories.isEmpty) return const SliverToBoxAdapter();

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.1, // Slightly wider than square
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final category = categories[index];
                        // Use a dynamic image service that supports keywords
                        final imageUrl = 'https://loremflickr.com/800/600/$category,travel/all';
                        
                        return CategoryCard(
                          category: category,
                          imageUrl: imageUrl,
                          onTap: () => context.pushNamed(
                            'categoryTrips', 
                            pathParameters: {'category': category},
                          ),
                        );
                      },
                      childCount: categories.length,
                    ),
                  ),
                );
              },
              loading: () => SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.1,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Container(
                      decoration: BoxDecoration(
                        color: AppColors.bgSurface,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(color: AppColors.borderGlass),
                      ),
                    ),
                    childCount: 4,
                  ),
                ),
              ),
              error: (_, __) => const SliverToBoxAdapter(),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),

            // Trending Section Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Trending Now',
                  style: AppTextStyles.h3.copyWith(color: Colors.white),
                ),
              ),
            ),

            // Trending List
            trendingTripsAsync.when(
              data: (trips) {
                if (trips.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No trending trips yet.', style: TextStyle(color: Colors.white54)),
                    ),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final trip = trips[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: TripCard(
                            tripId: trip.tripId,
                            title: trip.title,
                            imageUrl: trip.imageUrl,
                            duration: '${trip.duration} Days',
                            location: trip.location,
                            price: trip.price,
                            rating: trip.rating,
                            startDate: trip.startDate,
                          ),
                        );
                      },
                      childCount: trips.length,
                    ),
                  ),
                );
              },
              loading: () => SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => const Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: TripCardSkeleton(),
                    ),
                    childCount: 3,
                  ),
                ),
              ),
              error: (err, stack) => SliverToBoxAdapter(child: Text('Error: $err')),
            ),
            
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ], // End of else block
        ],
      ),
    );
  }
}
