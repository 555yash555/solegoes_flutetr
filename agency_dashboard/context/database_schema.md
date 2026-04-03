# SoleGoes — Database Schema (Firebase)

**Firestore** for all structured data. **Firebase Realtime Database** for live chat messages.
This schema is shared by the Flutter consumer app and the Next.js agency dashboard — **do not change field names without updating both**.

---

## 1. `users/{uid}`

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
| role | string | `consumer` / `agency` / `superAdmin` — **default: `consumer`** |
| agencyId | string? | Set when role is `agency` |
| createdAt | timestamp | |
| updatedAt | timestamp | |

> **Agency dashboard reads:** `role`, `agencyId`, `displayName`, `email`, `photoUrl`

---

## 2. `agencies/{agencyId}`

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
| teamSize | string | e.g. `6-15 people` |
| yearsExperience | number | |
| isVerified | boolean | |
| rating | number | 0.0–5.0 |
| totalTrips | number | Denormalized counter |
| totalBookings | number | Denormalized counter |
| specialties | array\<string\> | |
| stats | map | `{ totalRevenue: number, activeBookings: number, completedTrips: number }` |
| documents | map | `{ gstCertificate: URL, portfolioPhotos: [URL] }` |
| bankAccountHolder | string | |
| bankName | string | |
| bankIfsc | string | |
| bankAccountNumberMasked | string | Last 4 digits only, e.g. `••••1234` |
| createdAt | timestamp | |

---

## 3. `trips/{tripId}`

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
| pricingStyles | array\<map\> | See below |
| categories | array\<string\> | |
| groupSize | string | |
| rating | number | |
| reviewCount | number | |
| agencyId | string | Ref: agencies |
| agencyName | string | Denormalized |
| isVerifiedAgency | boolean | Denormalized |
| status | string | `pending_approval` / `live` / `rejected` / `completed` / `draft` |
| isTrending | boolean | |
| isFeatured | boolean | |
| startDate | timestamp? | |
| endDate | timestamp? | |
| inclusions | array\<string\> | |
| itinerary | array\<map\> | `[{ day, title, description, activities: string[] }]` |
| boardingPoints | array\<map\> | `[{ name, address, dateTime }]` |
| droppingPoints | array\<map\> | `[{ name, address, dateTime }]` |
| createdAt | timestamp | |
| updatedAt | timestamp | |

### `pricingStyles[]` item shape
```json
{
  "styleId": "string",
  "name": "string",
  "price": number,
  "accommodationType": "string",
  "mealOptions": ["string"],
  "inclusions": ["string"]
}
```

---

## 4. `bookings/{bookingId}`

| Field | Type | Notes |
|-------|------|-------|
| bookingId | string | |
| tripId | string | |
| userId | string | |
| tripTitle | string | Denormalized |
| tripImageUrl | string | Denormalized |
| tripLocation | string | Denormalized |
| tripDuration | number | Denormalized |
| amount | number | |
| paymentId | string | |
| paymentMethod | string | |
| status | string | `pending` / `confirmed` / `cancelled` / `completed` |
| paymentStatus | string | `pending` / `success` / `failed` / `refunded` |
| failureReason | string? | |
| userEmail | string? | Denormalized |
| userName | string? | Denormalized |
| agencyId | string | **Required for agency queries** |
| selectedStyleId | string? | |
| selectedStyleName | string? | |
| selectedBoardingPoint | map? | `{ name, address, dateTime }` |
| selectedDroppingPoint | map? | `{ name, address, dateTime }` |
| bookingDate | timestamp | |
| tripStartDate | timestamp? | |

> **Agency dashboard queries:** filter by `agencyId` + optional `status`. Order by `bookingDate desc`.

---

## 5. `trip_chats/{chatId}` (Firebase Realtime Database)

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

### `trip_chats/{chatId}/messages/{messageId}`

| Field | Type | Notes |
|-------|------|-------|
| senderId | string | |
| senderName | string | |
| senderAvatar | string? | |
| content | string | |
| timestamp | number | Unix ms |
| type | string | `text` / `image` / `system` |

---

## 6. `notifications/{notificationId}` (planned)

| Field | Type | Notes |
|-------|------|-------|
| notificationId | string | |
| userId | string | Agency owner UID |
| type | string | `new_booking` / `booking_cancelled` / `agency_approved` / `payout_processed` / `message_received` |
| title | string | |
| body | string | |
| read | boolean | |
| createdAt | timestamp | |

---

## Firebase Project

- **Project:** SoleGoes (same project for Flutter app and agency dashboard)
- **Auth:** Firebase Authentication (email/password + Google Sign-In)
- **Firestore:** `us-central1` (or as configured in Flutter app)
- **Storage:** Firebase Storage for images/documents
- **RTDB:** Firebase Realtime Database for chat

> **Important:** The agency dashboard uses the **same Firebase project** as the Flutter consumer app. Never create a separate project. Auth UIDs and Firestore document IDs are shared.

---

## Firestore Security Rules (reference)

```
match /agencies/{agencyId} {
  allow read: if request.auth != null;
  allow create: if request.auth != null;
  allow update: if request.auth != null &&
    (resource.data.ownerUid == request.auth.uid ||
     get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'superAdmin');
}

match /trips/{tripId} {
  allow read: if true;
  allow create: if request.auth != null && request.resource.data.agencyId != null;
  allow update, delete: if request.auth != null &&
    resource.data.agencyId ==
      get(/databases/$(database)/documents/users/$(request.auth.uid)).data.agencyId;
}

match /bookings/{bookingId} {
  allow read: if request.auth != null;
}
```
