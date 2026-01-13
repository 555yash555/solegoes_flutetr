import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      // STEP 1: Seed Agencies
      // ============================================
      setState(() {
        _status = 'Step 1/2: Seeding agencies...';
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
        _status = 'Step 2/2: Seeding trips...';
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
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
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
        title: const Text('Seed Trips to Firebase'),
        backgroundColor: const Color(0xFF0A0A0A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Firebase Data Seeder',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
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
                  : const Text(
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
                    color: Colors.white.withValues(alpha: 0.1),
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
                      color: Colors.white.withValues(alpha: 0.1),
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
