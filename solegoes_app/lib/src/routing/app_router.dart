import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../features/authentication/data/auth_repository.dart';

// Placeholder screens - will be replaced with real implementations
import '../features/onboarding/presentation/onboarding_screen.dart';
import '../features/authentication/presentation/login_screen.dart';
import '../features/authentication/presentation/signup_screen.dart';
import '../features/authentication/presentation/phone_collection_screen.dart';
import '../features/authentication/presentation/profile_setup_screen.dart';
import '../features/authentication/presentation/preferences_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/home/presentation/scaffold_with_nav_bar.dart';
import '../features/trips/presentation/explore_screen.dart';
import '../features/trips/presentation/trip_detail_screen.dart';
import '../features/trips/presentation/my_trips_screen.dart';
import '../features/chat/presentation/chat_list_screen.dart';
import '../features/chat/presentation/chat_detail_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/profile/presentation/settings_screen.dart';
import '../features/profile/presentation/notifications_screen.dart';
import '../features/profile/presentation/edit_profile_screen.dart';
import '../features/payments/presentation/payment_method_screen.dart';
import '../features/payments/presentation/payment_confirmation_screen.dart';
import '../features/demo/presentation/design_demo_screen.dart';

part 'app_router.g.dart';

/// All named routes in the app
enum AppRoute {
  // Demo (temporary)
  demo,

  // Onboarding
  onboarding,

  // Auth
  login,
  signup,
  phoneCollection,
  profileSetup,
  preferences,

  // Main App (Shell)
  home,
  explore,
  myTrips,
  chatList,
  profile,

  // Detail screens
  tripDetail,
  chatDetail,
  paymentMethod,
  paymentConfirmation,
  settings,
  notifications,
  editProfile,
}

@riverpod
GoRouter goRouter(Ref ref) {
  final authRepository = ref.watch(authRepositoryProvider);

  return GoRouter(
    initialLocation: '/onboarding',
    debugLogDiagnostics: true,
    redirect: (context, state) async {
      final isLoggedIn = authRepository.currentUser != null;
      final path = state.uri.path;

      // Skip auth redirect for demo screen
      if (path == '/demo') return null;

      // Auth routes that don't require login
      final authRoutes = ['/onboarding', '/login', '/signup'];
      final isOnAuthRoute = authRoutes.contains(path);

      // Setup routes (require login but profile may be incomplete)
      final setupRoutes = ['/phone-collection', '/profile-setup', '/preferences'];
      final isOnSetupRoute = setupRoutes.contains(path);

      if (!isLoggedIn && !isOnAuthRoute) {
        // Not logged in and not on auth page -> go to onboarding
        return '/onboarding';
      }

      if (isLoggedIn && isOnAuthRoute) {
        // Logged in and on auth page -> check profile completion
        try {
          final user = await authRepository.getUserProfile(authRepository.currentUser!.uid);
          if (!user.isProfileComplete) {
            return '/profile-setup';
          }
          if (!user.isPreferencesComplete) {
            return '/preferences';
          }
        } catch (e) {
          // If we can't get user profile, go to profile setup
          return '/profile-setup';
        }
        return '/';
      }

      // If logged in and trying to access main app, check profile completion
      if (isLoggedIn && !isOnAuthRoute && !isOnSetupRoute) {
        try {
          final user = await authRepository.getUserProfile(authRepository.currentUser!.uid);
          if (!user.isProfileComplete) {
            return '/profile-setup';
          }
          if (!user.isPreferencesComplete) {
            return '/preferences';
          }
        } catch (e) {
          // If we can't get user profile, go to profile setup
          return '/profile-setup';
        }
      }

      return null;
    },
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    routes: [
      // ===========================================
      // DEMO ROUTE (Temporary - for design verification)
      // ===========================================
      GoRoute(
        path: '/demo',
        name: AppRoute.demo.name,
        builder: (context, state) => const DesignDemoScreen(),
      ),

      // ===========================================
      // AUTH ROUTES (No bottom nav)
      // ===========================================
      GoRoute(
        path: '/onboarding',
        name: AppRoute.onboarding.name,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: AppRoute.login.name,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: AppRoute.signup.name,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/phone-collection',
        name: AppRoute.phoneCollection.name,
        builder: (context, state) => const PhoneCollectionScreen(),
      ),
      GoRoute(
        path: '/profile-setup',
        name: AppRoute.profileSetup.name,
        builder: (context, state) => const ProfileSetupScreen(),
      ),
      GoRoute(
        path: '/preferences',
        name: AppRoute.preferences.name,
        builder: (context, state) => const PreferencesScreen(),
      ),

      // ===========================================
      // MAIN APP (With bottom nav)
      // ===========================================
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          // 0: Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: AppRoute.home.name,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),

          // 1: Explore
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/explore',
                name: AppRoute.explore.name,
                builder: (context, state) => const ExploreScreen(),
              ),
            ],
          ),

          // 2: My Trips
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/my-trips',
                name: AppRoute.myTrips.name,
                builder: (context, state) => const MyTripsScreen(),
              ),
            ],
          ),

          // 3: Chat
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/chat',
                name: AppRoute.chatList.name,
                builder: (context, state) => const ChatListScreen(),
              ),
            ],
          ),

          // 4: Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: AppRoute.profile.name,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      // ===========================================
      // DETAIL ROUTES (Full screen, no bottom nav)
      // ===========================================
      GoRoute(
        path: '/trip/:tripId',
        name: AppRoute.tripDetail.name,
        builder: (context, state) {
          final tripId = state.pathParameters['tripId']!;
          return TripDetailScreen(tripId: tripId);
        },
      ),
      GoRoute(
        path: '/chat/:chatId',
        name: AppRoute.chatDetail.name,
        builder: (context, state) {
          final chatId = state.pathParameters['chatId']!;
          return ChatDetailScreen(chatId: chatId);
        },
      ),
      GoRoute(
        path: '/payment-method/:tripId',
        name: AppRoute.paymentMethod.name,
        builder: (context, state) {
          final tripId = state.pathParameters['tripId']!;
          return PaymentMethodScreen(tripId: tripId);
        },
      ),
      GoRoute(
        path: '/payment-confirmation/:bookingId',
        name: AppRoute.paymentConfirmation.name,
        builder: (context, state) {
          final bookingId = state.pathParameters['bookingId']!;
          return PaymentConfirmationScreen(bookingId: bookingId);
        },
      ),
      GoRoute(
        path: '/settings',
        name: AppRoute.settings.name,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/notifications',
        name: AppRoute.notifications.name,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/edit-profile',
        name: AppRoute.editProfile.name,
        builder: (context, state) => const EditProfileScreen(),
      ),
    ],
  );
}

/// Convert Stream to Listenable for GoRouter refresh
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final dynamic _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
