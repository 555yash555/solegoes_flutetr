# Trip Discovery & Search Implementation Plan

## Overview
SoleGoes uses a multi-layered trip discovery system combining traditional search, filters, AI-powered recommendations (Vector Search), and agency-specific trip browsing.

---

## 🎯 Core Features

### 1. **Search & Filters**
Users can search and filter trips by:
- **Text Search**: Trip title, location, description
- **Categories**: Beach, Mountain, Adventure, City Break, Wellness, etc.
- **Price Range**: Under ₹10k, ₹10k-25k, ₹25k+
- **Duration**: Weekend (2-3 days), Week (4-7 days), Extended (8+ days)
- **Group Size**: Solo-friendly, Small groups, Large groups
- **Travel Style**: Backpacker, Luxury, Eco-friendly
- **Dates**: Specific date ranges
- **Location**: By city/region

### 2. **AI-Powered Recommendations (Vector Search)**
- Uses Firestore Vector Search with 768-dimensional embeddings
- Matches user preferences to trip characteristics
- Based on:
  - User's `interest_embedding` (from profile)
  - Trip's `embedding_vector` (generated from trip details)
  - User's `travelStyle`, `budgetRange`, `interests_raw`

### 3. **Agency-Specific Browsing**
- View all trips from a specific agency
- Agency profile page with:
  - Business info (name, verification status, years of experience)
  - Stats (total trips, average rating, active bookings)
  - Portfolio photos
  - All live trips from that agency

### 4. **Trip Status System**
Trips have different statuses:
- `pending_approval`: Submitted by agency, awaiting admin approval
- `live`: Approved and visible to customers
- `rejected`: Rejected by admin (with reason)
- `completed`: Trip has finished

**Only `live` trips are shown to customers**

---

## 📊 Data Flow

### Trip Discovery Flow:
```
User Opens App
    ↓
Home Screen (Featured Trips)
    ↓
User Taps Search/Explore
    ↓
Explore Screen
    ├─→ Text Search (Firestore query)
    ├─→ Apply Filters (compound queries)
    ├─→ AI Recommendations (Vector Search)
    └─→ Browse by Category
    ↓
Trip List Results
    ↓
User Taps Trip Card
    ↓
Trip Detail Screen
    ├─→ View full itinerary
    ├─→ See agency info (tap to view agency profile)
    ├─→ Check inclusions/exclusions
    ├─→ View photos/videos
    └─→ Book trip
```

### Agency Browsing Flow:
```
User Sees Trip
    ↓
Taps "View Agency" or Agency Name
    ↓
Agency Profile Screen
    ├─→ Agency details
    ├─→ Verification badge
    ├─→ Stats (revenue, bookings)
    └─→ All trips by this agency
    ↓
User Browses Agency Trips
    ↓
Taps Trip → Trip Detail Screen
```

---

## 🗄️ Firestore Queries

### 1. **Basic Search (Text + Filters)**
```dart
// Search by title/location
Query query = FirebaseFirestore.instance
  .collection('trips')
  .where('status', isEqualTo: 'live')
  .where('title', isGreaterThanOrEqualTo: searchText)
  .where('title', isLessThanOrEqualTo: searchText + '\uf8ff');

// Filter by category
query = query.where('categories', arrayContains: selectedCategory);

// Filter by price range
query = query
  .where('price', isGreaterThanOrEqualTo: minPrice)
  .where('price', isLessThanOrEqualTo: maxPrice);

// Order by relevance/date
query = query.orderBy('createdAt', descending: true);
```

### 2. **AI Recommendations (Vector Search)**
```dart
// Firestore Vector Search (requires Firestore Vector Search extension)
final userEmbedding = await getUserInterestEmbedding(userId);

final results = await FirebaseFirestore.instance
  .collection('trips')
  .where('status', isEqualTo: 'live')
  .findNearest(
    vectorField: 'embedding_vector',
    queryVector: userEmbedding,
    limit: 20,
    distanceMeasure: DistanceMeasure.COSINE,
  );
```

### 3. **Agency-Specific Trips**
```dart
// Get all trips by agency
Query query = FirebaseFirestore.instance
  .collection('trips')
  .where('agencyId', isEqualTo: agencyId)
  .where('status', isEqualTo: 'live')
  .orderBy('createdAt', descending: true);
```

### 4. **Trending/Popular Trips**
```dart
// Get trending trips (most bookings in last 30 days)
Query query = FirebaseFirestore.instance
  .collection('trips')
  .where('status', isEqualTo: 'live')
  .where('isTrending', isEqualTo: true)
  .orderBy('bookingCount', descending: true)
  .limit(10);
```

---

## 🏗️ Implementation Structure

### Phase 1: Basic Trip Discovery (MVP)
**Files to Create:**
```
lib/src/features/trips/
├── domain/
│   ├── trip.dart                    # Trip model (freezed)
│   └── trip_filters.dart            # Filter model
├── data/
│   └── trip_repository.dart         # Firestore queries
└── presentation/
    ├── explore_screen.dart          # Main search/explore UI
    ├── trip_detail_screen.dart      # Trip details
    ├── widgets/
    │   ├── trip_search_bar.dart     # Search input
    │   ├── trip_filters_sheet.dart  # Filter bottom sheet
    │   └── trip_grid.dart           # Grid of trip cards
    └── providers/
        ├── trip_search_provider.dart
        └── trip_filters_provider.dart
```

**Features:**
- ✅ Text search by title/location
- ✅ Category filters
- ✅ Price range filters
- ✅ Grid/List view toggle
- ✅ Trip detail screen
- ✅ Link to agency profile

### Phase 2: Agency Features
**Files to Create:**
```
lib/src/features/agencies/
├── domain/
│   └── agency.dart                  # Agency model
├── data/
│   └── agency_repository.dart       # Agency queries
└── presentation/
    ├── agency_profile_screen.dart   # Agency details + trips
    └── widgets/
        └── agency_stats_card.dart   # Stats display
```

**Features:**
- ✅ Agency profile page
- ✅ Verification badge display
- ✅ Agency stats (revenue, bookings)
- ✅ All trips by agency
- ✅ Portfolio photos

### Phase 3: AI Recommendations (Advanced)
**Files to Create:**
```
lib/src/features/recommendations/
├── data/
│   └── embedding_service.dart       # Generate embeddings
└── presentation/
    └── recommended_trips_screen.dart
```

**Features:**
- ✅ Vector Search integration
- ✅ Personalized recommendations
- ✅ "For You" section on home
- ✅ Similar trips suggestions

---

## 🎨 UI Screens

### 1. **Explore Screen** (`explore_screen.dart`)
**Layout:**
```
┌─────────────────────────────────────┐
│ [Search Bar]              [Filter]  │
├─────────────────────────────────────┤
│ Categories: [All] [Beach] [Mountain]│
├─────────────────────────────────────┤
│ ┌──────────┐  ┌──────────┐         │
│ │  Trip 1  │  │  Trip 2  │         │
│ │  Image   │  │  Image   │         │
│ │  Title   │  │  Title   │         │
│ │  ₹Price  │  │  ₹Price  │         │
│ └──────────┘  └──────────┘         │
│ ┌──────────┐  ┌──────────┐         │
│ │  Trip 3  │  │  Trip 4  │         │
│ └──────────┘  └──────────┘         │
└─────────────────────────────────────┘
```

### 2. **Trip Detail Screen** (`trip_detail_screen.dart`)
**Layout:**
```
┌─────────────────────────────────────┐
│ [← Back]                  [♡ Save]  │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │     Hero Image Carousel         │ │
│ └─────────────────────────────────┘ │
│                                     │
│ Bali Spiritual Awakening            │
│ ⭐ 4.9 (120 reviews)                │
│                                     │
│ 📅 7 Days  📍 Ubud, Bali           │
│ 👥 Group of 12                     │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ By: Wanderlust Travels [View]   │ │
│ │ ✓ Verified Agency               │ │
│ └─────────────────────────────────┘ │
│                                     │
│ About This Trip                     │
│ [Description text...]               │
│                                     │
│ Itinerary                           │
│ Day 1: Arrival & Temple Visit      │
│ Day 2: Rice Terraces Trek          │
│ ...                                 │
│                                     │
│ Inclusions                          │
│ ✓ Resort Stay                      │
│ ✓ All Meals                        │
│ ✓ Guided Tours                     │
│                                     │
│ [Book Now - ₹45,000]               │
└─────────────────────────────────────┘
```

### 3. **Agency Profile Screen** (`agency_profile_screen.dart`)
**Layout:**
```
┌─────────────────────────────────────┐
│ [← Back]                            │
│                                     │
│ Wanderlust Travels                  │
│ ✓ Verified Agency                  │
│ ⭐ 4.8 (500+ trips)                 │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ 📊 Stats                        │ │
│ │ 150 Active Trips                │ │
│ │ ₹42L Total Revenue              │ │
│ │ 5 Years Experience              │ │
│ └─────────────────────────────────┘ │
│                                     │
│ About                               │
│ [Agency description...]             │
│                                     │
│ Portfolio                           │
│ [Photo Gallery]                     │
│                                     │
│ All Trips (150)                     │
│ ┌──────────┐  ┌──────────┐         │
│ │  Trip 1  │  │  Trip 2  │         │
│ └──────────┘  └──────────┘         │
└─────────────────────────────────────┘
```

---

## 🔄 Implementation Steps

### Step 1: Create Trip Model
```dart
@freezed
class Trip with _$Trip {
  const factory Trip({
    required String tripId,
    required String title,
    required String description,
    required String imageUrl,
    required List<String> imageUrls,
    required String location,
    required int duration,
    required double price,
    required List<String> categories,
    required String groupSize,
    required double rating,
    required int reviewCount,
    required String agencyId,
    required String agencyName,
    required bool isVerifiedAgency,
    required String status,
    required List<String> inclusions,
    required List<Map<String, dynamic>> itinerary,
    DateTime? startDate,
    DateTime? endDate,
  }) = _Trip;

  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);
}
```

### Step 2: Create Trip Repository
```dart
@riverpod
class TripRepository {
  // Search trips
  Future<List<Trip>> searchTrips(String query);
  
  // Get trip by ID
  Future<Trip> getTripById(String tripId);
  
  // Get trips by agency
  Future<List<Trip>> getTripsByAgency(String agencyId);
  
  // Get trips by category
  Future<List<Trip>> getTripsByCategory(String category);
  
  // Get trending trips
  Future<List<Trip>> getTrendingTrips();
  
  // Filter trips
  Future<List<Trip>> filterTrips(TripFilters filters);
}
```

### Step 3: Build Explore Screen
- Search bar with debouncing
- Category pills (horizontal scroll)
- Filter button (opens bottom sheet)
- Trip grid with infinite scroll
- Pull-to-refresh

### Step 4: Build Trip Detail Screen
- Image carousel
- Trip info
- Agency card (tappable → agency profile)
- Itinerary accordion
- Inclusions list
- Book button

### Step 5: Build Agency Profile Screen
- Agency header
- Stats cards
- About section
- Portfolio gallery
- Trips grid

---

## 🎯 Next Actions

**Should we start implementing?**

1. **Phase 1 (MVP)**: Basic search, filters, trip detail screen
2. **Phase 2**: Agency profiles and browsing
3. **Phase 3**: AI recommendations (Vector Search)

**Which phase would you like to start with?**
