# How to Seed Firebase Data

## Quick Start

1. **Navigate to the seed screen** in your running app:
   - In your browser or emulator, go to: `http://localhost:PORT/seed-trips`
   - Or manually navigate by changing the URL

2. **Click the "Seed Trips to Firebase" button**
   - This will automatically add:
     - ✅ 4 Agencies (Wanderlust Travels, Mountain Riders, Beach Vibes, Kerala Explorers)
     - ✅ 4 Trips (Bali, Ladakh, Goa, Kerala)

3. **Wait for completion**
   - You'll see real-time progress
   - Takes about 5-10 seconds total

4. **Done!**
   - Your Firebase now has sample data
   - Home screen will load trips from Firebase
   - You can browse agencies and their trips

---

## What Gets Added

### Agencies (4 total):
1. **Wanderlust Travels** - Spiritual & Wellness journeys
   - 8 years experience
   - ₹42L revenue
   - 45 trips

2. **Mountain Riders** - Himalayan adventures
   - 6 years experience
   - ₹18L revenue
   - 22 trips

3. **Beach Vibes** - Beach parties & water sports
   - 5 years experience
   - ₹35L revenue
   - 68 trips

4. **Kerala Explorers** - Authentic Kerala experiences
   - 10 years experience
   - ₹21L revenue
   - 35 trips

### Trips (4 total):
1. **Bali Spiritual Awakening** - 7 days, ₹45,000 (Featured & Trending)
2. **Ladakh Bike Trip** - 6 days, ₹22,000 (Trending)
3. **Goa Party Week** - 4 days, ₹15,000 (Trending)
4. **Kerala Backwaters** - 5 days, ₹28,000

All trips include:
- Full itineraries
- Inclusions list
- Agency information
- Images
- Ratings & reviews

---

## Next Steps After Seeding

1. **Home Screen** will automatically load trips from Firebase
2. **Explore Screen** can filter and search trips
3. **Agency Profiles** will show agency details and all their trips
4. **Trip Detail** pages will have complete information

---

## Troubleshooting

**If seeding fails:**
- Check Firebase console for any security rules blocking writes
- Ensure you're connected to the internet
- Check the error message in the seed screen logs

**To re-seed:**
- Delete the collections from Firebase Console first
- Then run the seed screen again

**Firebase Console:**
- https://console.firebase.google.com/
- Project: solegoes-8110c
- Firestore Database → Collections
