# Explore Page & Agency Profile - Implementation Plan

## 📋 Overview
Based on the HTML designs (`option15_explore.html`, `option15_agency_dashboard.html`) and existing codebase analysis, this document outlines the implementation plan for:
1. **Explore Page** - Discovery and search functionality
2. **Agency Profile Page** - Public-facing agency information and their trips

---

## 🎨 Design Analysis

### **Explore Page Design (`option15_explore.html`)**

#### UI Components:
1. **Header**
   - Title: "Explore"
   - Map icon button (future: map view toggle)

2. **Search Bar**
   - Placeholder: "Search destinations, trips..."
   - Search icon
   - Full-width input field

3. **Category Grid** (2x2)
   - Beach (24 trips) - Blue theme
   - Mountain (18 trips) - Green theme
   - City (12 trips) - Purple theme
   - Adventure (30 trips) - Orange theme
   - Each with icon, name, trip count

4. **Trending Destinations**
   - Large image cards
   - Destination name
   - Starting price
   - Hover scale effect
   - Links to trip detail

5. **Bottom Navigation**
   - Home, Explore (active), Create, Chat, Profile

---

### **Agency Dashboard Design (`option15_agency_dashboard.html`)**

#### UI Components:
1. **Header**
   - Agency avatar (gradient circle with initials)
   - Agency name
   - "Verified Partner" badge (green dot + text)
   - Settings button

2. **Stats Grid** (2 columns)
   - Total Revenue (₹4.2L, +12% trend)
   - Active Bookings (28 across 3 trips)

3. **Quick Actions** (2 buttons)
   - Add New Trip
   - Manage Leads

4. **My Trips List**
   - Filter dropdown (All Status, Live, Pending)
   - Trip cards with:
     - Thumbnail image
     - Trip name
     - Status badge (Live/Pending/Rejected)
     - Date range
     - Booking progress (12/15 Booked)
     - Progress bar
     - Additional info based on status

5. **Floating Action Button**
   - Add new trip (purple gradient)

---

## 🗂️ Data Model Analysis

### **Existing Models**

#### **Trip Model** (`lib/src/features/trips/domain/trip.dart`)
```dart
class Trip {
  final String tripId;
  final String title;
  final String location;
  final String imageUrl;
  final List<String> imageUrls;
  final double price;
  final int duration;
  final String agencyId;      // ✅ Already exists
  final String agencyName;    // ✅ Already exists
  final bool isTrending;
  final bool isFeatured;
  final List<TripStyle> pricingStyles;
  // ... other fields
}
```

#### **Existing Repository Methods**
```dart
// ✅ Already implemented
Future<List<Trip>> getTripsByAgency(String agencyId)

// ✅ Already implemented
Future<List<Trip>> getFeaturedTrips()
Future<List<Trip>> getTrendingTrips()
```

### **Missing Models - Need to Create**

#### **Agency Model** (NEW)
```dart
class Agency {
  final String agencyId;
  final String businessName;
  final String email;
  final String phone;
  final String description;
  final String logoUrl;
  final String coverImageUrl;
  final bool isVerified;
  final double rating;
  final int totalTrips;
  final int totalBookings;
  final DateTime createdAt;
  final List<String> specialties; // e.g., ["Adventure", "Spiritual"]
  final AgencyStats stats;
}

class AgencyStats {
  final double totalRevenue;
  final int activeBookings;
  final int completedTrips;
  final double averageRating;
  final int totalReviews;
}
```

#### **Category Model** (NEW)
```dart
class TripCategory {
  final String categoryId;
  final String name;
  final String icon; // Lucide icon name
  final String color; // Hex color
  final int tripCount;
}
```

---

## 🏗️ Implementation Plan

### **Phase 1: Data Layer** (Priority: HIGH)

#### 1.1 Create Agency Domain Model
**File:** `lib/src/features/agencies/domain/agency.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'agency.freezed.dart';
part 'agency.g.dart';

@freezed
class Agency with _$Agency {
  const factory Agency({
    required String agencyId,
    required String businessName,
    required String email,
    required String phone,
    required String description,
    required String logoUrl,
    required String coverImageUrl,
    required bool isVerified,
    required double rating,
    required int totalTrips,
    required int totalBookings,
    required DateTime createdAt,
    required List<String> specialties,
    required AgencyStats stats,
  }) = _Agency;

  factory Agency.fromJson(Map<String, dynamic> json) => _$AgencyFromJson(json);
}

@freezed
class AgencyStats with _$AgencyStats {
  const factory AgencyStats({
    required double totalRevenue,
    required int activeBookings,
    required int completedTrips,
    required double averageRating,
    required int totalReviews,
  }) = _AgencyStats;

  factory AgencyStats.fromJson(Map<String, dynamic> json) => 
      _$AgencyStatsFromJson(json);
}
```

#### 1.2 Create Agency Repository
**File:** `lib/src/features/agencies/data/agency_repository.dart`

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/agency.dart';

part 'agency_repository.g.dart';

class AgencyRepository {
  final FirebaseFirestore _firestore;

  AgencyRepository(this._firestore);

  // Get agency by ID
  Future<Agency?> getAgencyById(String agencyId) async {
    try {
      final doc = await _firestore.collection('agencies').doc(agencyId).get();
      if (!doc.exists) return null;
      return Agency.fromJson({'agencyId': doc.id, ...doc.data()!});
    } catch (e) {
      throw Exception('Failed to fetch agency: $e');
    }
  }

  // Get all verified agencies
  Future<List<Agency>> getVerifiedAgencies() async {
    try {
      final snapshot = await _firestore
          .collection('agencies')
          .where('isVerified', isEqualTo: true)
          .orderBy('rating', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Agency.fromJson({'agencyId': doc.id, ...doc.data()}))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch agencies: $e');
    }
  }

  // Search agencies
  Future<List<Agency>> searchAgencies(String query) async {
    try {
      final snapshot = await _firestore
          .collection('agencies')
          .where('businessName', isGreaterThanOrEqualTo: query)
          .where('businessName', isLessThanOrEqualTo: '$query\uf8ff')
          .limit(20)
          .get();

      return snapshot.docs
          .map((doc) => Agency.fromJson({'agencyId': doc.id, ...doc.data()}))
          .toList();
    } catch (e) {
      throw Exception('Failed to search agencies: $e');
    }
  }
}

@riverpod
AgencyRepository agencyRepository(AgencyRepositoryRef ref) {
  return AgencyRepository(FirebaseFirestore.instance);
}

@riverpod
Future<Agency?> agencyById(AgencyByIdRef ref, String agencyId) {
  return ref.watch(agencyRepositoryProvider).getAgencyById(agencyId);
}

@riverpod
Future<List<Agency>> verifiedAgencies(VerifiedAgenciesRef ref) {
  return ref.watch(agencyRepositoryProvider).getVerifiedAgencies();
}
```

#### 1.3 Create Category Model
**File:** `lib/src/features/explore/domain/trip_category.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'trip_category.freezed.dart';

@freezed
class TripCategory with _$TripCategory {
  const factory TripCategory({
    required String categoryId,
    required String name,
    required String iconName, // Lucide icon name
    required String color,
    required int tripCount,
  }) = _TripCategory;
}

// Predefined categories (can be moved to constants)
class TripCategories {
  static const List<TripCategory> all = [
    TripCategory(
      categoryId: 'beach',
      name: 'Beach',
      iconName: 'waves',
      color: '0xFF3B82F6', // Blue
      tripCount: 0, // Will be calculated
    ),
    TripCategory(
      categoryId: 'mountain',
      name: 'Mountain',
      iconName: 'mountain',
      color: '0xFF22C55E', // Green
      tripCount: 0,
    ),
    TripCategory(
      categoryId: 'city',
      name: 'City',
      iconName: 'building-2',
      color: '0xFFA855F7', // Purple
      tripCount: 0,
    ),
    TripCategory(
      categoryId: 'adventure',
      name: 'Adventure',
      iconName: 'compass',
      color: '0xFFF97316', // Orange
      tripCount: 0,
    ),
  ];
}
```

---

### **Phase 2: Explore Page** (Priority: HIGH)

#### 2.1 Create Explore Screen
**File:** `lib/src/features/explore/presentation/explore_screen.dart`

**Features:**
- ✅ Search bar with debouncing
- ✅ Category grid (2x2)
- ✅ Trending destinations
- ✅ Filter by category
- ✅ Search functionality
- ✅ Pull-to-refresh

**UI Structure:**
```dart
class ExploreScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header
          _buildHeader(),
          
          // Search Bar
          _buildSearchBar(),
          
          // Categories Grid
          _buildCategoriesGrid(),
          
          // Trending Section
          _buildTrendingSection(),
        ],
      ),
    );
  }

  Widget _buildCategoriesGrid() {
    return SliverPadding(
      padding: EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final category = TripCategories.all[index];
            return _buildCategoryCard(category);
          },
          childCount: TripCategories.all.length,
        ),
      ),
    );
  }

  Widget _buildCategoryCard(TripCategory category) {
    final isSelected = _selectedCategory == category.categoryId;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = isSelected ? null : category.categoryId;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected 
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected 
                ? Color(int.parse(category.color))
                : AppColors.borderGlass,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Color(int.parse(category.color)).withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                // Use Lucide icon based on category.iconName
                LucideIcons.waves, // Dynamic based on iconName
                color: Color(int.parse(category.color)),
              ),
            ),
            SizedBox(height: 8),
            Text(
              category.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              '${category.tripCount} Trips',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendingSection() {
    final tripsAsync = ref.watch(trendingTripsProvider);

    return tripsAsync.when(
      data: (trips) => SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final trip = trips[index];
            return _buildTrendingCard(trip);
          },
          childCount: trips.length,
        ),
      ),
      loading: () => SliverToBoxAdapter(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => SliverToBoxAdapter(
        child: Text('Error: $error'),
      ),
    );
  }
}
```

#### 2.2 Add Search Functionality
**File:** `lib/src/features/explore/data/search_repository.dart`

```dart
class SearchRepository {
  final FirebaseFirestore _firestore;

  SearchRepository(this._firestore);

  Future<List<Trip>> searchTrips(String query) async {
    try {
      // Search by title, location, or tags
      final snapshot = await _firestore
          .collection('trips')
          .where('searchKeywords', arrayContains: query.toLowerCase())
          .limit(20)
          .get();

      return snapshot.docs
          .map((doc) => Trip.fromJson({'tripId': doc.id, ...doc.data()}))
          .toList();
    } catch (e) {
      throw Exception('Failed to search trips: $e');
    }
  }

  Future<List<Trip>> getTripsByCategory(String category) async {
    try {
      final snapshot = await _firestore
          .collection('trips')
          .where('category', isEqualTo: category)
          .orderBy('isTrending', descending: true)
          .limit(50)
          .get();

      return snapshot.docs
          .map((doc) => Trip.fromJson({'tripId': doc.id, ...doc.data()}))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch trips by category: $e');
    }
  }
}
```

---

### **Phase 3: Agency Profile Page** (Priority: MEDIUM)

#### 3.1 Create Agency Profile Screen
**File:** `lib/src/features/agencies/presentation/agency_profile_screen.dart`

**Features:**
- ✅ Agency header with logo, name, verified badge
- ✅ Cover image
- ✅ Stats display (rating, trips, bookings)
- ✅ About section
- ✅ Specialties chips
- ✅ Trips list from this agency
- ✅ Contact button
- ✅ Share button

**UI Structure:**
```dart
class AgencyProfileScreen extends ConsumerWidget {
  final String agencyId;

  const AgencyProfileScreen({required this.agencyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agencyAsync = ref.watch(agencyByIdProvider(agencyId));
    final tripsAsync = ref.watch(tripsByAgencyProvider(agencyId));

    return Scaffold(
      body: agencyAsync.when(
        data: (agency) => _buildContent(context, ref, agency, tripsAsync),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    Agency? agency,
    AsyncValue<List<Trip>> tripsAsync,
  ) {
    if (agency == null) {
      return Center(child: Text('Agency not found'));
    }

    return CustomScrollView(
      slivers: [
        // Cover Image + Header
        _buildHeroHeader(agency),
        
        // Agency Info Card
        _buildAgencyInfo(agency),
        
        // Stats Grid
        _buildStatsGrid(agency),
        
        // About Section
        _buildAboutSection(agency),
        
        // Specialties
        _buildSpecialties(agency),
        
        // Trips Section
        _buildTripsSection(tripsAsync),
      ],
    );
  }

  Widget _buildHeroHeader(Agency agency) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Cover Image
            Image.network(
              agency.coverImageUrl,
              fit: BoxFit.cover,
            ),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
            // Agency Logo + Name
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Row(
                children: [
                  // Logo
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      image: DecorationImage(
                        image: NetworkImage(agency.logoUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  // Name + Badge
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          agency.businessName,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        if (agency.isVerified)
                          Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Color(0xFF22C55E),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Verified Partner',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF22C55E),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(Agency agency) {
    return SliverPadding(
      padding: EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
        ),
        delegate: SliverChildListDelegate([
          _buildStatCard(
            icon: LucideIcons.star,
            value: agency.rating.toStringAsFixed(1),
            label: 'Rating',
            color: Color(0xFFFBBF24),
          ),
          _buildStatCard(
            icon: LucideIcons.mapPin,
            value: '${agency.totalTrips}',
            label: 'Trips',
            color: Color(0xFF3B82F6),
          ),
          _buildStatCard(
            icon: LucideIcons.users,
            value: '${agency.totalBookings}',
            label: 'Bookings',
            color: Color(0xFF8B5CF6),
          ),
          _buildStatCard(
            icon: LucideIcons.messageCircle,
            value: '${agency.stats.totalReviews}',
            label: 'Reviews',
            color: Color(0xFF10B981),
          ),
        ]),
      ),
    );
  }
}
```

#### 3.2 Add to Routing
**File:** `lib/src/routing/app_router.dart`

```dart
enum AppRoute {
  // ... existing routes
  explore,
  agencyProfile,
}

// Add routes
GoRoute(
  path: '/explore',
  name: AppRoute.explore.name,
  builder: (context, state) => const ExploreScreen(),
),
GoRoute(
  path: '/agency/:agencyId',
  name: AppRoute.agencyProfile.name,
  builder: (context, state) {
    final agencyId = state.pathParameters['agencyId']!;
    return AgencyProfileScreen(agencyId: agencyId);
  },
),
```

---

### **Phase 4: Navigation Integration** (Priority: HIGH)

#### 4.1 Update Bottom Navigation
**File:** `lib/src/features/home/presentation/main_scaffold.dart`

Add Explore tab to bottom navigation:
```dart
BottomNavigationBarItem(
  icon: Icon(LucideIcons.compass),
  label: 'Explore',
),
```

#### 4.2 Link Agency from Trip Detail
In `trip_detail_screen.dart`, make agency name clickable:
```dart
GestureDetector(
  onTap: () {
    context.push('/agency/${trip.agencyId}');
  },
  child: Row(
    children: [
      Text(trip.agencyName),
      Icon(LucideIcons.chevronRight, size: 16),
    ],
  ),
),
```

---

### **Phase 5: Search & Filters** (Priority: MEDIUM)

#### 5.1 Advanced Search
**Features:**
- Search by destination
- Search by agency
- Price range filter
- Duration filter
- Date range filter
- Sort options (price, rating, popularity)

#### 5.2 Filter Bottom Sheet
Create reusable filter component:
```dart
class FilterBottomSheet extends StatefulWidget {
  final FilterOptions currentFilters;
  final Function(FilterOptions) onApply;
}
```

---

## 📊 Database Schema Updates

### **Firestore Collections**

#### **agencies** (NEW)
```json
{
  "agencyId": "wanderlust-travels",
  "businessName": "Wanderlust Travels",
  "email": "contact@wanderlust.com",
  "phone": "+91 98765 43210",
  "description": "Leading travel agency...",
  "logoUrl": "https://...",
  "coverImageUrl": "https://...",
  "isVerified": true,
  "rating": 4.8,
  "totalTrips": 12,
  "totalBookings": 245,
  "createdAt": "2024-01-01T00:00:00Z",
  "specialties": ["Spiritual", "Wellness", "Adventure"],
  "stats": {
    "totalRevenue": 420000,
    "activeBookings": 28,
    "completedTrips": 156,
    "averageRating": 4.8,
    "totalReviews": 89
  }
}
```

#### **trips** (UPDATE - Add fields)
```json
{
  // ... existing fields
  "category": "beach", // NEW: for filtering
  "searchKeywords": ["bali", "spiritual", "beach"], // NEW: for search
  "tags": ["yoga", "meditation", "wellness"] // NEW: for filtering
}
```

---

## 🎯 Success Metrics

### **Explore Page**
- [ ] Users can search trips by keyword
- [ ] Users can filter by category
- [ ] Category cards show accurate trip counts
- [ ] Trending section loads correctly
- [ ] Search is debounced (no lag)
- [ ] Pull-to-refresh works

### **Agency Profile**
- [ ] Agency info displays correctly
- [ ] Stats are accurate
- [ ] Trips from agency load
- [ ] Verified badge shows for verified agencies
- [ ] Contact button works
- [ ] Share functionality works

---

## 🚀 Implementation Timeline

### **Week 1: Foundation**
- Day 1-2: Create Agency model & repository
- Day 3-4: Create Category model & constants
- Day 5: Set up routing

### **Week 2: Explore Page**
- Day 1-2: Build Explore screen UI
- Day 3: Implement search functionality
- Day 4: Implement category filtering
- Day 5: Testing & polish

### **Week 3: Agency Profile**
- Day 1-2: Build Agency Profile screen
- Day 3: Integrate with trips
- Day 4: Add contact/share features
- Day 5: Testing & polish

### **Week 4: Polish & Testing**
- Day 1-2: Advanced filters
- Day 3: Performance optimization
- Day 4-5: End-to-end testing

---

## 🔧 Technical Considerations

### **Performance**
- ✅ Use pagination for trip lists (20 items per page)
- ✅ Cache agency data locally
- ✅ Debounce search input (300ms)
- ✅ Lazy load images
- ✅ Use `cached_network_image` for agency logos

### **Offline Support**
- ✅ Cache last search results
- ✅ Show cached agencies when offline
- ✅ Display offline indicator

### **Error Handling**
- ✅ Handle empty search results
- ✅ Handle agency not found
- ✅ Handle network errors
- ✅ Show retry options

---

## 📝 Next Steps

1. **Review this plan** - Confirm approach
2. **Create Agency model** - Start with data layer
3. **Build Explore screen** - UI first
4. **Implement search** - Add functionality
5. **Build Agency Profile** - Complete the flow
6. **Test end-to-end** - Ensure everything works

---

## 🎨 Design Tokens

### **Category Colors**
```dart
class CategoryColors {
  static const beach = Color(0xFF3B82F6);     // Blue
  static const mountain = Color(0xFF22C55E);  // Green
  static const city = Color(0xFFA855F7);      // Purple
  static const adventure = Color(0xFFF97316); // Orange
}
```

### **Agency Badge Colors**
```dart
class AgencyBadgeColors {
  static const verified = Color(0xFF22C55E);   // Green
  static const pending = Color(0xFFFBBF24);    // Yellow
  static const premium = Color(0xFF8B5CF6);    // Purple
}
```

---

**Ready to start implementation?** Let me know which phase you'd like to tackle first! 🚀
