import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/trip.dart';

part 'trip_repository.g.dart';

/// Repository for managing trip data from Firestore
class TripRepository {
  final FirebaseFirestore _firestore;

  TripRepository(this._firestore);

  /// Get all trips (simplified query without status filter to avoid index requirement)
  Future<List<Trip>> getAllTrips() async {
    try {
      final snapshot = await _firestore
          .collection('trips')
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
          .endAt(['$query\uf8ff'])
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

  /// Stream of featured trips
  Stream<List<Trip>> watchFeaturedTrips() {
    return _firestore
        .collection('trips')
        .where('status', isEqualTo: 'live')
        .where('isFeatured', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .limit(5)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Trip.fromJson({...doc.data(), 'tripId': doc.id}))
            .toList());
  }

  /// Stream of trending trips
  Stream<List<Trip>> watchTrendingTrips() {
    return _firestore
        .collection('trips')
        .where('status', isEqualTo: 'live')
        .where('isTrending', isEqualTo: true)
        .orderBy('rating', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Trip.fromJson({...doc.data(), 'tripId': doc.id}))
            .toList());
  }
}

/// Provider for TripRepository
@Riverpod(keepAlive: true)
TripRepository tripRepository(Ref ref) {
  return TripRepository(FirebaseFirestore.instance);
}

/// Provider for all trips
@Riverpod(keepAlive: true)
Stream<List<Trip>> allTrips(Ref ref) {
  final repository = ref.watch(tripRepositoryProvider);
  return repository.watchAllTrips();
}

/// Provider for featured trips
@Riverpod(keepAlive: true)
Stream<List<Trip>> featuredTrips(Ref ref) {
  final repository = ref.watch(tripRepositoryProvider);
  return repository.watchFeaturedTrips();
}

/// Provider for trending trips
@Riverpod(keepAlive: true)
Stream<List<Trip>> trendingTrips(Ref ref) {
  final repository = ref.watch(tripRepositoryProvider);
  return repository.watchTrendingTrips();
}

/// Provider for a specific trip
@riverpod
Future<Trip?> trip(Ref ref, String tripId) {
  final repository = ref.watch(tripRepositoryProvider);
  return repository.getTripById(tripId);
}

/// Provider for weekend getaways (short trips <= 4 days)
@Riverpod(keepAlive: true)
Stream<List<Trip>> weekendGetaways(Ref ref) {
  final repository = ref.watch(tripRepositoryProvider);
  return repository.watchAllTrips().map((trips) {
    return trips.where((t) {
      return t.duration <= 4;
    }).toList();
  });
}
