# Firebase Setup - Add Sample Trips

## Quick Setup Instructions

Since the seed script has compilation issues, let's add trips manually to Firebase Console:

### Step 1: Open Firebase Console
1. Go to https://console.firebase.google.com/
2. Select your project: `solegoes-8110c`
3. Click on "Firestore Database" in the left menu
4. Click "Start collection"

### Step 2: Create "trips" Collection
Collection ID: `trips`

### Step 3: Add Sample Trips

Copy and paste these documents one by one:

---

#### Trip 1: Bali Spiritual Awakening
**Document ID**: Auto-generate or use `bali-spiritual-001`

```json
{
  "title": "Bali Spiritual\nAwakening",
  "description": "Embark on a transformative journey through Bali's spiritual heart. Experience ancient temples, yoga sessions at sunrise, traditional healing ceremonies, and meditation in lush rice terraces.",
  "imageUrl": "https://images.unsplash.com/photo-1537996194471-e657df975ab4?w=800&q=80",
  "imageUrls": [
    "https://images.unsplash.com/photo-1537996194471-e657df975ab4?w=800&q=80",
    "https://images.unsplash.com/photo-1555400038-63f5ba517a47?w=800&q=80"
  ],
  "location": "Ubud, Bali",
  "duration": 7,
  "price": 45000,
  "categories": ["Wellness", "Spiritual", "Culture"],
  "groupSize": "Group of 12",
  "rating": 4.9,
  "reviewCount": 156,
  "agencyId": "wanderlust-travels",
  "agencyName": "Wanderlust Travels",
  "isVerifiedAgency": true,
  "status": "live",
  "isTrending": true,
  "isFeatured": true,
  "inclusions": [
    "Resort Stay (6 nights)",
    "All Meals",
    "Daily Yoga Sessions",
    "Temple Visits",
    "Airport Transfers"
  ],
  "itinerary": [
    {
      "day": 1,
      "title": "Arrival & Welcome",
      "description": "Arrive in Bali and transfer to resort",
      "activities": ["Airport pickup", "Check-in", "Welcome ceremony"]
    },
    {
      "day": 2,
      "title": "Temple Tour",
      "description": "Visit ancient temples",
      "activities": ["Sunrise yoga", "Temple visit", "Rice terraces"]
    }
  ],
  "createdAt": "2026-01-10T12:00:00Z",
  "updatedAt": "2026-01-10T12:00:00Z"
}
```

---

#### Trip 2: Ladakh Bike Trip
**Document ID**: Auto-generate or use `ladakh-bike-001`

```json
{
  "title": "Ladakh Bike Trip",
  "description": "The ultimate adventure for motorcycle enthusiasts! Ride through the world's highest motorable passes and experience breathtaking Himalayan landscapes.",
  "imageUrl": "https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?w=600&q=80",
  "imageUrls": [
    "https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?w=600&q=80"
  ],
  "location": "Leh, Ladakh",
  "duration": 6,
  "price": 22000,
  "categories": ["Adventure", "Mountain", "Biking"],
  "groupSize": "Group of 12",
  "rating": 4.9,
  "reviewCount": 203,
  "agencyId": "mountain-riders",
  "agencyName": "Mountain Riders",
  "isVerifiedAgency": true,
  "status": "live",
  "isTrending": true,
  "isFeatured": false,
  "inclusions": [
    "Royal Enfield 350cc",
    "Accommodation (5 nights)",
    "All Meals",
    "Experienced Ride Captain"
  ],
  "itinerary": [
    {
      "day": 1,
      "title": "Arrival in Leh",
      "description": "Acclimatize to high altitude",
      "activities": ["Airport pickup", "Rest", "Briefing"]
    }
  ],
  "createdAt": "2026-01-10T12:00:00Z",
  "updatedAt": "2026-01-10T12:00:00Z"
}
```

---

#### Trip 3: Goa Party Week
**Document ID**: Auto-generate or use `goa-party-001`

```json
{
  "title": "Goa Party Week",
  "description": "Experience the ultimate beach party destination! Dance at the best clubs, relax on pristine beaches, and make lifelong friends.",
  "imageUrl": "https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=600&q=80",
  "imageUrls": [
    "https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=600&q=80"
  ],
  "location": "North Goa",
  "duration": 4,
  "price": 15000,
  "categories": ["Beach", "Party", "Adventure"],
  "groupSize": "Group of 20",
  "rating": 4.7,
  "reviewCount": 342,
  "agencyId": "beach-vibes",
  "agencyName": "Beach Vibes",
  "isVerifiedAgency": true,
  "status": "live",
  "isTrending": true,
  "isFeatured": false,
  "inclusions": [
    "Beach Resort Stay (3 nights)",
    "Breakfast Daily",
    "Club Entry Passes",
    "Water Sports Package"
  ],
  "itinerary": [
    {
      "day": 1,
      "title": "Arrival & Beach Welcome",
      "description": "Welcome party at the beach",
      "activities": ["Airport pickup", "Check-in", "Beach party"]
    }
  ],
  "createdAt": "2026-01-10T12:00:00Z",
  "updatedAt": "2026-01-10T12:00:00Z"
}
```

---

#### Trip 4: Kerala Backwaters
**Document ID**: Auto-generate or use `kerala-001`

```json
{
  "title": "Kerala Backwaters",
  "description": "Discover God's Own Country through its serene backwaters, lush greenery, and rich culture. Stay in traditional houseboats.",
  "imageUrl": "https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?w=600&q=80",
  "imageUrls": [
    "https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?w=600&q=80"
  ],
  "location": "Alleppey, Kerala",
  "duration": 5,
  "price": 28000,
  "categories": ["Relaxation", "Nature", "Culture"],
  "groupSize": "Group of 8",
  "rating": 4.8,
  "reviewCount": 178,
  "agencyId": "kerala-explorers",
  "agencyName": "Kerala Explorers",
  "isVerifiedAgency": true,
  "status": "live",
  "isTrending": false,
  "isFeatured": false,
  "inclusions": [
    "Houseboat Stay (2 nights)",
    "Resort Stay (2 nights)",
    "All Meals",
    "Ayurvedic Massage"
  ],
  "itinerary": [
    {
      "day": 1,
      "title": "Arrival in Kochi",
      "description": "Explore Fort Kochi",
      "activities": ["Airport pickup", "Fort Kochi tour"]
    }
  ],
  "createdAt": "2026-01-10T12:00:00Z",
  "updatedAt": "2026-01-10T12:00:00Z"
}
```

---

## Next Steps

After adding these trips to Firestore:

1. The home screen will automatically load them
2. You can click on any trip to see details
3. The trip repository is already set up to fetch from Firebase

## Firestore Indexes

You may need to create composite indexes for queries. Firebase will prompt you with a link when you first run queries.

Required indexes:
- Collection: `trips`, Fields: `status` (Ascending), `createdAt` (Descending)
- Collection: `trips`, Fields: `status` (Ascending), `isFeatured` (Ascending), `createdAt` (Descending)
- Collection: `trips`, Fields: `status` (Ascending), `isTrending` (Ascending), `rating` (Descending)
