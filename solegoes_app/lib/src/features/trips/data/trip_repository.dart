import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/trip.dart';

part 'trip_repository.g.dart';

/// Repository for managing trip data from Firestore
class TripRepository {
  final FirebaseFirestore _firestore;

  TripRepository(this._firestore);

  /// Get all live trips
  Future<List<Trip>> getAllTrips() async {
    try {
      final snapshot = await _firestore
          .collection('trips')
          .where('status', isEqualTo: 'live')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Trip.fromJson({...doc.data(), 'tripId': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch trips: $e');
    }
  }

  /// Get featured trips
  Future<List<Trip>> getFeaturedTrips() async {
    try {
      final snapshot = await _firestore
          .collection('trips')
          .where('status', isEqualTo: 'live')
          .where('isFeatured', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .limit(5)
          .get();

      return snapshot.docs
          .map((doc) => Trip.fromJson({...doc.data(), 'tripId': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch featured trips: $e');
    }
  }

  /// Get trending trips
  Future<List<Trip>> getTrendingTrips() async {
    try {
      final snapshot = await _firestore
          .collection('trips')
          .where('status', isEqualTo: 'live')
          .where('isTrending', isEqualTo: true)
          .orderBy('rating', descending: true)
          .limit(10)
          .get();

      return snapshot.docs
          .map((doc) => Trip.fromJson({...doc.data(), 'tripId': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch trending trips: $e');
    }
  }

  /// Get trip by ID
  Future<Trip?> getTripById(String tripId) async {
    try {
      final doc = await _firestore.collection('trips').doc(tripId).get();

      if (!doc.exists) return null;

      return Trip.fromJson({...doc.data()!, 'tripId': doc.id});
    } catch (e) {
      throw Exception('Failed to fetch trip: $e');
    }
  }

  /// Get trips by category
  Future<List<Trip>> getTripsByCategory(String category) async {
    try {
      final snapshot = await _firestore
          .collection('trips')
          .where('status', isEqualTo: 'live')
          .where('categories', arrayContains: category)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Trip.fromJson({...doc.data(), 'tripId': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch trips by category: $e');
    }
  }

  /// Get trips by agency
  Future<List<Trip>> getTripsByAgency(String agencyId) async {
    try {
      final snapshot = await _firestore
          .collection('trips')
          .where('status', isEqualTo: 'live')
          .where('agencyId', isEqualTo: agencyId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Trip.fromJson({...doc.data(), 'tripId': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch trips by agency: $e');
    }
  }

  /// Search trips by text
  Future<List<Trip>> searchTrips(String query) async {
    try {
      final snapshot = await _firestore
          .collection('trips')
          .where('status', isEqualTo: 'live')
          .orderBy('title')
          .startAt([query])
          .endAt([query + '\uf8ff'])
          .get();

      return snapshot.docs
          .map((doc) => Trip.fromJson({...doc.data(), 'tripId': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to search trips: $e');
    }
  }

  /// Stream of all live trips
  Stream<List<Trip>> watchAllTrips() {
    return _firestore
        .collection('trips')
        .where('status', isEqualTo: 'live')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Trip.fromJson({...doc.data(), 'tripId': doc.id}))
            .toList());
  }
}

/// Provider for TripRepository
@riverpod
TripRepository tripRepository(Ref ref) {
  return TripRepository(FirebaseFirestore.instance);
}

/// Provider for all trips
@riverpod
Future<List<Trip>> allTrips(Ref ref) {
  final repository = ref.watch(tripRepositoryProvider);
  return repository.getAllTrips();
}

/// Provider for featured trips
@riverpod
Future<List<Trip>> featuredTrips(Ref ref) {
  final repository = ref.watch(tripRepositoryProvider);
  return repository.getFeaturedTrips();
}

/// Provider for trending trips
@riverpod
Future<List<Trip>> trendingTrips(Ref ref) {
  final repository = ref.watch(tripRepositoryProvider);
  return repository.getTrendingTrips();
}

/// Provider for a specific trip
@riverpod
Future<Trip?> trip(Ref ref, String tripId) {
  final repository = ref.watch(tripRepositoryProvider);
  return repository.getTripById(tripId);
}
