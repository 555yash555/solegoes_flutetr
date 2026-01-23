import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../theme/app_theme.dart';
import '../../authentication/data/auth_repository.dart';
import '../../trips/data/trip_repository.dart';
import '../../../common_widgets/app_text_field.dart';
import '../../../common_widgets/category_pill.dart';
import '../../../common_widgets/trip_card.dart';
import '../../trips/data/trip_repository.dart';
import '../../../common_widgets/skeletons/trip_card_skeleton.dart';
import '../../../common_widgets/app_shimmer.dart';
import '../../../common_widgets/app_shimmer.dart';
import '../../../common_widgets/app_image.dart';
import 'featured_trip_slideshow.dart';

/// Home screen with trip cards and search
/// Reference: designs/option15_mobile.html
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(authStateChangesProvider);

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(context, ref, userAsync),

              // Search bar
              _buildSearchBar(context),

              // Featured trip
              _buildFeaturedTrip(context, ref),

              // Spin the Globe card
              _buildSpinGlobe(context),

              // Categories
              _buildCategories(),

              // Popular trips section
              _buildPopularTrips(context, ref),

              // Weekend Getaways
              _buildWeekendGetaways(context, ref),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    WidgetRef ref,
    AsyncValue userAsync,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: AppColors.bgDeep.withValues(alpha: 0.8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Row(
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 44,
                  height: 44,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'SoleGoes',
                style: AppTextStyles.h3.copyWith(
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          // Right actions
          Row(
            children: [
              // Notification button
              GestureDetector(
                onTap: () => context.push('/notifications'),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHover,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        LucideIcons.bell,
                        size: 20,
                        color: AppColors.textPrimary.withValues(alpha: 0.8),
                      ),
                      // Notification dot
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.bgDeep,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Profile button
              GestureDetector(
                onTap: () => context.push('/profile'),
                child: userAsync.when(
                  data: (user) => Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceHover,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: ClipOval(
                      child: AppImage.avatar(
                        imageUrl: user?.photoUrl,
                        name: user?.displayName,
                        size: 40,
                      ),
                    ),
                  ),
                  loading: () => const SizedBox(width: 40, height: 40),
                  error: (_, __) => const SizedBox(width: 40, height: 40),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarFallback(String? name) {
    final initial = (name != null && name.isNotEmpty) ? name[0].toUpperCase() : 'U';
    return Container(
      color: AppColors.primary,
      child: Center(
        child: Text(
          initial,
          style: AppTextStyles.h3.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: AppTextField(
        controller: TextEditingController(),
        hint: 'Where to next?',
        icon: LucideIcons.search,
        readOnly: true,
        onTap: () {
          // Switch to Explore tab with autofocus
          context.go(Uri(path: '/explore', queryParameters: {'autofocus': 'true'}).toString());
        },
        suffixIcon: GestureDetector(
          onTap: () => context.push('/search/filter'),
          child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.surfacePressed,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              LucideIcons.slidersHorizontal,
              size: 16,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedTrip(BuildContext context, WidgetRef ref) {
    final featuredTripsAsync = ref.watch(featuredTripsProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0), // Padding moved inside slideshow
      child: featuredTripsAsync.when(
        data: (trips) {
          if (trips.isEmpty) return const SizedBox.shrink();
          // Pass all featured trips to the slideshow
          return FeaturedTripSlideshow(trips: trips);
        },
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: AppShimmer(
            width: double.infinity,
            height: 380,
            borderRadius: 24,
          ),
        ),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildSpinGlobe(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: GestureDetector(
            onTap: () {
              // Combine trending and featured trips for variety
              final trendingTrips = ref.read(trendingTripsProvider).asData?.value ?? [];
              final featuredTrips = ref.read(featuredTripsProvider).asData?.value ?? [];
              final allAvailableTrips = [...trendingTrips, ...featuredTrips].toSet().toList();
              
              print('DEBUG: Spin the Globe tapped');
              print('DEBUG: Available trips count: ${allAvailableTrips.length}');
              
              if (allAvailableTrips.isNotEmpty) {
                final randomTrip = (allAvailableTrips..shuffle()).first;
                print('DEBUG: Selected trip: ${randomTrip.tripId} - ${randomTrip.title}');
                context.push('/globe-spin/${randomTrip.tripId}');
              } else {
                print('DEBUG: No trips available');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No trips available. Please wait for trips to load.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.darkGradient,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.borderGlass),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Spin the Globe',
                            style: AppTextStyles.h4,
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            LucideIcons.sparkles,
                            size: 16,
                            color: AppColors.accentYellow,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Feeling adventurous? Let fate decide.',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '🌍',
                    style: TextStyle(fontSize: 48),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategories() {
    final categories = ['Beach', 'Mountain', 'City', 'Forest', 'Desert', 'Snow'];
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CategoryPill(
              label: category,
              isSelected: false,
              onTap: () {
                context.pushNamed(
                  'categoryTrips', 
                  pathParameters: {'category': category},
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildPopularTrips(BuildContext context, WidgetRef ref) {
    final trendingTripsAsync = ref.watch(trendingTripsProvider);
    // ... (rest of Popular Trips implementation, using previously updated height)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'POPULAR NEAR YOU',
                style: AppTextStyles.sectionTitle,
              ),
              GestureDetector(
                onTap: () => context.go('/explore'),
                child: Text(
                  'See All',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Horizontal trip cards
        SizedBox(
          height: 280,
          child: trendingTripsAsync.when(
            data: (trips) {
              if (trips.isEmpty) {
                return Center(
                  child: Text('No trips available', style: TextStyle(color: AppColors.textSecondary)),
                );
              }
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: trips.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final trip = trips[index];
                  return TripCard(
                    tripId: trip.tripId,
                    title: trip.title,
                    imageUrl: trip.imageUrl,
                    duration: '${trip.duration} Days',
                    location: trip.location,
                    price: trip.price,
                    rating: trip.rating,
                    startDate: trip.startDate,
                  );
                },
              );
            },
            loading: () => ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 3,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) => const SizedBox(
                width: 260,
                child: TripCardSkeleton(),
              ),
            ),
            error: (_, __) => Center(
              child: Text('Failed to load trips'),
            ),
          ),
        ),
        ],
      );
  }
  
  Widget _buildWeekendGetaways(BuildContext context, WidgetRef ref) {
    final weekendTripsAsync = ref.watch(weekendGetawaysProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
          child: Text(
            'WEEKEND GETAWAYS',
            style: AppTextStyles.sectionTitle,
          ),
        ),
        // Vertical List
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: weekendTripsAsync.when(
            data: (trips) {
              if (trips.isEmpty) return const Text('No short trips found.');
              
              // Show first 4
              final displayTrips = trips.take(4).toList();
              
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  mainAxisExtent: 294,
                ),
                itemCount: displayTrips.length,
                itemBuilder: (context, index) {
                  final trip = displayTrips[index];
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
            loading: () => Column(
              children: List.generate(3, (index) => const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: TripCardSkeleton(),
              )),
            ),
            error: (_,__) => const SizedBox(),
          ),
        ),
      ],
    );
  }
}
