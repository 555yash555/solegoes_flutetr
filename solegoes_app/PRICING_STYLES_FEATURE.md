# Trip Pricing Styles Feature

## Overview
We've added a flexible pricing system that allows trips to offer multiple "styles" or packages with different accommodation types and meal preferences.

## Data Model

### TripStyle Class
Located in: `lib/src/features/trips/domain/trip.dart`

```dart
class TripStyle {
  final String styleId;           // Unique identifier (e.g., 'budget', 'standard', 'premium')
  final String name;               // Display name (e.g., 'Budget Explorer')
  final String description;        // Short description
  final double price;              // Price for this style
  final String accommodationType;  // 'sharing-3', 'sharing-2', 'private'
  final List<String> mealOptions;  // ['veg', 'non-veg', 'alcohol']
  final List<String> inclusions;   // What's included in this package
}
```

### Trip Model Updates
- Added `pricingStyles` field: `List<TripStyle>`
- The base `price` field now represents the starting/minimum price

### Booking Model Updates
- Added `selectedStyleId`: Tracks which style the user chose
- Added `selectedStyleName`: For display purposes in booking history

## Pricing Tiers

### Budget Tier
- **Accommodation:** 3-person sharing
- **Meals:** Vegetarian only
- **Price Range:** ₹12,000 - ₹38,000 depending on trip

### Standard Tier
- **Accommodation:** 2-person sharing
- **Meals:** Veg & Non-veg options
- **Price Range:** ₹15,000 - ₹45,000 depending on trip

### Premium Tier
- **Accommodation:** Private room
- **Meals:** All options (veg, non-veg, alcohol)
- **Price Range:** ₹22,000 - ₹58,000 depending on trip
- **Extras:** VIP access, premium amenities

## Example: Bali Spiritual Awakening

### Budget Explorer - ₹38,000
- 3-person sharing room
- Vegetarian meals only
- Shared bathroom
- All activities included

### Standard Comfort - ₹45,000
- 2-person sharing room
- Veg & Non-veg meal options
- Attached bathroom
- All activities + welcome drink

### Premium Solo - ₹58,000
- Private room
- All meal options including alcohol
- Premium bathroom amenities
- Airport lounge access
- Priority activity booking

## Implementation Checklist

### ✅ Completed
1. Added `TripStyle` model to domain layer
2. Updated `Trip` model with `pricingStyles` field
3. Updated `Booking` model with `selectedStyleId` and `selectedStyleName`
4. Updated `BookingRepository.createBooking()` to accept style parameters
5. Added pricing styles to all 4 seed trips (Bali, Ladakh, Goa, Kerala)
6. Regenerated Freezed/JSON serialization code

### 🔄 Next Steps (To Implement)

#### 1. Trip Detail Screen UI
Create a style selector component:
```dart
// Show pricing cards
ListView.builder(
  itemCount: trip.pricingStyles.length,
  itemBuilder: (context, index) {
    final style = trip.pricingStyles[index];
    return PricingStyleCard(
      style: style,
      isSelected: selectedStyleId == style.styleId,
      onTap: () => setState(() => selectedStyleId = style.styleId),
    );
  },
)
```

#### 2. Booking Flow
Update the booking process to:
- Let user select a style before choosing boarding point
- Pass `selectedStyleId` and `selectedStyleName` to `BookingRepository.createBooking()`
- Use the style's price for payment (not the base trip price)

#### 3. Payment Integration
Update payment amount calculation:
```dart
final selectedStyle = trip.pricingStyles.firstWhere(
  (s) => s.styleId == selectedStyleId,
  orElse: () => trip.pricingStyles.first,
);
final amount = selectedStyle.price;
```

#### 4. Booking History Display
Show the selected style in "My Trips":
```dart
Text('Package: ${booking.selectedStyleName}')
Text('₹${booking.amount}')
```

## Database Structure

### Firestore: trips/{tripId}
```json
{
  "title": "Bali Spiritual Awakening",
  "price": 38000,  // Base/minimum price
  "pricingStyles": [
    {
      "styleId": "budget",
      "name": "Budget Explorer",
      "price": 38000,
      "accommodationType": "sharing-3",
      "mealOptions": ["veg"],
      "inclusions": [...]
    },
    {
      "styleId": "standard",
      "name": "Standard Comfort",
      "price": 45000,
      "accommodationType": "sharing-2",
      "mealOptions": ["veg", "non-veg"],
      "inclusions": [...]
    }
  ]
}
```

### Firestore: bookings/{bookingId}
```json
{
  "tripId": "abc123",
  "userId": "user456",
  "amount": 45000,
  "selectedStyleId": "standard",
  "selectedStyleName": "Standard Comfort",
  "selectedBoardingPoint": {...},
  "selectedDroppingPoint": {...}
}
```

## UI/UX Recommendations

1. **Trip Cards:** Show "Starting from ₹X" using the minimum price
2. **Trip Detail:** Display all styles as cards with clear differentiation
3. **Booking Flow:** 
   - Step 1: Choose your style
   - Step 2: Select boarding/dropping points
   - Step 3: Review & Pay
4. **Visual Indicators:** Use icons for accommodation type (👥 sharing, 🏠 private) and meal preferences (🥗 veg, 🍖 non-veg, 🍷 alcohol)
