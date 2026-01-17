import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../theme/app_theme.dart';

/// Admin screen to seed sample trips to Firestore
/// This is a one-time use screen to populate the database
class SeedTripsScreen extends ConsumerStatefulWidget {
  const SeedTripsScreen({super.key});

  @override
  ConsumerState<SeedTripsScreen> createState() => _SeedTripsScreenState();
}

class _SeedTripsScreenState extends ConsumerState<SeedTripsScreen> {
  bool _isSeeding = false;
  String _status = '';
  final List<String> _logs = [];

  Future<void> _seedTrips() async {
    setState(() {
      _isSeeding = true;
      _status = 'Starting seed process...';
      _logs.clear();
    });

    final firestore = FirebaseFirestore.instance;

    try {
      // ============================================
      // STEP 0: Clear Existing Data
      // ============================================
      setState(() {
        _status = 'Step 0/3: Clearing existing data...';
      });

      // Delete all existing trips
      final existingTrips = await firestore.collection('trips').get();
      for (var doc in existingTrips.docs) {
        await doc.reference.delete();
      }
      setState(() {
        _logs.add('🗑️ Cleared ${existingTrips.docs.length} existing trips');
      });

      // Delete all existing agencies
      final existingAgencies = await firestore.collection('agencies').get();
      for (var doc in existingAgencies.docs) {
        await doc.reference.delete();
      }
      setState(() {
        _logs.add('🗑️ Cleared ${existingAgencies.docs.length} existing agencies');
      });

      await Future.delayed(const Duration(milliseconds: 500));

      // ============================================
      // STEP 1: Seed Agencies
      // ============================================
      setState(() {
        _status = 'Step 1/3: Seeding agencies...';
      });

      final sampleAgencies = [
        {
          'agencyId': 'wanderlust-travels',
          'ownerUid': 'demo-owner-1',
          'businessName': 'Wanderlust Travels',
          'verificationStatus': 'approved',
          'gstin': 'GST123456789',
          'teamSize': '10-20',
          'yearsExperience': 8,
          'documents': {
            'gstCertificate': 'https://example.com/gst-cert.pdf',
            'portfolioPhotos': [
              'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=600&q=80',
              'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=600&q=80',
            ],
          },
          'stats': {
            'totalRevenue': 4200000,
            'activeBookings': 28,
            'totalTrips': 45,
            'averageRating': 4.8,
          },
          'description':
              'Leading travel agency specializing in spiritual and wellness journeys across Asia.',
          'email': 'contact@wanderlusttravels.com',
          'phone': '+91 98765 43210',
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'agencyId': 'mountain-riders',
          'ownerUid': 'demo-owner-2',
          'businessName': 'Mountain Riders',
          'verificationStatus': 'approved',
          'gstin': 'GST987654321',
          'teamSize': '5-10',
          'yearsExperience': 6,
          'documents': {
            'gstCertificate': 'https://example.com/gst-cert-2.pdf',
            'portfolioPhotos': [
              'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=600&q=80',
            ],
          },
          'stats': {
            'totalRevenue': 1800000,
            'activeBookings': 15,
            'totalTrips': 22,
            'averageRating': 4.9,
          },
          'description':
              'Adventure specialists focusing on Himalayan bike expeditions and trekking.',
          'email': 'info@mountainriders.com',
          'phone': '+91 98765 12345',
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'agencyId': 'beach-vibes',
          'ownerUid': 'demo-owner-3',
          'businessName': 'Beach Vibes',
          'verificationStatus': 'approved',
          'gstin': 'GST456789123',
          'teamSize': '20-50',
          'yearsExperience': 5,
          'documents': {
            'gstCertificate': 'https://example.com/gst-cert-3.pdf',
            'portfolioPhotos': [
              'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=600&q=80',
            ],
          },
          'stats': {
            'totalRevenue': 3500000,
            'activeBookings': 42,
            'totalTrips': 68,
            'averageRating': 4.7,
          },
          'description':
              'Your go-to agency for beach parties, water sports, and coastal adventures.',
          'email': 'hello@beachvibes.com',
          'phone': '+91 98765 67890',
          'createdAt': FieldValue.serverTimestamp(),
        },
        {
          'agencyId': 'kerala-explorers',
          'ownerUid': 'demo-owner-4',
          'businessName': 'Kerala Explorers',
          'verificationStatus': 'approved',
          'gstin': 'GST789123456',
          'teamSize': '5-10',
          'yearsExperience': 10,
          'documents': {
            'gstCertificate': 'https://example.com/gst-cert-4.pdf',
            'portfolioPhotos': [
              'https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?w=600&q=80',
            ],
          },
          'stats': {
            'totalRevenue': 2100000,
            'activeBookings': 18,
            'totalTrips': 35,
            'averageRating': 4.8,
          },
          'description':
              'Authentic Kerala experiences with houseboat stays, Ayurveda, and cultural tours.',
          'email': 'info@keralaexplorers.com',
          'phone': '+91 98765 11111',
          'createdAt': FieldValue.serverTimestamp(),
        },
      ];

      for (var i = 0; i < sampleAgencies.length; i++) {
        final agencyData = sampleAgencies[i];
        final businessName = agencyData['businessName'] as String;

        setState(() {
          _status =
              'Adding agency ${i + 1}/${sampleAgencies.length}: $businessName';
        });

        await firestore.collection('agencies').add(agencyData);

        setState(() {
          _logs.add('✅ Added agency: $businessName');
        });

        await Future.delayed(const Duration(milliseconds: 300));
      }

      // ============================================
      // STEP 2: Seed Trips
      // ============================================
      setState(() {
        _status = 'Step 2/3: Seeding trips...';
      });

      final sampleTrips = [
      // Trip 1: Bali
      {
        'title': 'Bali Spiritual\nAwakening',
        'description':
            'Embark on a transformative journey through Bali\'s spiritual heart. Experience ancient temples, yoga sessions at sunrise, traditional healing ceremonies, and meditation in lush rice terraces.',
        'imageUrl':
            'https://images.unsplash.com/photo-1537996194471-e657df975ab4?w=800&q=80',
        'imageUrls': [
          'https://images.unsplash.com/photo-1537996194471-e657df975ab4?w=800&q=80',
          'https://images.unsplash.com/photo-1555400038-63f5ba517a47?w=800&q=80',
        ],
        'location': 'Ubud, Bali',
        'duration': 7,
        'price': 45000.0,
        'categories': ['Wellness', 'Spiritual', 'Culture'],
        'groupSize': 'Group of 12',
        'rating': 4.9,
        'reviewCount': 156,
        'agencyId': 'wanderlust-travels',
        'agencyName': 'Wanderlust Travels',
        'isVerifiedAgency': true,
        'status': 'live',
        'isTrending': true,
        'isFeatured': true,
        'inclusions': [
          'Resort Stay (6 nights)',
          'All Meals (Vegetarian options)',
          'Daily Yoga Sessions',
          'Temple Visits with Guide',
          'Traditional Healing Ceremony',
          'Airport Transfers',
        ],
        'itinerary': [
          {
            'day': 1,
            'title': 'Arrival & Welcome Ceremony',
            'description':
                'Arrive in Bali and transfer to our beautiful resort in Ubud.',
            'activities': [
              'Airport pickup',
              'Check-in at resort',
              'Welcome ceremony',
              'Group dinner'
            ],
          },
          {
            'day': 2,
            'title': 'Temple Tour & Rice Terraces',
            'description': 'Visit ancient temples and explore rice terraces.',
            'activities': [
              'Sunrise yoga',
              'Tirta Empul temple visit',
              'Rice terrace walk',
            ],
          },
        ],
        'boardingPoints': [
          {
            'name': 'Mumbai Airport (BOM)',
            'address': 'Chhatrapati Shivaji Maharaj International Airport, Terminal 2',
            'dateTime': Timestamp.fromDate(DateTime(2025, 2, 15, 6, 0)),
          },
          {
            'name': 'Delhi Airport (DEL)',
            'address': 'Indira Gandhi International Airport, Terminal 3',
            'dateTime': Timestamp.fromDate(DateTime(2025, 2, 15, 5, 30)),
          },
          {
            'name': 'Bangalore Airport (BLR)',
            'address': 'Kempegowda International Airport, Terminal 1',
            'dateTime': Timestamp.fromDate(DateTime(2025, 2, 15, 7, 0)),
          },
        ],
        'droppingPoints': [
          {
            'name': 'Mumbai Airport (BOM)',
            'address': 'Chhatrapati Shivaji Maharaj International Airport, Terminal 2',
            'dateTime': Timestamp.fromDate(DateTime(2025, 2, 22, 22, 0)),
          },
          {
            'name': 'Delhi Airport (DEL)',
            'address': 'Indira Gandhi International Airport, Terminal 3',
            'dateTime': Timestamp.fromDate(DateTime(2025, 2, 22, 23, 30)),
          },
          {
            'name': 'Bangalore Airport (BLR)',
            'address': 'Kempegowda International Airport, Terminal 1',
            'dateTime': Timestamp.fromDate(DateTime(2025, 2, 22, 21, 0)),
          },
        ],
        'startDate': Timestamp.fromDate(DateTime(2025, 2, 15)),
        'endDate': Timestamp.fromDate(DateTime(2025, 2, 22)),
        'pricingStyles': [
          {
            'styleId': 'budget',
            'name': 'Budget Explorer',
            'description': '3-person sharing room with vegetarian meals',
            'price': 38000.0,
            'accommodationType': 'sharing-3',
            'mealOptions': ['veg'],
            'inclusions': [
              '3-person sharing accommodation',
              'Vegetarian meals only',
              'Shared bathroom',
              'All activities included',
            ],
          },
          {
            'styleId': 'standard',
            'name': 'Standard Comfort',
            'description': '2-person sharing room with veg/non-veg meals',
            'price': 45000.0,
            'accommodationType': 'sharing-2',
            'mealOptions': ['veg', 'non-veg'],
            'inclusions': [
              '2-person sharing accommodation',
              'Veg & Non-veg meal options',
              'Attached bathroom',
              'All activities included',
              'Welcome drink',
            ],
          },
          {
            'styleId': 'premium',
            'name': 'Premium Solo',
            'description': 'Private room with all meal options including alcohol',
            'price': 58000.0,
            'accommodationType': 'private',
            'mealOptions': ['veg', 'non-veg', 'alcohol'],
            'inclusions': [
              'Private room',
              'All meal options (veg/non-veg)',
              'Complimentary alcohol with dinner',
              'Premium bathroom amenities',
              'All activities included',
              'Airport lounge access',
              'Priority booking for activities',
            ],
          },
        ],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },

      // Trip 2: Ladakh
      {
        'title': 'Ladakh Bike Trip',
        'description':
            'The ultimate adventure for motorcycle enthusiasts! Ride through the world\'s highest motorable passes and experience breathtaking Himalayan landscapes.',
        'imageUrl':
            'https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?w=600&q=80',
        'imageUrls': [
          'https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?w=600&q=80',
        ],
        'location': 'Leh, Ladakh',
        'duration': 6,
        'price': 22000.0,
        'categories': ['Adventure', 'Mountain', 'Biking'],
        'groupSize': 'Group of 12',
        'rating': 4.9,
        'reviewCount': 203,
        'agencyId': 'mountain-riders',
        'agencyName': 'Mountain Riders',
        'isVerifiedAgency': true,
        'status': 'live',
        'isTrending': true,
        'isFeatured': false,
        'inclusions': [
          'Royal Enfield 350cc',
          'Accommodation (5 nights)',
          'All Meals',
          'Experienced Ride Captain',
          'Backup Vehicle',
        ],
        'itinerary': [
          {
            'day': 1,
            'title': 'Arrival in Leh',
            'description': 'Arrive and acclimatize to high altitude.',
            'activities': ['Airport pickup', 'Hotel check-in', 'Rest'],
          },
          {
            'day': 2,
            'title': 'Leh Local Sightseeing',
            'description': 'Explore Leh city and test bikes.',
            'activities': [
              'Shanti Stupa visit',
              'Leh Palace',
              'Bike allocation',
            ],
          },
        ],
        'boardingPoints': [
          {
            'name': 'Delhi Airport (DEL)',
            'address': 'Indira Gandhi International Airport, Terminal 3',
            'dateTime': Timestamp.fromDate(DateTime(2025, 3, 1, 5, 0)),
          },
          {
            'name': 'Mumbai Airport (BOM)',
            'address': 'Chhatrapati Shivaji Maharaj International Airport, Terminal 2',
            'dateTime': Timestamp.fromDate(DateTime(2025, 3, 1, 4, 30)),
          },
        ],
        'droppingPoints': [
          {
            'name': 'Delhi Airport (DEL)',
            'address': 'Indira Gandhi International Airport, Terminal 3',
            'dateTime': Timestamp.fromDate(DateTime(2025, 3, 7, 20, 0)),
          },
          {
            'name': 'Mumbai Airport (BOM)',
            'address': 'Chhatrapati Shivaji Maharaj International Airport, Terminal 2',
            'dateTime': Timestamp.fromDate(DateTime(2025, 3, 7, 22, 30)),
          },
        ],
        'startDate': Timestamp.fromDate(DateTime(2025, 3, 1)),
        'endDate': Timestamp.fromDate(DateTime(2025, 3, 7)),
        'pricingStyles': [
          {
            'styleId': 'budget',
            'name': 'Budget Rider',
            'description': 'Shared accommodation with vegetarian meals',
            'price': 18000.0,
            'accommodationType': 'sharing-3',
            'mealOptions': ['veg'],
            'inclusions': [
              'Royal Enfield 350cc',
              'Shared accommodation',
              'Vegetarian meals',
              'Ride captain',
            ],
          },
          {
            'styleId': 'standard',
            'name': 'Standard Rider',
            'description': '2-person sharing with all meals',
            'price': 22000.0,
            'accommodationType': 'sharing-2',
            'mealOptions': ['veg', 'non-veg'],
            'inclusions': [
              'Royal Enfield 350cc',
              '2-person sharing',
              'All meal options',
              'Ride captain',
              'Backup vehicle',
            ],
          },
          {
            'styleId': 'premium',
            'name': 'Premium Rider',
            'description': 'Private room with premium bike',
            'price': 28000.0,
            'accommodationType': 'private',
            'mealOptions': ['veg', 'non-veg', 'alcohol'],
            'inclusions': [
              'Royal Enfield Himalayan 411cc',
              'Private room',
              'All meals + alcohol',
              'Personal ride captain',
              'GoPro camera rental',
            ],
          },
        ],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },

      // Trip 3: Goa
      {
        'title': 'Goa Party Week',
        'description':
            'Experience the ultimate beach party destination! Dance at the best clubs, relax on pristine beaches, and make lifelong friends.',
        'imageUrl':
            'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=600&q=80',
        'imageUrls': [
          'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=600&q=80',
        ],
        'location': 'North Goa',
        'duration': 4,
        'price': 15000.0,
        'categories': ['Beach', 'Party', 'Adventure'],
        'groupSize': 'Group of 20',
        'rating': 4.7,
        'reviewCount': 342,
        'agencyId': 'beach-vibes',
        'agencyName': 'Beach Vibes',
        'isVerifiedAgency': true,
        'status': 'live',
        'isTrending': true,
        'isFeatured': false,
        'inclusions': [
          'Beach Resort Stay (3 nights)',
          'Breakfast Daily',
          'Club Entry Passes',
          'Water Sports Package',
        ],
        'itinerary': [
          {
            'day': 1,
            'title': 'Arrival & Beach Welcome',
            'description': 'Welcome party at the beach.',
            'activities': ['Airport pickup', 'Check-in', 'Beach party'],
          },
          {
            'day': 2,
            'title': 'Water Sports & Club Night',
            'description': 'Morning water sports and clubbing.',
            'activities': ['Parasailing', 'Jet skiing', 'Club Cubana'],
          },
        ],
        'boardingPoints': [
          {
            'name': 'Mumbai Central Station',
            'address': 'Mumbai Central Railway Station, Platform 1',
            'dateTime': Timestamp.fromDate(DateTime(2025, 3, 10, 18, 0)),
          },
          {
            'name': 'Pune Junction',
            'address': 'Pune Junction Railway Station, Main Entrance',
            'dateTime': Timestamp.fromDate(DateTime(2025, 3, 10, 21, 0)),
          },
          {
            'name': 'Bangalore Bus Stand',
            'address': 'Majestic Bus Station, Gate 5',
            'dateTime': Timestamp.fromDate(DateTime(2025, 3, 10, 19, 30)),
          },
        ],
        'droppingPoints': [
          {
            'name': 'Mumbai Central Station',
            'address': 'Mumbai Central Railway Station, Platform 1',
            'dateTime': Timestamp.fromDate(DateTime(2025, 3, 14, 8, 0)),
          },
          {
            'name': 'Pune Junction',
            'address': 'Pune Junction Railway Station, Main Entrance',
            'dateTime': Timestamp.fromDate(DateTime(2025, 3, 14, 5, 0)),
          },
          {
            'name': 'Bangalore Bus Stand',
            'address': 'Majestic Bus Station, Gate 5',
            'dateTime': Timestamp.fromDate(DateTime(2025, 3, 14, 10, 30)),
          },
        ],
        'startDate': Timestamp.fromDate(DateTime(2025, 3, 10)),
        'endDate': Timestamp.fromDate(DateTime(2025, 3, 14)),
        'pricingStyles': [
          {
            'styleId': 'budget',
            'name': 'Beach Bum',
            'description': 'Shared dorm with breakfast only',
            'price': 12000.0,
            'accommodationType': 'sharing-3',
            'mealOptions': ['veg'],
            'inclusions': [
              'Shared dorm (6-8 people)',
              'Breakfast only',
              'Beach access',
              'Basic club entries',
            ],
          },
          {
            'styleId': 'standard',
            'name': 'Party Starter',
            'description': 'Shared room with breakfast',
            'price': 15000.0,
            'accommodationType': 'sharing-2',
            'mealOptions': ['veg', 'non-veg'],
            'inclusions': [
              '2-person sharing',
              'Breakfast daily',
              'Premium club entries',
              'Water sports package',
            ],
          },
          {
            'styleId': 'premium',
            'name': 'VIP Experience',
            'description': 'Private room with all-inclusive package',
            'price': 22000.0,
            'accommodationType': 'private',
            'mealOptions': ['veg', 'non-veg', 'alcohol'],
            'inclusions': [
              'Private AC room',
              'All meals included',
              'Unlimited alcohol package',
              'VIP club access',
              'Private yacht party',
              'Sunset cruise',
            ],
          },
        ],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },

      // Trip 4: Kerala
      {
        'title': 'Kerala Backwaters',
        'description':
            'Discover God\'s Own Country through its serene backwaters, lush greenery, and rich culture. Stay in traditional houseboats.',
        'imageUrl':
            'https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?w=600&q=80',
        'imageUrls': [
          'https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?w=600&q=80',
        ],
        'location': 'Alleppey, Kerala',
        'duration': 5,
        'price': 28000.0,
        'categories': ['Relaxation', 'Nature', 'Culture'],
        'groupSize': 'Group of 8',
        'rating': 4.8,
        'reviewCount': 178,
        'agencyId': 'kerala-explorers',
        'agencyName': 'Kerala Explorers',
        'isVerifiedAgency': true,
        'status': 'live',
        'isTrending': false,
        'isFeatured': false,
        'inclusions': [
          'Houseboat Stay (2 nights)',
          'Resort Stay (2 nights)',
          'All Meals',
          'Ayurvedic Massage',
        ],
        'itinerary': [
          {
            'day': 1,
            'title': 'Arrival in Kochi',
            'description': 'Explore Fort Kochi.',
            'activities': ['Airport pickup', 'Fort Kochi tour'],
          },
          {
            'day': 2,
            'title': 'Houseboat Journey',
            'description': 'Board traditional houseboat.',
            'activities': ['Drive to Alleppey', 'Houseboat cruise'],
          },
        ],
        'boardingPoints': [
          {
            'name': 'Kochi Airport (COK)',
            'address': 'Cochin International Airport, Arrivals Terminal',
            'dateTime': Timestamp.fromDate(DateTime(2025, 3, 20, 10, 0)),
          },
          {
            'name': 'Kochi Railway Station',
            'address': 'Ernakulam Junction Railway Station',
            'dateTime': Timestamp.fromDate(DateTime(2025, 3, 20, 11, 30)),
          },
        ],
        'droppingPoints': [
          {
            'name': 'Kochi Airport (COK)',
            'address': 'Cochin International Airport, Departures Terminal',
            'dateTime': Timestamp.fromDate(DateTime(2025, 3, 25, 16, 0)),
          },
          {
            'name': 'Kochi Railway Station',
            'address': 'Ernakulam Junction Railway Station',
            'dateTime': Timestamp.fromDate(DateTime(2025, 3, 25, 14, 30)),
          },
        ],
        'startDate': Timestamp.fromDate(DateTime(2025, 3, 20)),
        'endDate': Timestamp.fromDate(DateTime(2025, 3, 25)),
        'pricingStyles': [
          {
            'styleId': 'budget',
            'name': 'Backwater Basic',
            'description': 'Shared houseboat with vegetarian meals',
            'price': 22000.0,
            'accommodationType': 'sharing-3',
            'mealOptions': ['veg'],
            'inclusions': [
              'Shared houseboat cabin',
              'Vegetarian Kerala meals',
              'Basic Ayurvedic massage',
              'Group tours',
            ],
          },
          {
            'styleId': 'standard',
            'name': 'Backwater Comfort',
            'description': '2-person houseboat with all meals',
            'price': 28000.0,
            'accommodationType': 'sharing-2',
            'mealOptions': ['veg', 'non-veg'],
            'inclusions': [
              '2-person houseboat cabin',
              'All meal options',
              'Ayurvedic massage (1 hour)',
              'Spice plantation tour',
              'Kathakali performance',
            ],
          },
          {
            'styleId': 'premium',
            'name': 'Luxury Backwater',
            'description': 'Private houseboat with premium amenities',
            'price': 38000.0,
            'accommodationType': 'private',
            'mealOptions': ['veg', 'non-veg', 'alcohol'],
            'inclusions': [
              'Private luxury houseboat',
              'Personal chef',
              'Premium alcohol selection',
              'Full-day Ayurvedic spa',
              'Private cultural performances',
              'Wildlife sanctuary VIP access',
            ],
          },
        ],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },

      // Trip 5: Thailand Beach Paradise
      {
        'title': 'Thailand Beach\\nParadise',
        'description': 'Explore pristine beaches, crystal clear waters, and vibrant nightlife in Phuket and Krabi.',
        'location': 'Phuket, Thailand',
        'imageUrl': 'https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?w=800&q=80',
        'imageUrls': [
          'https://images.unsplash.com/photo-1589394815804-964ed0be2eb5?w=600&q=80',
          'https://images.unsplash.com/photo-1537956965359-7573183d1f57?w=600&q=80',
        ],
        'price': 28000,
        'duration': 5,
        'category': 'beach',
        'tags': ['beach', 'party', 'water sports', 'island hopping'],
        'isTrending': true,
        'isFeatured': false,
        'agencyId': 'beach-vibes',
        'agencyName': 'Beach Vibes',
        'pricingStyles': [],
        'inclusions': ['Beach Resort Stay', 'Island Tours', 'Water Activities', 'Airport Transfers'],
        'itinerary': [],
        'boardingPoints': [],
        'droppingPoints': [],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },

      // Trip 6: Manali Snow Adventure
      {
        'title': 'Manali Snow\\nAdventure',
        'description': 'Experience snowfall, skiing, and mountain adventures in the beautiful Manali valley.',
        'location': 'Manali, India',
        'imageUrl': 'https://images.unsplash.com/photo-1605649487212-47bdab064df7?w=800&q=80',
        'imageUrls': [
          'https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?w=600&q=80',
        ],
        'price': 15000,
        'duration': 4,
        'category': 'mountain',
        'tags': ['snow', 'skiing', 'adventure', 'trekking'],
        'isTrending': false,
        'isFeatured': true,
        'agencyId': 'mountain-riders',
        'agencyName': 'Mountain Riders',
        'pricingStyles': [],
        'inclusions': ['Hotel Stay', 'Skiing Equipment', 'Local Sightseeing', 'Meals'],
        'itinerary': [],
        'boardingPoints': [],
        'droppingPoints': [],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },

      // Trip 7: Dubai Luxury Escape
      {
        'title': 'Dubai Luxury\\nEscape',
        'description': 'Experience the opulence of Dubai with luxury hotels, desert safaris, and world-class shopping.',
        'location': 'Dubai, UAE',
        'imageUrl': 'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=800&q=80',
        'imageUrls': [
          'https://images.unsplash.com/photo-1518684079-3c830dcef090?w=600&q=80',
        ],
        'price': 65000,
        'duration': 5,
        'category': 'city',
        'tags': ['luxury', 'shopping', 'desert safari', 'modern'],
        'isTrending': true,
        'isFeatured': true,
        'agencyId': 'wanderlust-travels',
        'agencyName': 'Wanderlust Travels',
        'pricingStyles': [],
        'inclusions': ['5-Star Hotel', 'Desert Safari', 'City Tour', 'Burj Khalifa Visit'],
        'itinerary': [],
        'boardingPoints': [],
        'droppingPoints': [],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },

      // Trip 8: Rishikesh Yoga Retreat
      {
        'title': 'Rishikesh Yoga\\nRetreat',
        'description': 'Find inner peace with yoga, meditation, and spiritual experiences by the Ganges.',
        'location': 'Rishikesh, India',
        'imageUrl': 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=800&q=80',
        'imageUrls': [],
        'price': 12000,
        'duration': 6,
        'category': 'adventure',
        'tags': ['yoga', 'meditation', 'spiritual', 'wellness'],
        'isTrending': false,
        'isFeatured': false,
        'agencyId': 'wanderlust-travels',
        'agencyName': 'Wanderlust Travels',
        'pricingStyles': [],
        'inclusions': ['Yoga Sessions', 'Meditation Classes', 'Ashram Stay', 'Vegetarian Meals'],
        'itinerary': [],
        'boardingPoints': [],
        'droppingPoints': [],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },

      // Trip 9: Maldives Honeymoon
      {
        'title': 'Maldives\\nHoneymoon',
        'description': 'Romantic overwater villas, pristine beaches, and unforgettable sunsets in paradise.',
        'location': 'Maldives',
        'imageUrl': 'https://images.unsplash.com/photo-1514282401047-d79a71a590e8?w=800&q=80',
        'imageUrls': [],
        'price': 95000,
        'duration': 5,
        'category': 'beach',
        'tags': ['honeymoon', 'luxury', 'beach', 'romantic'],
        'isTrending': true,
        'isFeatured': true,
        'agencyId': 'beach-vibes',
        'agencyName': 'Beach Vibes',
        'pricingStyles': [],
        'inclusions': ['Overwater Villa', 'Spa Treatments', 'Water Sports', 'Candlelight Dinner'],
        'itinerary': [],
        'boardingPoints': [],
        'droppingPoints': [],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },

      // Trip 10: Jaipur Heritage Tour
      {
        'title': 'Jaipur Heritage\\nTour',
        'description': 'Explore the Pink City with its magnificent forts, palaces, and rich Rajasthani culture.',
        'location': 'Jaipur, India',
        'imageUrl': 'https://images.unsplash.com/photo-1477587458883-47145ed94245?w=800&q=80',
        'imageUrls': [],
        'price': 18000,
        'duration': 4,
        'category': 'city',
        'tags': ['heritage', 'culture', 'forts', 'palaces'],
        'isTrending': false,
        'isFeatured': false,
        'agencyId': 'wanderlust-travels',
        'agencyName': 'Wanderlust Travels',
        'pricingStyles': [],
        'inclusions': ['Heritage Hotel', 'Fort Visits', 'Cultural Shows', 'Local Cuisine'],
        'itinerary': [],
        'boardingPoints': [],
        'droppingPoints': [],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },

      // Continue with 40 more trips...
      // Trip 11-50 with varied categories, prices, and destinations

      {'title': 'Sikkim Monastery\\nTrek', 'description': 'Trek through Buddhist monasteries in the Himalayas.', 'location': 'Sikkim, India', 'imageUrl': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&q=80', 'imageUrls': [], 'price': 22000, 'duration': 7, 'category': 'mountain', 'tags': ['trekking', 'spiritual', 'mountains'], 'isTrending': false, 'isFeatured': false, 'agencyId': 'mountain-riders', 'agencyName': 'Mountain Riders', 'pricingStyles': [], 'inclusions': ['Trekking Guide', 'Camping', 'Meals'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},
      {'title': 'Andaman Islands\\nDiving', 'description': 'Scuba diving and snorkeling in crystal clear waters.', 'location': 'Andaman, India', 'imageUrl': 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800&q=80', 'imageUrls': [], 'price': 32000, 'duration': 5, 'category': 'beach', 'tags': ['diving', 'beach', 'adventure'], 'isTrending': true, 'isFeatured': false, 'agencyId': 'beach-vibes', 'agencyName': 'Beach Vibes', 'pricingStyles': [], 'inclusions': ['Diving Course', 'Beach Resort', 'Island Tours'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},
      {'title': 'Singapore City\\nBreak', 'description': 'Modern city exploration with Gardens by the Bay and Marina Bay.', 'location': 'Singapore', 'imageUrl': 'https://images.unsplash.com/photo-1525625293386-3f8f99389edd?w=800&q=80', 'imageUrls': [], 'price': 45000, 'duration': 4, 'category': 'city', 'tags': ['modern', 'shopping', 'food'], 'isTrending': false, 'isFeatured': true, 'agencyId': 'wanderlust-travels', 'agencyName': 'Wanderlust Travels', 'pricingStyles': [], 'inclusions': ['Hotel', 'City Tour', 'Universal Studios'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},
      {'title': 'Spiti Valley\\nExpedition', 'description': 'Remote Himalayan valley with ancient monasteries.', 'location': 'Spiti, India', 'imageUrl': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&q=80', 'imageUrls': [], 'price': 28000, 'duration': 8, 'category': 'mountain', 'tags': ['adventure', 'remote', 'trekking'], 'isTrending': false, 'isFeatured': false, 'agencyId': 'mountain-riders', 'agencyName': 'Mountain Riders', 'pricingStyles': [], 'inclusions': ['Camping', 'Meals', 'Guide'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},
      {'title': 'Coorg Coffee\\nPlantation', 'description': 'Relax in coffee estates with waterfalls and nature walks.', 'location': 'Coorg, India', 'imageUrl': 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800&q=80', 'imageUrls': [], 'price': 14000, 'duration': 3, 'category': 'adventure', 'tags': ['nature', 'coffee', 'relaxation'], 'isTrending': false, 'isFeatured': false, 'agencyId': 'kerala-explorers', 'agencyName': 'Kerala Explorers', 'pricingStyles': [], 'inclusions': ['Homestay', 'Plantation Tour', 'Meals'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},
      
      {'title': 'Rajasthan Desert\\nSafari', 'description': 'Camel safari through Thar Desert with cultural experiences.', 'location': 'Jaisalmer, India', 'imageUrl': 'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?w=800&q=80', 'imageUrls': [], 'price': 19000, 'duration': 5, 'category': 'adventure', 'tags': ['desert', 'camel', 'culture'], 'isTrending': true, 'isFeatured': false, 'agencyId': 'wanderlust-travels', 'agencyName': 'Wanderlust Travels', 'pricingStyles': [], 'inclusions': ['Desert Camp', 'Camel Ride', 'Folk Music'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},
      {'title': 'Hampi Ruins\\nExploration', 'description': 'Ancient temple ruins and boulder landscapes.', 'location': 'Hampi, India', 'imageUrl': 'https://images.unsplash.com/photo-1582510003544-4d00b7f74220?w=800&q=80', 'imageUrls': [], 'price': 16000, 'duration': 4, 'category': 'city', 'tags': ['heritage', 'ruins', 'history'], 'isTrending': false, 'isFeatured': false, 'agencyId': 'wanderlust-travels', 'agencyName': 'Wanderlust Travels', 'pricingStyles': [], 'inclusions': ['Hotel', 'Guide', 'Temple Tours'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},
      {'title': 'Meghalaya Living\\nRoots', 'description': 'Trek to living root bridges in the wettest place on Earth.', 'location': 'Meghalaya, India', 'imageUrl': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&q=80', 'imageUrls': [], 'price': 24000, 'duration': 6, 'category': 'mountain', 'tags': ['trekking', 'nature', 'unique'], 'isTrending': true, 'isFeatured': true, 'agencyId': 'mountain-riders', 'agencyName': 'Mountain Riders', 'pricingStyles': [], 'inclusions': ['Homestay', 'Trekking', 'Meals'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},
      {'title': 'Vietnam Halong\\nBay Cruise', 'description': 'Cruise through limestone karsts and emerald waters.', 'location': 'Halong Bay, Vietnam', 'imageUrl': 'https://images.unsplash.com/photo-1528127269322-539801943592?w=800&q=80', 'imageUrls': [], 'price': 38000, 'duration': 5, 'category': 'beach', 'tags': ['cruise', 'scenic', 'beach'], 'isTrending': false, 'isFeatured': false, 'agencyId': 'beach-vibes', 'agencyName': 'Beach Vibes', 'pricingStyles': [], 'inclusions': ['Cruise Stay', 'Meals', 'Kayaking'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},
      {'title': 'Bhutan Happiness\\nTour', 'description': 'Explore the Land of Happiness with monasteries and mountains.', 'location': 'Bhutan', 'imageUrl': 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=800&q=80', 'imageUrls': [], 'price': 55000, 'duration': 7, 'category': 'mountain', 'tags': ['spiritual', 'culture', 'mountains'], 'isTrending': false, 'isFeatured': true, 'agencyId': 'wanderlust-travels', 'agencyName': 'Wanderlust Travels', 'pricingStyles': [], 'inclusions': ['Hotel', 'Monastery Visits', 'Guide', 'Meals'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},

      {'title': 'Udaipur Lake\\nCity Romance', 'description': 'Romantic palaces and lake views in the Venice of the East.', 'location': 'Udaipur, India', 'imageUrl': 'https://images.unsplash.com/photo-1587474260584-136574528ed5?w=800&q=80', 'imageUrls': [], 'price': 21000, 'duration': 4, 'category': 'city', 'tags': ['romantic', 'palaces', 'lakes'], 'isTrending': false, 'isFeatured': false, 'agencyId': 'wanderlust-travels', 'agencyName': 'Wanderlust Travels', 'pricingStyles': [], 'inclusions': ['Lake View Hotel', 'Boat Ride', 'Palace Tours'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},
      {'title': 'Darjeeling Tea\\nGardens', 'description': 'Toy train rides and tea plantation visits in the Himalayas.', 'location': 'Darjeeling, India', 'imageUrl': 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800&q=80', 'imageUrls': [], 'price': 17000, 'duration': 5, 'category': 'mountain', 'tags': ['tea', 'scenic', 'heritage'], 'isTrending': false, 'isFeatured': false, 'agencyId': 'mountain-riders', 'agencyName': 'Mountain Riders', 'pricingStyles': [], 'inclusions': ['Hotel', 'Toy Train', 'Tea Garden Tour'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},
      {'title': 'Varanasi Spiritual\\nJourney', 'description': 'Ancient city of temples and Ganga Aarti ceremonies.', 'location': 'Varanasi, India', 'imageUrl': 'https://images.unsplash.com/photo-1561361513-2d000a50f0dc?w=800&q=80', 'imageUrls': [], 'price': 13000, 'duration': 3, 'category': 'city', 'tags': ['spiritual', 'temples', 'culture'], 'isTrending': true, 'isFeatured': false, 'agencyId': 'wanderlust-travels', 'agencyName': 'Wanderlust Travels', 'pricingStyles': [], 'inclusions': ['Hotel', 'Boat Ride', 'Temple Tours'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},
      {'title': 'Munnar Hill\\nStation', 'description': 'Tea plantations and misty mountains in Gods Own Country.', 'location': 'Munnar, India', 'imageUrl': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&q=80', 'imageUrls': [], 'price': 16000, 'duration': 4, 'category': 'mountain', 'tags': ['tea', 'nature', 'scenic'], 'isTrending': false, 'isFeatured': false, 'agencyId': 'kerala-explorers', 'agencyName': 'Kerala Explorers', 'pricingStyles': [], 'inclusions': ['Resort', 'Tea Garden Tour', 'Trekking'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},
      {'title': 'Gokarna Beach\\nRetreat', 'description': 'Peaceful beaches and temple town vibes.', 'location': 'Gokarna, India', 'imageUrl': 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800&q=80', 'imageUrls': [], 'price': 12000, 'duration': 3, 'category': 'beach', 'tags': ['beach', 'peaceful', 'temples'], 'isTrending': false, 'isFeatured': false, 'agencyId': 'beach-vibes', 'agencyName': 'Beach Vibes', 'pricingStyles': [], 'inclusions': ['Beach Hut', 'Yoga', 'Meals'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},

      {'title': 'Ooty Nilgiri\\nExpress', 'description': 'Toy train through blue mountains and colonial charm.', 'location': 'Ooty, India', 'imageUrl': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&q=80', 'imageUrls': [], 'price': 14000, 'duration': 3, 'category': 'mountain', 'tags': ['heritage', 'scenic', 'colonial'], 'isTrending': false, 'isFeatured': false, 'agencyId': 'mountain-riders', 'agencyName': 'Mountain Riders', 'pricingStyles': [], 'inclusions': ['Hotel', 'Toy Train', 'Lake Visit'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},
      {'title': 'Pondicherry French\\nQuarter', 'description': 'French colonial architecture and beach vibes.', 'location': 'Pondicherry, India', 'imageUrl': 'https://images.unsplash.com/photo-1582510003544-4d00b7f74220?w=800&q=80', 'imageUrls': [], 'price': 11000, 'duration': 3, 'category': 'city', 'tags': ['colonial', 'beach', 'culture'], 'isTrending': false, 'isFeatured': false, 'agencyId': 'beach-vibes', 'agencyName': 'Beach Vibes', 'pricingStyles': [], 'inclusions': ['Hotel', 'City Tour', 'Auroville Visit'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},
      {'title': 'Rann of Kutch\\nWhite Desert', 'description': 'Endless white salt desert under full moon.', 'location': 'Kutch, India', 'imageUrl': 'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?w=800&q=80', 'imageUrls': [], 'price': 20000, 'duration': 4, 'category': 'adventure', 'tags': ['desert', 'unique', 'culture'], 'isTrending': true, 'isFeatured': true, 'agencyId': 'wanderlust-travels', 'agencyName': 'Wanderlust Travels', 'pricingStyles': [], 'inclusions': ['Tent Stay', 'Cultural Shows', 'Meals'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},
      {'title': 'Lakshadweep Coral\\nIslands', 'description': 'Untouched coral islands with turquoise lagoons.', 'location': 'Lakshadweep, India', 'imageUrl': 'https://images.unsplash.com/photo-1514282401047-d79a71a590e8?w=800&q=80', 'imageUrls': [], 'price': 42000, 'duration': 5, 'category': 'beach', 'tags': ['islands', 'snorkeling', 'pristine'], 'isTrending': false, 'isFeatured': false, 'agencyId': 'beach-vibes', 'agencyName': 'Beach Vibes', 'pricingStyles': [], 'inclusions': ['Island Resort', 'Snorkeling', 'Boat Rides'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},
      {'title': 'Khajuraho Temple\\nArt', 'description': 'UNESCO heritage temples with intricate sculptures.', 'location': 'Khajuraho, India', 'imageUrl': 'https://images.unsplash.com/photo-1582510003544-4d00b7f74220?w=800&q=80', 'imageUrls': [], 'price': 15000, 'duration': 3, 'category': 'city', 'tags': ['heritage', 'temples', 'art'], 'isTrending': false, 'isFeatured': false, 'agencyId': 'wanderlust-travels', 'agencyName': 'Wanderlust Travels', 'pricingStyles': [], 'inclusions': ['Hotel', 'Temple Tours', 'Light Show'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},

      {'title': 'Zanskar Frozen\\nRiver Trek', 'description': 'Trek on frozen Zanskar river in extreme winter.', 'location': 'Zanskar, India', 'imageUrl': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&q=80', 'imageUrls': [], 'price': 35000, 'duration': 9, 'category': 'mountain', 'tags': ['extreme', 'trekking', 'adventure'], 'isTrending': true, 'isFeatured': false, 'agencyId': 'mountain-riders', 'agencyName': 'Mountain Riders', 'pricingStyles': [], 'inclusions': ['Camping', 'Guide', 'Equipment', 'Meals'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},
      {'title': 'Agra Taj Mahal\\nWonder', 'description': 'Visit the symbol of love and Mughal architecture.', 'location': 'Agra, India', 'imageUrl': 'https://images.unsplash.com/photo-1564507592333-c60657eea523?w=800&q=80', 'imageUrls': [], 'price': 10000, 'duration': 2, 'category': 'city', 'tags': ['heritage', 'iconic', 'photography'], 'isTrending': false, 'isFeatured': true, 'agencyId': 'wanderlust-travels', 'agencyName': 'Wanderlust Travels', 'pricingStyles': [], 'inclusions': ['Hotel', 'Taj Mahal Visit', 'Fort Tour'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},
      {'title': 'Kaziranga Wildlife\\nSafari', 'description': 'Spot one-horned rhinos in their natural habitat.', 'location': 'Kaziranga, India', 'imageUrl': 'https://images.unsplash.com/photo-1549366021-9f761d450615?w=800&q=80', 'imageUrls': [], 'price': 23000, 'duration': 4, 'category': 'adventure', 'tags': ['wildlife', 'safari', 'nature'], 'isTrending': false, 'isFeatured': false, 'agencyId': 'wanderlust-travels', 'agencyName': 'Wanderlust Travels', 'pricingStyles': [], 'inclusions': ['Resort', 'Jeep Safari', 'Elephant Ride'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},
      {'title': 'Mysore Palace\\nHeritage', 'description': 'Royal palaces and Dasara festival celebrations.', 'location': 'Mysore, India', 'imageUrl': 'https://images.unsplash.com/photo-1582510003544-4d00b7f74220?w=800&q=80', 'imageUrls': [], 'price': 14000, 'duration': 3, 'category': 'city', 'tags': ['heritage', 'palaces', 'culture'], 'isTrending': false, 'isFeatured': false, 'agencyId': 'wanderlust-travels', 'agencyName': 'Wanderlust Travels', 'pricingStyles': [], 'inclusions': ['Hotel', 'Palace Tours', 'Chamundi Hills'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},
      {'title': 'Nainital Lake\\nGetaway', 'description': 'Scenic lake town in the Kumaon hills.', 'location': 'Nainital, India', 'imageUrl': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&q=80', 'imageUrls': [], 'price': 13000, 'duration': 3, 'category': 'mountain', 'tags': ['lake', 'scenic', 'peaceful'], 'isTrending': false, 'isFeatured': false, 'agencyId': 'mountain-riders', 'agencyName': 'Mountain Riders', 'pricingStyles': [], 'inclusions': ['Lake View Hotel', 'Boating', 'Cable Car'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},

      {'title': 'Konark Sun\\nTemple', 'description': 'Ancient sun temple and Odisha beaches.', 'location': 'Konark, India', 'imageUrl': 'https://images.unsplash.com/photo-1582510003544-4d00b7f74220?w=800&q=80', 'imageUrls': [], 'price': 16000, 'duration': 4, 'category': 'city', 'tags': ['heritage', 'temples', 'beach'], 'isTrending': false, 'isFeatured': false, 'agencyId': 'wanderlust-travels', 'agencyName': 'Wanderlust Travels', 'pricingStyles': [], 'inclusions': ['Hotel', 'Temple Tours', 'Beach Visit'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},
      {'title': 'Shimla Colonial\\nCharm', 'description': 'British-era architecture and mountain views.', 'location': 'Shimla, India', 'imageUrl': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&q=80', 'imageUrls': [], 'price': 15000, 'duration': 4, 'category': 'mountain', 'tags': ['colonial', 'scenic', 'heritage'], 'isTrending': false, 'isFeatured': false, 'agencyId': 'mountain-riders', 'agencyName': 'Mountain Riders', 'pricingStyles': [], 'inclusions': ['Hotel', 'Mall Road Walk', 'Toy Train'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},
      {'title': 'Pushkar Camel\\nFair', 'description': 'Worlds largest camel fair and holy lake.', 'location': 'Pushkar, India', 'imageUrl': 'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?w=800&q=80', 'imageUrls': [], 'price': 17000, 'duration': 3, 'category': 'adventure', 'tags': ['festival', 'culture', 'unique'], 'isTrending': true, 'isFeatured': false, 'agencyId': 'wanderlust-travels', 'agencyName': 'Wanderlust Travels', 'pricingStyles': [], 'inclusions': ['Tent Stay', 'Fair Entry', 'Cultural Shows'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},
      {'title': 'Auli Skiing\\nAdventure', 'description': 'Premier skiing destination in Uttarakhand.', 'location': 'Auli, India', 'imageUrl': 'https://images.unsplash.com/photo-1605649487212-47bdab064df7?w=800&q=80', 'imageUrls': [], 'price': 26000, 'duration': 5, 'category': 'mountain', 'tags': ['skiing', 'snow', 'adventure'], 'isTrending': false, 'isFeatured': true, 'agencyId': 'mountain-riders', 'agencyName': 'Mountain Riders', 'pricingStyles': [], 'inclusions': ['Resort', 'Skiing Equipment', 'Instructor'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},
      {'title': 'Varkala Cliff\\nBeach', 'description': 'Dramatic cliffs overlooking Arabian Sea beaches.', 'location': 'Varkala, India', 'imageUrl': 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800&q=80', 'imageUrls': [], 'price': 13000, 'duration': 3, 'category': 'beach', 'tags': ['beach', 'cliffs', 'peaceful'], 'isTrending': false, 'isFeatured': false, 'agencyId': 'kerala-explorers', 'agencyName': 'Kerala Explorers', 'pricingStyles': [], 'inclusions': ['Beach Resort', 'Ayurveda Spa', 'Meals'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},

      {'title': 'Mahabalipuram Rock\\nTemples', 'description': 'Ancient rock-cut temples by the sea.', 'location': 'Mahabalipuram, India', 'imageUrl': 'https://images.unsplash.com/photo-1582510003544-4d00b7f74220?w=800&q=80', 'imageUrls': [], 'price': 12000, 'duration': 2, 'category': 'city', 'tags': ['heritage', 'temples', 'beach'], 'isTrending': false, 'isFeatured': false, 'agencyId': 'wanderlust-travels', 'agencyName': 'Wanderlust Travels', 'pricingStyles': [], 'inclusions': ['Hotel', 'Temple Tours', 'Beach Time'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},
      {'title': 'Tawang Monastery\\nPeace', 'description': 'Largest monastery in India with mountain views.', 'location': 'Tawang, India', 'imageUrl': 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=800&q=80', 'imageUrls': [], 'price': 29000, 'duration': 6, 'category': 'mountain', 'tags': ['spiritual', 'monastery', 'remote'], 'isTrending': false, 'isFeatured': false, 'agencyId': 'mountain-riders', 'agencyName': 'Mountain Riders', 'pricingStyles': [], 'inclusions': ['Hotel', 'Monastery Visit', 'Permits'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},
      {'title': 'Alleppey Houseboat\\nCruise', 'description': 'Backwater cruise through palm-fringed canals.', 'location': 'Alleppey, India', 'imageUrl': 'https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?w=800&q=80', 'imageUrls': [], 'price': 18000, 'duration': 2, 'category': 'beach', 'tags': ['houseboat', 'backwaters', 'peaceful'], 'isTrending': true, 'isFeatured': true, 'agencyId': 'kerala-explorers', 'agencyName': 'Kerala Explorers', 'pricingStyles': [], 'inclusions': ['Houseboat Stay', 'Meals', 'Village Tours'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},
      {'title': 'Jodhpur Blue\\nCity', 'description': 'Majestic forts and blue-painted old town.', 'location': 'Jodhpur, India', 'imageUrl': 'https://images.unsplash.com/photo-1477587458883-47145ed94245?w=800&q=80', 'imageUrls': [], 'price': 16000, 'duration': 3, 'category': 'city', 'tags': ['heritage', 'forts', 'culture'], 'isTrending': false, 'isFeatured': false, 'agencyId': 'wanderlust-travels', 'agencyName': 'Wanderlust Travels', 'pricingStyles': [], 'inclusions': ['Heritage Hotel', 'Fort Tours', 'Zip Lining'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},
      {'title': 'Cherrapunji Rain\\nForest', 'description': 'Wettest place on Earth with waterfalls.', 'location': 'Cherrapunji, India', 'imageUrl': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&q=80', 'imageUrls': [], 'price': 21000, 'duration': 5, 'category': 'mountain', 'tags': ['waterfalls', 'nature', 'trekking'], 'isTrending': false, 'isFeatured': false, 'agencyId': 'mountain-riders', 'agencyName': 'Mountain Riders', 'pricingStyles': [], 'inclusions': ['Homestay', 'Waterfall Tours', 'Trekking'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},

      {'title': 'Lonavala Monsoon\\nMagic', 'description': 'Lush green hills and waterfalls near Mumbai.', 'location': 'Lonavala, India', 'imageUrl': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&q=80', 'imageUrls': [], 'price': 9000, 'duration': 2, 'category': 'mountain', 'tags': ['monsoon', 'waterfalls', 'scenic'], 'isTrending': false, 'isFeatured': false, 'agencyId': 'mountain-riders', 'agencyName': 'Mountain Riders', 'pricingStyles': [], 'inclusions': ['Resort', 'Sightseeing', 'Meals'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},
      {'title': 'Kodaikanal Lake\\nRetreat', 'description': 'Princess of hill stations with serene lake.', 'location': 'Kodaikanal, India', 'imageUrl': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&q=80', 'imageUrls': [], 'price': 14000, 'duration': 3, 'category': 'mountain', 'tags': ['lake', 'peaceful', 'nature'], 'isTrending': false, 'isFeatured': false, 'agencyId': 'mountain-riders', 'agencyName': 'Mountain Riders', 'pricingStyles': [], 'inclusions': ['Hotel', 'Boating', 'Nature Walks'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},
      {'title': 'Mount Abu\\nRajasthan Hills', 'description': 'Only hill station in Rajasthan with Dilwara temples.', 'location': 'Mount Abu, India', 'imageUrl': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&q=80', 'imageUrls': [], 'price': 15000, 'duration': 3, 'category': 'mountain', 'tags': ['temples', 'lake', 'heritage'], 'isTrending': false, 'isFeatured': false, 'agencyId': 'wanderlust-travels', 'agencyName': 'Wanderlust Travels', 'pricingStyles': [], 'inclusions': ['Hotel', 'Temple Tours', 'Sunset Point'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},
      {'title': 'Diu Portuguese\\nIsland', 'description': 'Quiet beaches and Portuguese colonial heritage.', 'location': 'Diu, India', 'imageUrl': 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800&q=80', 'imageUrls': [], 'price': 11000, 'duration': 3, 'category': 'beach', 'tags': ['beach', 'colonial', 'peaceful'], 'isTrending': false, 'isFeatured': false, 'agencyId': 'beach-vibes', 'agencyName': 'Beach Vibes', 'pricingStyles': [], 'inclusions': ['Beach Resort', 'Fort Visit', 'Water Sports'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},
      {'title': 'Gangtok Himalayan\\nViews', 'description': 'Kanchenjunga views and Buddhist monasteries.', 'location': 'Gangtok, India', 'imageUrl': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&q=80', 'imageUrls': [], 'price': 19000, 'duration': 5, 'category': 'mountain', 'tags': ['mountains', 'monastery', 'scenic'], 'isTrending': true, 'isFeatured': false, 'agencyId': 'mountain-riders', 'agencyName': 'Mountain Riders', 'pricingStyles': [], 'inclusions': ['Hotel', 'Monastery Tours', 'Cable Car'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},

      {'title': 'Puri Jagannath\\nTemple', 'description': 'Sacred temple and golden beaches of Odisha.', 'location': 'Puri, India', 'imageUrl': 'https://images.unsplash.com/photo-1582510003544-4d00b7f74220?w=800&q=80', 'imageUrls': [], 'price': 13000, 'duration': 3, 'category': 'city', 'tags': ['spiritual', 'beach', 'temples'], 'isTrending': false, 'isFeatured': false, 'agencyId': 'wanderlust-travels', 'agencyName': 'Wanderlust Travels', 'pricingStyles': [], 'inclusions': ['Hotel', 'Temple Visit', 'Beach Time'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},
      {'title': 'Wayanad Wildlife\\nEscape', 'description': 'Rainforests, wildlife, and tribal culture.', 'location': 'Wayanad, India', 'imageUrl': 'https://images.unsplash.com/photo-1549366021-9f761d450615?w=800&q=80', 'imageUrls': [], 'price': 16000, 'duration': 4, 'category': 'adventure', 'tags': ['wildlife', 'nature', 'trekking'], 'isTrending': false, 'isFeatured': false, 'agencyId': 'kerala-explorers', 'agencyName': 'Kerala Explorers', 'pricingStyles': [], 'inclusions': ['Resort', 'Safari', 'Trekking'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},
      {'title': 'Amritsar Golden\\nTemple', 'description': 'Sacred Sikh shrine and Wagah border ceremony.', 'location': 'Amritsar, India', 'imageUrl': 'https://images.unsplash.com/photo-1582510003544-4d00b7f74220?w=800&q=80', 'imageUrls': [], 'price': 14000, 'duration': 3, 'category': 'city', 'tags': ['spiritual', 'heritage', 'culture'], 'isTrending': false, 'isFeatured': true, 'agencyId': 'wanderlust-travels', 'agencyName': 'Wanderlust Travels', 'pricingStyles': [], 'inclusions': ['Hotel', 'Temple Visit', 'Wagah Border'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},
      {'title': 'Tarkarli Scuba\\nDiving', 'description': 'Clear waters perfect for scuba diving in Maharashtra.', 'location': 'Tarkarli, India', 'imageUrl': 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800&q=80', 'imageUrls': [], 'price': 13000, 'duration': 2, 'category': 'beach', 'tags': ['diving', 'beach', 'adventure'], 'isTrending': false, 'isFeatured': false, 'agencyId': 'beach-vibes', 'agencyName': 'Beach Vibes', 'pricingStyles': [], 'inclusions': ['Beach Stay', 'Scuba Diving', 'Meals'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},
      {'title': 'Pachmarhi Hill\\nStation', 'description': 'Queen of Satpura with caves and waterfalls.', 'location': 'Pachmarhi, India', 'imageUrl': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&q=80', 'imageUrls': [], 'price': 14000, 'duration': 3, 'category': 'mountain', 'tags': ['waterfalls', 'caves', 'nature'], 'isTrending': false, 'isFeatured': false, 'agencyId': 'mountain-riders', 'agencyName': 'Mountain Riders', 'pricingStyles': [], 'inclusions': ['Hotel', 'Sightseeing', 'Trekking'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},

      {'title': 'Kanyakumari Sunrise\\nSunset', 'description': 'Southernmost tip where three seas meet.', 'location': 'Kanyakumari, India', 'imageUrl': 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800&q=80', 'imageUrls': [], 'price': 12000, 'duration': 2, 'category': 'beach', 'tags': ['scenic', 'spiritual', 'unique'], 'isTrending': false, 'isFeatured': false, 'agencyId': 'kerala-explorers', 'agencyName': 'Kerala Explorers', 'pricingStyles': [], 'inclusions': ['Hotel', 'Sunrise View', 'Temple Visits'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},
      {'title': 'Khardung La\\nMotorbike', 'description': 'Worlds highest motorable pass adventure.', 'location': 'Ladakh, India', 'imageUrl': 'https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?w=800&q=80', 'imageUrls': [], 'price': 42000, 'duration': 10, 'category': 'adventure', 'tags': ['biking', 'extreme', 'mountains'], 'isTrending': true, 'isFeatured': true, 'agencyId': 'mountain-riders', 'agencyName': 'Mountain Riders', 'pricingStyles': [], 'inclusions': ['Bike Rental', 'Camping', 'Guide', 'Permits'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},
      {'title': 'Orchha Medieval\\nTown', 'description': 'Forgotten medieval town with palaces and temples.', 'location': 'Orchha, India', 'imageUrl': 'https://images.unsplash.com/photo-1582510003544-4d00b7f74220?w=800&q=80', 'imageUrls': [], 'price': 13000, 'duration': 3, 'category': 'city', 'tags': ['heritage', 'medieval', 'offbeat'], 'isTrending': false, 'isFeatured': false, 'agencyId': 'wanderlust-travels', 'agencyName': 'Wanderlust Travels', 'pricingStyles': [], 'inclusions': ['Heritage Stay', 'Palace Tours', 'River Rafting'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},
      {'title': 'Chikmagalur Coffee\\nTrails', 'description': 'Coffee plantations and misty mountains.', 'location': 'Chikmagalur, India', 'imageUrl': 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800&q=80', 'imageUrls': [], 'price': 15000, 'duration': 3, 'category': 'mountain', 'tags': ['coffee', 'nature', 'trekking'], 'isTrending': false, 'isFeatured': false, 'agencyId': 'kerala-explorers', 'agencyName': 'Kerala Explorers', 'pricingStyles': [], 'inclusions': ['Plantation Stay', 'Coffee Tour', 'Trekking'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},
      {'title': 'Neil Island\\nBeach Bliss', 'description': 'Secluded beaches in Andaman with coral reefs.', 'location': 'Neil Island, India', 'imageUrl': 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800&q=80', 'imageUrls': [], 'price': 28000, 'duration': 4, 'category': 'beach', 'tags': ['beach', 'snorkeling', 'peaceful'], 'isTrending': false, 'isFeatured': false, 'agencyId': 'beach-vibes', 'agencyName': 'Beach Vibes', 'pricingStyles': [], 'inclusions': ['Beach Resort', 'Snorkeling', 'Island Tours'], 'itinerary': [], 'boardingPoints': [], 'droppingPoints': [], 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp()},
    ];

      for (var i = 0; i < sampleTrips.length; i++) {
        final tripData = sampleTrips[i];
        final title = tripData['title'] as String;

        setState(() {
          _status = 'Adding trip ${i + 1}/${sampleTrips.length}: $title';
        });

        await firestore.collection('trips').add(tripData);

        setState(() {
          _logs.add('✅ Added trip: $title');
        });

        await Future.delayed(const Duration(milliseconds: 500));
      }

      setState(() {
        _status =
            '🎉 Success! Added ${sampleAgencies.length} agencies and ${sampleTrips.length} trips to Firestore';
        _isSeeding = false;
      });
    } catch (e) {
      setState(() {
        _status = '❌ Error: $e';
        _logs.add('Error: $e');
        _isSeeding = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      appBar: AppBar(
        title: Text('Seed Trips to Firebase'),
        backgroundColor: const Color(0xFF0A0A0A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Firebase Data Seeder',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This will add 4 agencies and 4 sample trips to your Firestore database.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white60,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isSeeding ? null : _seedTrips,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isSeeding
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text('Seeding...'),
                      ],
                    )
                  : Text(
                      'Seed Trips to Firebase',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            const SizedBox(height: 24),
            if (_status.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF18181B),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.surfacePressed,
                  ),
                ),
                child: Text(
                  _status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            if (_logs.isNotEmpty)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0A0A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.surfacePressed,
                    ),
                  ),
                  child: ListView.builder(
                    itemCount: _logs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          _logs[index],
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontFamily: 'monospace',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
