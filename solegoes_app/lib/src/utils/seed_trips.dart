import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

/// Script to seed sample trips into Firestore
/// Run this once to populate the database with sample data
Future<void> seedTrips() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firestore = FirebaseFirestore.instance;
  final tripsCollection = firestore.collection('trips');

  print('🌱 Seeding trips to Firestore...');

  final sampleTrips = [
    // Trip 1: Bali Spiritual Awakening
    {
      'title': 'Bali Spiritual\nAwakening',
      'description':
          'Embark on a transformative journey through Bali\'s spiritual heart. Experience ancient temples, yoga sessions at sunrise, traditional healing ceremonies, and meditation in lush rice terraces. This trip combines cultural immersion with personal growth.',
      'imageUrl':
          'https://images.unsplash.com/photo-1537996194471-e657df975ab4?w=800&q=80',
      'imageUrls': [
        'https://images.unsplash.com/photo-1537996194471-e657df975ab4?w=800&q=80',
        'https://images.unsplash.com/photo-1555400038-63f5ba517a47?w=800&q=80',
        'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800&q=80',
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
        'Travel Insurance',
      ],
      'itinerary': [
        {
          'day': 1,
          'title': 'Arrival & Welcome Ceremony',
          'description':
              'Arrive in Bali and transfer to our beautiful resort in Ubud. Evening welcome ceremony and group dinner.',
          'activities': [
            'Airport pickup',
            'Check-in at resort',
            'Welcome ceremony',
            'Group dinner'
          ],
          'meals': 'Dinner',
          'accommodation': 'Ubud Wellness Resort',
        },
        {
          'day': 2,
          'title': 'Temple Tour & Rice Terraces',
          'description':
              'Visit ancient temples including Tirta Empul water temple. Explore the famous Tegalalang rice terraces.',
          'activities': [
            'Sunrise yoga',
            'Tirta Empul temple visit',
            'Holy water purification',
            'Rice terrace walk',
            'Traditional lunch'
          ],
          'meals': 'Breakfast, Lunch, Dinner',
          'accommodation': 'Ubud Wellness Resort',
        },
        {
          'day': 3,
          'title': 'Healing & Meditation',
          'description':
              'Experience traditional Balinese healing ceremony. Afternoon meditation session in nature.',
          'activities': [
            'Morning yoga',
            'Healing ceremony with local healer',
            'Meditation in rice fields',
            'Spa treatment'
          ],
          'meals': 'Breakfast, Lunch, Dinner',
          'accommodation': 'Ubud Wellness Resort',
        },
        {
          'day': 4,
          'title': 'Cultural Immersion',
          'description':
              'Learn traditional Balinese cooking and participate in a local ceremony.',
          'activities': [
            'Cooking class',
            'Market visit',
            'Traditional dance performance',
            'Local ceremony participation'
          ],
          'meals': 'Breakfast, Lunch, Dinner',
          'accommodation': 'Ubud Wellness Resort',
        },
        {
          'day': 5,
          'title': 'Waterfall Trek & Jungle Yoga',
          'description':
              'Trek to hidden waterfalls and practice yoga in the jungle.',
          'activities': [
            'Jungle trek',
            'Waterfall swim',
            'Jungle yoga session',
            'Organic farm visit'
          ],
          'meals': 'Breakfast, Lunch, Dinner',
          'accommodation': 'Ubud Wellness Resort',
        },
        {
          'day': 6,
          'title': 'Sacred Mountain Visit',
          'description':
              'Visit Mount Batur for sunrise and explore sacred sites.',
          'activities': [
            'Early morning Mount Batur visit',
            'Sunrise viewing',
            'Hot springs',
            'Coffee plantation tour'
          ],
          'meals': 'Breakfast, Lunch, Dinner',
          'accommodation': 'Ubud Wellness Resort',
        },
        {
          'day': 7,
          'title': 'Departure',
          'description':
              'Final yoga session and farewell ceremony. Transfer to airport.',
          'activities': [
            'Sunrise yoga',
            'Farewell ceremony',
            'Check-out',
            'Airport transfer'
          ],
          'meals': 'Breakfast',
          'accommodation': null,
        },
      ],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    },

    // Trip 2: Ladakh Bike Trip
    {
      'title': 'Ladakh Bike Trip',
      'description':
          'The ultimate adventure for motorcycle enthusiasts! Ride through the world\'s highest motorable passes, experience breathtaking Himalayan landscapes, and immerse yourself in Ladakhi culture. This journey will test your limits and reward you with unforgettable memories.',
      'imageUrl':
          'https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?w=600&q=80',
      'imageUrls': [
        'https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?w=600&q=80',
        'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=600&q=80',
        'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=600&q=80',
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
        'Permits & Entry Fees',
        'First Aid Kit',
      ],
      'itinerary': [
        {
          'day': 1,
          'title': 'Arrival in Leh',
          'description': 'Arrive in Leh and acclimatize to the high altitude.',
          'activities': [
            'Airport pickup',
            'Hotel check-in',
            'Rest and acclimatization',
            'Evening briefing'
          ],
          'meals': 'Dinner',
          'accommodation': 'Hotel in Leh',
        },
        {
          'day': 2,
          'title': 'Leh Local Sightseeing',
          'description':
              'Explore Leh city and nearby monasteries. Bike familiarization.',
          'activities': [
            'Shanti Stupa visit',
            'Leh Palace',
            'Bike allocation and test ride',
            'Market visit'
          ],
          'meals': 'Breakfast, Lunch, Dinner',
          'accommodation': 'Hotel in Leh',
        },
        {
          'day': 3,
          'title': 'Leh to Nubra Valley',
          'description':
              'Ride over Khardung La (18,380 ft), one of the highest motorable passes.',
          'activities': [
            'Early morning start',
            'Khardung La crossing',
            'Ride to Nubra Valley',
            'Camel safari at Hunder'
          ],
          'meals': 'Breakfast, Lunch, Dinner',
          'accommodation': 'Camp in Nubra',
        },
        {
          'day': 4,
          'title': 'Nubra to Pangong Lake',
          'description':
              'Ride through stunning landscapes to the famous Pangong Lake.',
          'activities': [
            'Scenic ride',
            'Shyok River route',
            'Pangong Lake arrival',
            'Lakeside camping'
          ],
          'meals': 'Breakfast, Lunch, Dinner',
          'accommodation': 'Camp at Pangong',
        },
        {
          'day': 5,
          'title': 'Pangong to Leh',
          'description':
              'Return journey via Chang La pass with stops at scenic points.',
          'activities': [
            'Sunrise at Pangong',
            'Chang La crossing',
            'Thiksey Monastery',
            'Return to Leh'
          ],
          'meals': 'Breakfast, Lunch, Dinner',
          'accommodation': 'Hotel in Leh',
        },
        {
          'day': 6,
          'title': 'Departure',
          'description': 'Bike return and airport transfer.',
          'activities': [
            'Bike return',
            'Certificate distribution',
            'Airport transfer'
          ],
          'meals': 'Breakfast',
          'accommodation': null,
        },
      ],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    },

    // Trip 3: Goa Party Week
    {
      'title': 'Goa Party Week',
      'description':
          'Experience the ultimate beach party destination! Dance at the best clubs, relax on pristine beaches, enjoy water sports, and make lifelong friends. This trip is perfect for solo travelers looking to have the time of their lives.',
      'imageUrl':
          'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=600&q=80',
      'imageUrls': [
        'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=600&q=80',
        'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=600&q=80',
        'https://images.unsplash.com/photo-1506929562872-bb421503ef21?w=600&q=80',
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
        'Beach Parties',
        'DJ Nights',
        'Airport Transfers',
      ],
      'itinerary': [
        {
          'day': 1,
          'title': 'Arrival & Beach Welcome',
          'description':
              'Arrive in Goa and head straight to the beach for a welcome party.',
          'activities': [
            'Airport pickup',
            'Resort check-in',
            'Beach welcome party',
            'Bonfire night'
          ],
          'meals': 'Dinner',
          'accommodation': 'Beach Resort',
        },
        {
          'day': 2,
          'title': 'Water Sports & Club Night',
          'description':
              'Morning water sports followed by exploring beaches and clubbing at night.',
          'activities': [
            'Parasailing',
            'Jet skiing',
            'Banana boat ride',
            'Beach hopping',
            'Club Cubana night'
          ],
          'meals': 'Breakfast',
          'accommodation': 'Beach Resort',
        },
        {
          'day': 3,
          'title': 'Beach Day & Sunset Cruise',
          'description':
              'Relax at the beach, enjoy sunset cruise, and party at Tito\'s.',
          'activities': [
            'Beach relaxation',
            'Lunch at beach shack',
            'Sunset cruise',
            'Tito\'s party night'
          ],
          'meals': 'Breakfast',
          'accommodation': 'Beach Resort',
        },
        {
          'day': 4,
          'title': 'Departure',
          'description': 'Final beach morning and departure.',
          'activities': [
            'Beach breakfast',
            'Check-out',
            'Shopping at Anjuna',
            'Airport transfer'
          ],
          'meals': 'Breakfast',
          'accommodation': null,
        },
      ],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    },

    // Trip 4: Kerala Backwaters
    {
      'title': 'Kerala Backwaters',
      'description':
          'Discover God\'s Own Country through its serene backwaters, lush greenery, and rich culture. Stay in traditional houseboats, experience Ayurvedic treatments, and explore spice plantations in this relaxing journey.',
      'imageUrl':
          'https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?w=600&q=80',
      'imageUrls': [
        'https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?w=600&q=80',
        'https://images.unsplash.com/photo-1593693397690-362cb9666fc2?w=600&q=80',
        'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=600&q=80',
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
        'Spice Plantation Tour',
        'Kathakali Performance',
        'All Transfers',
      ],
      'itinerary': [
        {
          'day': 1,
          'title': 'Arrival in Kochi',
          'description':
              'Arrive in Kochi and explore the historic Fort Kochi area.',
          'activities': [
            'Airport pickup',
            'Fort Kochi tour',
            'Chinese fishing nets',
            'Kathakali performance'
          ],
          'meals': 'Dinner',
          'accommodation': 'Hotel in Kochi',
        },
        {
          'day': 2,
          'title': 'Kochi to Alleppey Houseboat',
          'description':
              'Transfer to Alleppey and board traditional houseboat for backwater cruise.',
          'activities': [
            'Drive to Alleppey',
            'Houseboat boarding',
            'Backwater cruise',
            'Village visits'
          ],
          'meals': 'Breakfast, Lunch, Dinner',
          'accommodation': 'Houseboat',
        },
        {
          'day': 3,
          'title': 'Houseboat to Thekkady',
          'description':
              'Continue houseboat journey, then transfer to Thekkady for spice plantations.',
          'activities': [
            'Morning cruise',
            'Drive to Thekkady',
            'Spice plantation tour',
            'Ayurvedic massage'
          ],
          'meals': 'Breakfast, Lunch, Dinner',
          'accommodation': 'Resort in Thekkady',
        },
        {
          'day': 4,
          'title': 'Thekkady Exploration',
          'description':
              'Explore Periyar Wildlife Sanctuary and enjoy nature walks.',
          'activities': [
            'Periyar Lake boat ride',
            'Wildlife spotting',
            'Bamboo rafting',
            'Tribal village visit'
          ],
          'meals': 'Breakfast, Lunch, Dinner',
          'accommodation': 'Resort in Thekkady',
        },
        {
          'day': 5,
          'title': 'Departure',
          'description': 'Return to Kochi for departure.',
          'activities': [
            'Drive to Kochi',
            'Shopping time',
            'Airport transfer'
          ],
          'meals': 'Breakfast',
          'accommodation': null,
        },
      ],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    },
  ];

  // Add trips to Firestore
  for (var i = 0; i < sampleTrips.length; i++) {
    final tripData = sampleTrips[i];
    try {
      await tripsCollection.add(tripData);
      print('✅ Added trip ${i + 1}/${sampleTrips.length}: ${tripData['title']}');
    } catch (e) {
      print('❌ Failed to add trip ${tripData['title']}: $e');
    }
  }

  print('🎉 Seeding complete! Added ${sampleTrips.length} trips.');
}

// Run this script
void main() async {
  await seedTrips();
}
