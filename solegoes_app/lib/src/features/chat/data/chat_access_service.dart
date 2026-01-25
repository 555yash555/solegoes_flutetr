import 'package:cloud_firestore/cloud_firestore.dart';

/// Service to validate user access to chats based on bookings
class ChatAccessService {
  final FirebaseFirestore _firestore;

  ChatAccessService(this._firestore);

  /// Check if a user can join a trip chat
  /// Returns true only if user has a confirmed booking for the trip
  Future<bool> canJoinChat(String userId, String tripId) async {
    try {
      final bookingSnapshot = await _firestore
          .collection('bookings')
          .where('userId', isEqualTo: userId)
          .where('tripId', isEqualTo: tripId)
          .limit(1)
          .get();

      if (bookingSnapshot.docs.isEmpty) {
        return false;
      }

      final booking = bookingSnapshot.docs.first.data();
      final status = booking['status'] as String?;
      final paymentStatus = booking['paymentStatus'] as String?;

      // Only allow access if booking is confirmed and payment is successful
      return status == 'confirmed' && paymentStatus == 'success';
    } catch (e) {
      print('Error checking chat access: $e');
      return false;
    }
  }
}
