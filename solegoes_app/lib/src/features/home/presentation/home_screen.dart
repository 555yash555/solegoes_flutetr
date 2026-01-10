import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../theme/app_theme.dart';
import '../../authentication/data/auth_repository.dart';
import '../../trips/data/trip_repository.dart';
import 'widgets/trip_card.dart';

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
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    'SG',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'SoleGoes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
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
                    color: Colors.white.withValues(alpha: 0.05),
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
                            color: Colors.red,
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
                      color: Colors.white.withValues(alpha: 0.05),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: ClipOval(
                      child: user?.photoUrl != null
                          ? Image.network(
                              user!.photoUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _buildAvatarFallback(user.displayName),
                            )
                          : _buildAvatarFallback(user?.displayName),
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
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Row(
          children: [
            Icon(
              LucideIcons.search,
              size: 20,
              color: Colors.white.withValues(alpha: 0.4),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Where to next?',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.4),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => context.push('/preferences'),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  LucideIcons.slidersHorizontal,
                  size: 16,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedTrip(BuildContext context, WidgetRef ref) {
    final featuredTripsAsync = ref.watch(featuredTripsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: featuredTripsAsync.when(
        data: (trips) {
          if (trips.isEmpty) return const SizedBox.shrink();
          final trip = trips.first;
          return FeaturedTripCard(
            tripId: trip.tripId,
            title: trip.title,
            imageUrl: trip.imageUrl,
            duration: '${trip.duration} Days',
            location: trip.location,
            price: trip.price,
            isTrending: trip.isTrending,
          );
        },
        loading: () => Container(
          height: 380,
          decoration: BoxDecoration(
            color: AppColors.bgSurface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: const Center(child: CircularProgressIndicator()),
        ),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildSpinGlobe(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: () {
          // TODO: Implement spin the globe feature
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF1A1A1A),
                const Color(0xFF0A0A0A),
              ],
            ),
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
                      const Text(
                        'Spin the Globe',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        LucideIcons.sparkles,
                        size: 16,
                        color: const Color(0xFFFACC15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Feeling adventurous? Let fate decide.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
              const Text(
                '🌍',
                style: TextStyle(fontSize: 48),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    final categories = ['All Trips', 'Beach', 'Mountain', 'City Break', 'Adventure'];
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isActive = index == 0;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primary.withValues(alpha: 0.15)
                    : Colors.white.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(AppRadius.full),
                border: Border.all(
                  color: isActive ? AppColors.primary : AppColors.borderSubtle,
                ),
              ),
              child: Text(
                categories[index],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPopularTrips(BuildContext context, WidgetRef ref) {
    final trendingTripsAsync = ref.watch(trendingTripsProvider);

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
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textTertiary,
                  letterSpacing: 0.5,
                ),
              ),
              GestureDetector(
                onTap: () => context.push('/explore'),
                child: Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Horizontal trip cards
        SizedBox(
          height: 250,
          child: trendingTripsAsync.when(
            data: (trips) {
              if (trips.isEmpty) {
                return const Center(
                  child: Text('No trips available'),
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
                    category: trip.categories.isNotEmpty ? trip.categories.first : '',
                    groupSize: trip.groupSize,
                    price: trip.price,
                    rating: trip.rating,
                  );
                },
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (_, __) => const Center(
              child: Text('Failed to load trips'),
            ),
          ),
        ),
      ],
    );
  }
}
