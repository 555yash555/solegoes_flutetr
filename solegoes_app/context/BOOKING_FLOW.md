# Multi-Step Booking Flow Implementation

## Overview
Created a dedicated booking screen that guides users through a 4-step process to complete their trip booking.

## Route
**Path:** `/trip/:tripId/book`  
**Screen:** `TripBookingScreen`

## Booking Flow Steps

### Step 1: Choose Your Style 🎨
- Display all available pricing styles as cards
- Show price, accommodation type, meal options
- List key inclusions (first 3 items + count)
- Visual tags for accommodation (bed icon) and meals (utensils icon)

**User Selection:** `_selectedStyleId`

### Step 2: Select Boarding Point 📍
- Show all available boarding points
- Display location name, address, and date/time
- Visual map pin icon
- Formatted date display (e.g., "15 Feb, 06:00")

**User Selection:** `_selectedBoardingPoint`

### Step 3: Select Dropping Point 🏁
- Same UI as boarding point selection
- Shows drop-off locations and times

**User Selection:** `_selectedDroppingPoint`

### Step 4: Review & Confirm ✅
Three sections:
1. **Trip Details:** Destination, duration, selected package
2. **Journey Details:** Boarding and dropping points
3. **Price Breakdown:** Base price, taxes (₹0 for now), total

## UI Features

### Progress Indicator
- 4-step horizontal stepper at the top
- Shows: Style → Pickup → Drop → Review
- Active step highlighted in primary color
- Completed steps show checkmark
- Connecting lines between steps

### Navigation
- **Back Button:** Available from step 2 onwards
- **Continue Button:** 
  - Disabled until required selection is made
  - Changes to "Proceed to Payment" on final step
- **Validation:** Each step validates before allowing progression

### Visual Design
- **Selected Cards:** Primary color border (2px) + light background tint
- **Unselected Cards:** Subtle border + surface background
- **Icons:** Lucide icons throughout for consistency
- **Typography:** Clear hierarchy with bold headings

## Integration Points

### From Trip Detail Screen
Add a "Book Now" button that navigates to:
```dart
context.push('/trip/${trip.tripId}/book');
```

### To Payment Screen
On final step, navigate to payment with all booking data:
```dart
context.push(
  '/payment-method/${trip.tripId}',
  extra: {
    'amount': selectedStyle.price,
    'styleId': selectedStyle.styleId,
    'styleName': selectedStyle.name,
    'boardingPoint': _selectedBoardingPoint,
    'droppingPoint': _selectedDroppingPoint,
  },
);
```

## State Management
Uses local `setState` for:
- `_currentStep` (0-3)
- `_selectedStyleId`
- `_selectedBoardingPoint`
- `_selectedDroppingPoint`

All selections are validated before allowing progression.

## Data Flow
1. Fetch trip data using `tripProvider(tripId)`
2. User makes selections through UI
3. Pass selections to payment screen
4. Payment screen creates booking with all details

## Next Steps

### 1. Update Trip Detail Screen
Add "Book Now" button:
```dart
ElevatedButton(
  onPressed: () => context.push('/trip/${trip.tripId}/book'),
  child: Text('Book Now'),
)
```

### 2. Update Payment Screen
Accept the booking details from `extra` parameter:
```dart
final extra = GoRouterState.of(context).extra as Map<String, dynamic>;
final amount = extra['amount'] as double;
final styleId = extra['styleId'] as String;
// ... etc
```

### 3. Create Booking After Payment
In payment success callback:
```dart
await bookingRepository.createBooking(
  tripId: tripId,
  userId: currentUser.uid,
  amount: amount,
  selectedStyleId: styleId,
  selectedStyleName: styleName,
  selectedBoardingPoint: SelectedTripPoint(...),
  selectedDroppingPoint: SelectedTripPoint(...),
  // ... other fields
);
```

## File Locations
- **Screen:** `lib/src/features/bookings/presentation/trip_booking_screen.dart`
- **Route:** `lib/src/routing/app_router.dart` (line ~262)
- **Route Enum:** Added `tripBooking` to `AppRoute` enum
