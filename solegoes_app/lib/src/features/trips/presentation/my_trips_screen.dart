import 'package:flutter/material.dart';
import '../../../common_widgets/skeletons/trip_card_skeleton.dart';
import '../../bookings/presentation/booking_card.dart';
import '../../../common_widgets/app_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../common_widgets/app_button.dart';
import '../../../common_widgets/app_header.dart';
import '../../../theme/app_theme.dart';
import '../../authentication/data/auth_repository.dart';
import '../../bookings/data/booking_repository.dart';
import '../../bookings/domain/booking.dart';

/// My trips screen with upcoming and past trips
/// Reference: designs/option15_my_trips.html
class MyTripsScreen extends ConsumerStatefulWidget {
  const MyTripsScreen({super.key});

  @override
  ConsumerState<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends ConsumerState<MyTripsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.confirmed:
        return const Color(0xFF22C55E); // Green
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

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(authStateChangesProvider);

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            // Tabs
            _buildTabs(),
            // Content
            Expanded(
              child: userAsync.when(
                data: (user) {
                  if (user == null) {
                    return _buildLoginPrompt(context);
                  }
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _buildUpcomingTrips(user.uid),
                      _buildPastTrips(user.uid),
                      _buildSavedTrips(),
                    ],
                  );
                },
                loading: () => Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
                error: (_, __) => _buildLoginPrompt(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return AppHeader(
      title: 'My Trips',
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.surfaceHover,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: AppColors.surfacePressed,
            borderRadius: BorderRadius.circular(AppRadius.full),
            boxShadow: [
              BoxShadow(
                color: AppColors.shimmer,
                blurRadius: 4,
              ),
            ],
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelColor: Colors.white,
          unselectedLabelColor: AppColors.textMuted,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: AppTextStyles.bodyMedium,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Past'),
            Tab(text: 'Saved'),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingTrips(String userId) {
    final bookingsAsync = ref.watch(userBookingsProvider(userId));

    return bookingsAsync.when(
      data: (bookings) {
        // Filter for upcoming (confirmed or pending) bookings
        final upcomingBookings = bookings
            .where((b) =>
                b.status == BookingStatus.confirmed ||
                b.status == BookingStatus.pending)
            .toList();

        if (upcomingBookings.isEmpty) {
          return _buildEmptyState(
            icon: LucideIcons.compass,
            title: 'No upcoming trips',
            subtitle: 'Start exploring and book your next adventure!',
            actionText: 'Explore Trips',
            onAction: () => context.go('/'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
          itemCount: upcomingBookings.length,
          itemBuilder: (context, index) =>
              BookingCard(booking: upcomingBookings[index]),
        );
      },
      loading: () => ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
        itemCount: 3,
        itemBuilder: (context, index) => const TripCardSkeleton(),
      ),
      error: (error, _) => _buildErrorState(error.toString()),
    );
  }

  Widget _buildPastTrips(String userId) {
    final bookingsAsync = ref.watch(userBookingsProvider(userId));

    return bookingsAsync.when(
      data: (bookings) {
        // Filter for past (completed or cancelled) bookings
        final pastBookings = bookings
            .where((b) =>
                b.status == BookingStatus.completed ||
                b.status == BookingStatus.cancelled)
            .toList();

        if (pastBookings.isEmpty) {
          return _buildEmptyState(
            icon: LucideIcons.history,
            title: 'No past trips',
            subtitle: 'Your completed trips will appear here',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
          itemCount: pastBookings.length,
          itemBuilder: (context, index) => BookingCard(booking: pastBookings[index]),
        );
      },
      loading: () => ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
        itemCount: 3,
        itemBuilder: (context, index) => const TripCardSkeleton(),
      ),
      error: (error, _) => _buildErrorState(error.toString()),
    );
  }

  Widget _buildSavedTrips() {
    // TODO: Implement saved trips with wishlist functionality
    return _buildEmptyState(
      icon: LucideIcons.heart,
      title: 'No saved trips',
      subtitle: 'Save trips you love for later',
      actionText: 'Explore Trips',
      onAction: () => context.go('/'),
    );
  }



  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textMuted,
              ),
            ),
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 24),
              AppButton(
                text: actionText,
                onPressed: onAction,
                variant: AppButtonVariant.primary,
                shape: AppButtonShape.pill,
                size: AppButtonSize.medium,
                isFullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.alertCircle,
              size: 48,
              color: AppColors.accentRose,
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return _buildEmptyState(
      icon: LucideIcons.logIn,
      title: 'Login required',
      subtitle: 'Sign in to see your booked trips',
      actionText: 'Login',
      onAction: () => context.go('/login'),
    );
  }
}
