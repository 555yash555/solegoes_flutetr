# Database Schema

Firestore (NoSQL) + Firebase Realtime Database (for chat).

---

## 1. users/{uid}

| Field | Type | Notes |
|-------|------|-------|
| uid | string | Firebase Auth UID |
| email | string | |
| displayName | string | |
| isEmailVerified | boolean | |
| photoUrl | string? | |
| phoneNumber | string? | |
| bio | string? | |
| city | string? | |
| gender | string? | |
| birthDate | timestamp? | |
| personalityTraits | array\<string\> | |
| interests | array\<string\> | |
| budgetRange | string? | |
| travelStyle | string? | |
| isProfileComplete | boolean | |
| isPreferencesComplete | boolean | |
| role | string? | `consumer` / `agency` / `superAdmin` |
| agencyId | string? | Set when role is `agency` |
| interest_embedding | Vector\<768\> | For AI recommendations (future) |
| createdAt | timestamp | |
| updatedAt | timestamp | |

---

## 2. agencies/{agencyId}

| Field | Type | Notes |
|-------|------|-------|
| agencyId | string | |
| ownerUid | string | Ref: users |
| businessName | string | |
| email | string | |
| phone | string | |
| description | string | |
| logoUrl | string | |
| coverImageUrl | string | |
| verificationStatus | string | `pending` / `approved` / `rejected` |
| gstin | string | |
| teamSize | string | e.g. `10-20` |
| yearsExperience | number | |
| isVerified | boolean | |
| rating | double | |
| totalTrips | number | |
| totalBookings | number | |
| specialties | array\<string\> | |
| stats | map | `{ totalRevenue, activeBookings, completedTrips }` |
| documents | map | `{ gstCertificate: URL, portfolioPhotos: [URLs] }` |
| createdAt | timestamp | |

---

## 3. trips/{tripId}

| Field | Type | Notes |
|-------|------|-------|
| tripId | string | |
| title | string | |
| description | string | |
| imageUrl | string | Primary image |
| imageUrls | array\<string\> | Gallery |
| location | string | |
| duration | number | Days |
| price | number | Base/minimum price |
| pricingStyles | array | See booking_and_pricing.md |
| categories | array\<string\> | |
| groupSize | string | |
| rating | double | |
| reviewCount | number | |
| agencyId | string | Ref: agencies |
| agencyName | string | Denormalized |
| isVerifiedAgency | boolean | Denormalized |
| status | string | `pending_approval` / `live` / `rejected` / `completed` |
| isTrending | boolean | |
| isFeatured | boolean | |
| startDate | timestamp? | Trip start date |
| endDate | timestamp? | Trip end date |
| inclusions | array\<string\> | |
| itinerary | array\<map\> | `[{ day, title, description, activities }]` |
| boardingPoints | array\<map\> | `[{ name, address, dateTime }]` |
| droppingPoints | array\<map\> | `[{ name, address, dateTime }]` |
| embedding_vector | Vector\<768\> | For AI recommendations |
| createdAt | timestamp | |
| updatedAt | timestamp | |

---

## 4. bookings/{bookingId}

| Field | Type | Notes |
|-------|------|-------|
| bookingId | string | |
| tripId | string | |
| userId | string | |
| tripTitle | string | Denormalized |
| tripImageUrl | string | Denormalized |
| tripLocation | string | Denormalized |
| tripDuration | number | Denormalized |
| amount | double | |
| paymentId | string | |
| paymentMethod | string | |
| status | string | `pending` / `confirmed` / `cancelled` / `completed` |
| paymentStatus | string | `pending` / `success` / `failed` / `refunded` |
| failureReason | string? | Set on payment failure |
| userEmail | string? | Denormalized |
| userName | string? | Denormalized |
| selectedStyleId | string? | |
| selectedStyleName | string? | |
| selectedBoardingPoint | map? | `{ name, address, dateTime }` |
| selectedDroppingPoint | map? | `{ name, address, dateTime }` |
| bookingDate | timestamp | |
| tripStartDate | timestamp? | |

---

## 5. trip_chats/{chatId} (Realtime Database)

| Field | Type | Notes |
|-------|------|-------|
| tripId | string | |
| tripTitle | string | |
| tripLocation | string | |
| tripStartDate | number | Unix ms |
| tripEndDate | number | Unix ms |
| participantIds | map | `{ "userId": true }` |
| participantCount | number | |
| lastMessage | string? | |
| lastMessageTime | number? | Unix ms |
| lastMessageSenderId | string? | |
| createdAt | number | Unix ms |

### trip_chats/{chatId}/messages/{messageId}

| Field | Type | Notes |
|-------|------|-------|
| senderId | string | |
| senderName | string | |
| senderAvatar | string? | |
| content | string | |
| timestamp | number | Unix ms |
| type | string | `text` / `image` / `system` |

---

## 6. notifications (not yet in Firestore - currently mocked)

| Field | Type | Notes |
|-------|------|-------|
| notificationId | string | |
| userId | string | |
| type | string | |
| title | string | |
| body | string | |
| read | boolean | |
| createdAt | timestamp | |

---

## Seeding

Navigate to `/seed-trips` or `/seed-lite` in the running app to populate Firebase with sample data (4 agencies, 4 trips with pricing styles, boarding/dropping points, and a sample chat).
