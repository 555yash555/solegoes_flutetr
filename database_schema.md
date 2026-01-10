# SoleGoes Database Schema

Optimized for Firestore (NoSQL). Fully addresses Agency Management, Trip Booking, and Native Vector Search for AI Recommendations.

## 1. Users Collection (`users`)
**Role:** Root collection for Customers, Admins, and Agency Owners.

- **`uid`**: `string` (auth_uid)
- **`role`**: `string` ("customer" | "admin" | "agency")
- **`username`**: `string`
- **`displayName`**: `string`
- **`bio`**: `string`
- **`website`**: `string`
- **`isOnline`**: `boolean` (For Chat status)

### Preferences
- **`travelStyle`**: `string` ("Backpacker" | "Luxury" | "Eco")
- **`budgetRange`**: `string` ("Under ₹10k" | "₹10k-25k" | "25k+")
- **`dietaryPreference`**: `string` ("Vegetarian" | "Vegan" | "Non-Veg")
- **`appSettings`**: `map` `{ language: "en", darkMode: true }`

### AI Recommendations
- **`interest_embedding`**: `Vector<768>`
- **`interests_raw`**: `array` ["beaches", "hiking", ...]

---

## 2. Agencies Collection (`agencies`)
**Role:** Business profiles linked to an owner UID.

- **`agencyId`**: `string`
- **`ownerUid`**: `string` (Ref: users)
- **`businessName`**: `string`

### Verification Details
- **`verificationStatus`**: `string` ("pending" | "approved" | "rejected")
- **`gstin`**: `string`
- **`ownerAadhaar`**: `string` (Hashed/Encrypted)
- **`teamSize`**: `string`
- **`yearsExperience`**: `number`
- **`documents`**: `map`
  - `gstCertificate`: `string` (URL)
  - `portfolioPhotos`: `array<string>` (URLs)

### Stats
- **`stats`**: `map` `{ totalRevenue: 420000, activeBookings: 28 }`

---

## 3. Trips Collection (`trips`)
**Role:** Root collection for trips. Supports Vector Search.

- **`tripId`**: `string`
- **`status`**: `string` ("pending_approval" | "live" | "rejected" | "completed")
- **`rejectionReason`**: `string` (if rejected)
- **`title`**: `string`
- **`price`**: `number`
- **`dates`**: `map` `{ start: Timestamp, end: Timestamp }`

### Details
- **`itinerary`**: `array` [Day Objects]
- **`inclusions`**: `array` ["Resort Stay", "All Meals"]
- **`categories`**: `array` ["Beach", "Wellness"]
- **`coordinates`**: `GeoPoint`
- **`embedding_vector`**: `Vector<768>`

---

## 4. Bookings Collection (`bookings`)
**Role:** Track user bookings.

- **`bookingId`**: `string`
- **`userId`**: `string`
- **`tripId`**: `string`
- **`agencyId`**: `string`
- **`status`**: `string` ("confirmed" | "pending_payment" | "cancelled" | "lead")
- **`paymentStatus`**: `string` ("paid" | "partial" | "unpaid" | "failed")
- **`amountPaid`**: `number`
- **`paymentMethod`**: `string`
- **`transactionId`**: `string`
- **`createdAt`**: `Timestamp`

---

## 5. Chats Collection (`chats`)
**Role:** Messaging (Group & Direct).

- **`type`**: `string` ("trip_group" | "direct")
- **`participants`**: `array` [uids]
- **`tripId`**: `string` (Optional)
- **`lastMessageTime`**: `Timestamp`

### Sub-collection: `messages`
- **`text`**: `string`
- **`senderId`**: `string`
- **`timestamp`**: `Timestamp`

---

## 6. Notifications Collection (`notifications`)
**Role:** User activity feed.

- **`notificationId`**: `string`
- **`userId`**: `string`
- **`type`**: `string`
- **`title`**: `string`
- **`body`**: `string`
- **`read`**: `boolean`
- **`createdAt`**: `Timestamp`

---

## 7. Analytics Events (`analytics_events`)
**Role:** High volume tracking.

- **`eventType`**: `string`
- **`tripId`**: `string`
- **`userId`**: `string`
- **`timestamp`**: `Timestamp`
