import 'package:cloud_firestore/cloud_firestore.dart';

/// LITE VERSION OF SEED DATA
/// Used for schema reference and quick testing.
/// Contains 1 Agency and 1 Trip with full fields.

final sampleAgency = {
  'agencyId': 'wanderlust-travels',
  'ownerUid': 'demo-owner-1',
  'businessName': 'Wanderlust Travels',
  'email': 'contact@wanderlusttravels.com',
  'phone': '+91 98765 43210',
  'description': 'Leading travel agency specializing in spiritual and wellness journeys.',
  'logoUrl': 'https://ui-avatars.com/api/?name=Wanderlust+Travels&background=6366F1&color=fff',
  'coverImageUrl': 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=800',
  'verificationStatus': 'approved', // pending, approved, rejected
  'gstin': 'GST123456789',
  'teamSize': '10-20',
  'yearsExperience': 8,
  'isVerified': true,
  'rating': 4.8,
  'totalTrips': 45,
  'totalBookings': 120,
  'specialties': ['Wellness', 'Spiritual', 'Culture', 'Adventure'],
  'stats': {
    'totalRevenue': 4200000,
    'activeBookings': 28,
    'completedTrips': 42,
  },
  'documents': {
    'gstCertificate': 'https://example.com/gst-cert.pdf',
    'portfolioPhotos': [
      'https://images.unsplash.com/photo-1',
      'https://images.unsplash.com/photo-2',
    ],
  },
  'createdAt': FieldValue.serverTimestamp(),
};

final sampleTrip = {
  'title': 'Bali Spiritual Awakening',
  'description': 'Embark on a transformative journey...',
  'imageUrl': 'https://images.unsplash.com/photo-main',
  'imageUrls': [
    'https://images.unsplash.com/photo-main',
    'https://images.unsplash.com/photo-2',
  ],
  'location': 'Ubud, Bali',
  'duration': 7,
  'price': 45000.0, // Base price (displayed in cards)
  'categories': ['Wellness', 'Spiritual', 'Culture'],
  'groupSize': 'Group of 12',
  'rating': 4.9,
  'reviewCount': 156,
  'agencyId': 'wanderlust-travels',
  'agencyName': 'Wanderlust Travels',
  'isVerifiedAgency': true,
  'status': 'live', // pending_approval, live, rejected, completed
  'isTrending': true,
  'isFeatured': true,
  'inclusions': [
    'Resort Stay (6 nights)', 
    'All Meals'
  ],
  'itinerary': [
    {
      'day': 1,
      'title': 'Arrival',
      'description': 'Welcome ceremony.',
      'activities': ['Airport pickup', 'Check-in']
    },
     {
      'day': 2,
      'title': 'Temple Tour',
      'description': 'Visit temples.',
      'activities': ['Morning Yoga', 'Temple Visit']
    },
  ],
  'boardingPoints': [
    {
      'name': 'Mumbai Airport (BOM)',
      'address': 'Terminal 2',
      'dateTime': Timestamp.fromDate(DateTime(2025, 2, 15, 6, 0)),
    },
  ],
  'droppingPoints': [
    {
      'name': 'Mumbai Airport (BOM)',
      'address': 'Terminal 2',
      'dateTime': Timestamp.fromDate(DateTime(2025, 2, 22, 22, 0)),
    },
  ],
  'startDate': Timestamp.fromDate(DateTime(2025, 2, 15)),
  'endDate': Timestamp.fromDate(DateTime(2025, 2, 22)),
  
  // CRITICAL: Pricing Styles Schema
  'pricingStyles': [
    {
      'styleId': 'budget',
      'name': 'Budget Explorer',
      'description': '3-person sharing room',
      'price': 38000.0,
      'accommodationType': 'sharing-3', // private, sharing-2, sharing-3
      'mealOptions': ['veg'],
      'inclusions': ['Shared accommodation', 'Vegetarian meals'],
    },
    {
      'styleId': 'standard',
      'name': 'Standard Comfort',
      'description': '2-person sharing room',
      'price': 45000.0,
      'accommodationType': 'sharing-2',
      'mealOptions': ['veg', 'non-veg'],
      'inclusions': ['2-person sharing', 'All meals'],
    },
    {
      'styleId': 'premium',
      'name': 'Premium Solo',
      'description': 'Private room',
      'price': 58000.0,
      'accommodationType': 'private',
      'mealOptions': ['veg', 'non-veg', 'alcohol'],
      'inclusions': ['Private room', 'All meals + Alcohol'],
    },
  ],
  'createdAt': FieldValue.serverTimestamp(),
  'updatedAt': FieldValue.serverTimestamp(),
};

/// SAMPLE BOOKING SCHEMA
/// Collection: `bookings`
final sampleBooking = {
  'tripId': 'trip-123',
  'userId': 'user-456',
  'tripTitle': 'Bali Spiritual Awakening',
  'tripImageUrl': 'https://images.unsplash.com/photo-main',
  'tripLocation': 'Ubud, Bali',
  'tripDuration': 7,
  'amount': 45000.0,
  'paymentId': 'pay_123456',
  'paymentMethod': 'card', // card, upi, netbanking
  'status': 'confirmed', // pending, confirmed, cancelled, completed
  'paymentStatus': 'success', // pending, success, failed, refunded
  'failureReason': null,
  'bookingDate': FieldValue.serverTimestamp(),
  'tripStartDate': Timestamp.fromDate(DateTime(2025, 2, 15)),
  'userEmail': 'john@example.com',
  'userName': 'John Doe',
  
  // Package Selection
  'selectedStyleId': 'standard',
  'selectedStyleName': 'Standard Comfort',
  
  // Logistics
  'selectedBoardingPoint': {
    'name': 'Mumbai Airport (BOM)',
    'address': 'Terminal 2',
    'dateTime': Timestamp.fromDate(DateTime(2025, 2, 15, 6, 0)),
  },
  'selectedDroppingPoint': {
    'name': 'Mumbai Airport (BOM)',
    'address': 'Terminal 2',
    'dateTime': Timestamp.fromDate(DateTime(2025, 2, 22, 22, 0)),
  },
};

/// SAMPLE CHAT SCHEMA (Realtime Database)
/// Node: `chats/{tripId}`
final sampleChatMetadata = {
  'chatId': 'trip-chat-123',
  'tripId': 'trip-123',
  'tripTitle': 'Bali Spiritual Awakening',
  'tripLocation': 'Ubud, Bali',
  'tripStartDate': 1739577600000, // Milliseconds since epoch
  'tripEndDate': 1740182400000,
  'participantIds': {
    'user-456': true,
    'user-789': true,
    'agency-admin-1': true,
  },
  'participantCount': 3,
  'lastMessage': 'Welcome to the trip group!',
  'lastMessageTime': 1739577600000,
  'lastMessageSenderId': 'agency-admin-1',
  'createdAt': 1739000000000,
};

/// SAMPLE CHAT MESSAGE SCHEMA (Realtime Database)
/// Node: `messages/{tripId}/{messageId}`
final sampleChatMessage = {
  'messageId': 'msg-1',
  'senderId': 'user-456',
  'senderName': 'John Doe',
  'senderAvatar': 'https://ui-avatars.com/api/?name=John+Doe',
  'content': 'Hey everyone! Excited for this trip.',
  'timestamp': 1739577700000, // Milliseconds
  'type': 'text', // text, image, system
};

/// SAMPLE USER SCHEMA
/// Collection: `users`
final sampleUser = {
  'uid': 'user-456',
  'email': 'john@example.com',
  'displayName': 'John Doe',
  'isEmailVerified': true,
  'photoUrl': 'https://ui-avatars.com/api/?name=John+Doe',
  'phoneNumber': '+91 9988776655',
  
  // Profile
  'bio': 'Travel enthusiast | Photographer',
  'city': 'Mumbai',
  'gender': 'Male',
  'birthDate': Timestamp.fromDate(DateTime(1995, 5, 20)),
  'personalityTraits': ['Adventurous', 'Social', 'Foodie'],
  'interests': ['Photography', 'Hiking', 'Culture'],
  'travelStyle': 'Budget',
  'budgetRange': '₹20k - ₹50k',
  
  // Profile completion status
  'isProfileComplete': true,
  'isPreferencesComplete': true,

  // Role based access
  'role': 'consumer', // consumer, agency, superAdmin
  'agencyId': null, // set when role is 'agency'

  'createdAt': FieldValue.serverTimestamp(),
  'updatedAt': FieldValue.serverTimestamp(),
};
