# Booking Flow & Pricing Styles

## Pricing Model

Trips offer multiple pricing styles (packages) with different accommodation and meal options.

### TripStyle Fields

| Field | Type | Example |
|-------|------|---------|
| styleId | String | `budget`, `standard`, `premium` |
| name | String | `Budget Explorer` |
| price | double | 38000 |
| accommodationType | String | `sharing-3`, `sharing-2`, `private` |
| mealOptions | List\<String\> | `["veg"]`, `["veg", "non-veg", "alcohol"]` |
| inclusions | List\<String\> | What's included in the package |

### Pricing Tiers

| Tier | Accommodation | Meals | Price Range |
|------|--------------|-------|-------------|
| Budget | 3-person sharing | Veg only | 12k-38k |
| Standard | 2-person sharing | Veg + Non-veg | 15k-45k |
| Premium | Private room | All options | 22k-58k |

---

## Booking Flow (4 Steps)

**Route:** `/trip/:tripId/book` -> `TripBookingScreen`

### Step 1: Choose Style
- Display pricing style cards with price, accommodation, meals, inclusions
- User selects `_selectedStyleId`

### Step 2: Select Boarding Point
- Show available boarding points with location, address, date/time
- User selects `_selectedBoardingPoint`

### Step 3: Select Dropping Point
- Same UI as boarding, shows drop-off locations
- User selects `_selectedDroppingPoint`

### Step 4: Review & Confirm
- Trip details, journey details, price breakdown
- "Proceed to Payment" button

### Navigation
- Back button from step 2 onwards
- Continue button disabled until selection is made
- Validation at each step before progression

---

## Data Flow

```
Trip Detail -> "Book Now" -> /trip/:tripId/book
  -> Step 1-4 selections
  -> /payment-method/:tripId (with extra: amount, styleId, styleName, points)
  -> Payment success -> BookingRepository.createBooking()
  -> /payment-confirmation/:bookingId
```

## Firestore Structure

### trips/{tripId}.pricingStyles[]
```json
{
  "styleId": "budget",
  "name": "Budget Explorer",
  "price": 38000,
  "accommodationType": "sharing-3",
  "mealOptions": ["veg"],
  "inclusions": ["..."]
}
```

### bookings/{bookingId}
```json
{
  "tripId": "abc123",
  "userId": "user456",
  "amount": 45000,
  "selectedStyleId": "standard",
  "selectedStyleName": "Standard Comfort",
  "selectedBoardingPoint": { "name": "...", "address": "...", "dateTime": "..." },
  "selectedDroppingPoint": { "name": "...", "address": "...", "dateTime": "..." }
}
```

## Key Files

| File | Purpose |
|------|---------|
| `lib/src/features/trips/domain/trip.dart` | Trip, TripStyle, TripPoint models |
| `lib/src/features/bookings/domain/booking.dart` | Booking model with SelectedTripPoint |
| `lib/src/features/bookings/data/booking_repository.dart` | Create/read bookings |
| `lib/src/features/bookings/presentation/trip_booking_screen.dart` | 4-step booking UI |
| `lib/src/features/payments/data/razorpay_service.dart` | Razorpay integration |
| `lib/src/features/payments/presentation/payment_method_screen.dart` | Payment selection |
| `lib/src/features/payments/presentation/payment_confirmation_screen.dart` | Receipt + PDF |
