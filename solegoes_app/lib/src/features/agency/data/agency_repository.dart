import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/agency.dart';

part 'agency_repository.g.dart';

class AgencyRepository {
  final FirebaseFirestore _firestore;

  AgencyRepository(this._firestore);

  CollectionReference<Map<String, dynamic>> get _agencies =>
      _firestore.collection('agencies');

  // ===========================================
  // READ
  // ===========================================

  Future<Agency> getAgencyById(String agencyId) async {
    final doc = await _agencies.doc(agencyId).get();
    if (!doc.exists) throw Exception('Agency not found: $agencyId');
    return Agency.fromJson({'agencyId': doc.id, ...doc.data()!});
  }

  Stream<Agency> watchAgency(String agencyId) {
    return _agencies.doc(agencyId).snapshots().map((doc) {
      if (!doc.exists) throw Exception('Agency not found: $agencyId');
      return Agency.fromJson({'agencyId': doc.id, ...doc.data()!});
    });
  }

  Future<List<Agency>> getPendingAgencies() async {
    final snapshot = await _agencies
        .where('verificationStatus', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => Agency.fromJson({'agencyId': doc.id, ...doc.data()}))
        .toList();
  }

  Future<List<Agency>> getAllAgencies() async {
    final snapshot =
        await _agencies.orderBy('createdAt', descending: true).get();
    return snapshot.docs
        .map((doc) => Agency.fromJson({'agencyId': doc.id, ...doc.data()}))
        .toList();
  }

  // ===========================================
  // WRITE
  // ===========================================

  /// Creates agency doc in Firestore. Returns agencyId.
  Future<String> createAgency(Agency agency) async {
    final agencyId = agency.agencyId.isNotEmpty
        ? agency.agencyId
        : _agencies.doc().id;
    await _agencies.doc(agencyId).set({
      ...agency.toJson(),
      'agencyId': agencyId,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return agencyId;
  }

  Future<void> updateAgency(
      String agencyId, Map<String, dynamic> updates) async {
    await _agencies.doc(agencyId).update({
      ...updates,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Admin-only: change verificationStatus and optionally set isVerified
  Future<void> updateVerificationStatus(
      String agencyId, String status) async {
    await _agencies.doc(agencyId).update({
      'verificationStatus': status,
      'isVerified': status == 'approved',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ===========================================
  // STATS  (denormalized increments)
  // ===========================================

  Future<void> incrementTripCount(String agencyId) async {
    await _agencies.doc(agencyId).update({
      'totalTrips': FieldValue.increment(1),
    });
  }

  Future<void> incrementBookingCount(String agencyId) async {
    await _agencies.doc(agencyId).update({
      'totalBookings': FieldValue.increment(1),
    });
  }
}

// ===========================================
// PROVIDERS
// ===========================================

@Riverpod(keepAlive: true)
AgencyRepository agencyRepository(Ref ref) {
  return AgencyRepository(FirebaseFirestore.instance);
}

/// Watches a single agency doc in real time.
@riverpod
Stream<Agency> agencyStream(Ref ref, String agencyId) {
  return ref.watch(agencyRepositoryProvider).watchAgency(agencyId);
}

/// One-time fetch of an agency.
@riverpod
Future<Agency> agencyFuture(Ref ref, String agencyId) {
  return ref.watch(agencyRepositoryProvider).getAgencyById(agencyId);
}

/// Admin: pending agencies list.
@riverpod
Future<List<Agency>> pendingAgencies(Ref ref) {
  return ref.watch(agencyRepositoryProvider).getPendingAgencies();
}
