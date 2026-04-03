# Agency Dashboard — Implementation Tracker

**Reference:** `context/AGENCY_WEB_APP_PLAN.md` (full plan)
**Last Updated:** 2026-04-04
**Status:** Flutter handles agency entry & onboarding only (Phases 1–3 complete). Phases 4–8 (operations dashboard) moved to Next.js → see `../agency_dashboard/`.
**Approach:** 7 screens have approved HTML mockups → convert to Flutter. Remaining screens build from plan specs.

**Conversion rule:** HTML mockups are source of truth for **layout/styling/responsiveness only**. Data fields must match actual Freezed models (`Trip`, `Booking`, `Agency`, `AppUser`) and `database_schema.md`. HTML may have extra, missing, or differently-named fields — do NOT blindly copy. If mismatch found, ask user with alternative suggestion. Zero static data — all values from Riverpod providers. See plan section 12 for full guidelines.

---

## Phase 1: Agency Signup & Login

**Goal:** Agency entry point from consumer app, dedicated login, self-serve registration.
**Approach:** Convert HTML mockups → Flutter (layout/styling only). Data fields follow Freezed models + `database_schema.md`, not HTML labels. Flag mismatches to user. Zero static data.

- [x] **1.1** Add "Are you an agency?" link on login + signup screens
  - Files: `login_screen.dart`, `signup_screen.dart`
  - Link below existing sign-in/sign-up text → navigates to `/agency-login`
- [x] **1.2** Convert `00_agency_login.html` → Flutter
  - File: `lib/src/features/agency_dashboard/presentation/screens/agency_login_screen.dart` ✅
  - HTML→Flutter: split layout (hero left, form right), responsive (stacked on mobile)
  - Same auth logic (email/password + Google + Apple), role-based redirect post-login
  - Links: "Apply now" → `/agency-signup`, "Back to Traveler App" → `/login`
  - "Forgot Password?" → `FirebaseAuth.sendPasswordResetEmail()` via dialog ✅
- [x] **1.3** Convert `01_agency_signup.html` → Flutter — Step 1: Company Details
  - File: `screens/agency_signup_screen.dart` ✅
  - HTML→Flutter: 3-step wizard with brand panel (420px sticky left on desktop)
  - Fields: business name, email, phone, description, specialties, team size, experience ✅
- [x] **1.4** Convert signup Step 2: Document Upload
  - HTML→Flutter: upload zones from mockup ✅
  - GST certificate + portfolio photos (up to 5)
  - Note: File picker stub (tap to simulate) — real file_picker integration in Phase 4
- [x] **1.5** Convert signup Step 3: Bank Details
  - Account holder, account number, IFSC, bank name, terms agreement ✅
- [x] **1.6** Convert `02_agency_pending.html` → Flutter
  - File: `screens/agency_pending_screen.dart` ✅
  - HTML→Flutter: animated dashed rings (CustomPainter), blinking badge, detail pills, timeline, support row
  - Listens to verificationStatus stream, auto-redirect on approval ✅
- [x] **1.7** Add WhatsApp support link on pending screen
  - Copies number to clipboard (url_launcher not in deps — clipboard fallback)
- [x] **1.8** Add `registerAgency()` to AuthRepository ✅
  - Creates agency doc (pending) + updates user (role, agencyId)
  - File: `lib/src/features/authentication/data/auth_repository.dart`
- [x] **1.9** Add routes: `/agency-login`, `/agency-signup`, `/agency-pending` in app_router.dart ✅
- [ ] **1.10** Verify: "Are you an agency?" → agency login → signup → pending screen
- [ ] **1.11** Verify: existing consumer login still works unchanged
- [ ] **1.12** Verify: pending user cannot access /agency dashboard

**Checkpoint:** Full agency login + registration flow built. Verification on device pending.

---

## Phase 2: Foundation

**Goal:** Role-based auth working, agency model ready.

- [x] **2.1** Update `AppUser` model — add `@Default('consumer') String role` + `String? agencyId` ✅
  - File: `lib/src/features/authentication/domain/app_user.dart`
- [x] **2.2** Run `build_runner` — regenerate Freezed + JSON ✅
  - Command: `dart run build_runner build --delete-conflicting-outputs`
- [x] **2.3** Create `Agency` model (Freezed) matching `database_schema.md` ✅
  - File: `lib/src/features/agency/domain/agency.dart`
- [x] **2.4** Run `build_runner` again for Agency model ✅
- [x] **2.5** Create `AgencyRepository` with CRUD + Riverpod providers ✅
  - File: `lib/src/features/agency/data/agency_repository.dart`
  - Methods: `getAgencyById`, `watchAgency`, `createAgency`, `updateAgency`, `getPendingAgencies`, `updateVerificationStatus`
- [x] **2.6** Add role-based redirect to `GoRouter` ✅
  - File: `lib/src/routing/app_router.dart`
  - Logic: agency + approved → `/agency`, agency + pending → `/agency-pending`, superAdmin → `/admin`, consumer → `/`
- [x] **2.7** Add new `AppRoute` enum entries (agencyLogin, agencySignup, agencyPending, agencyHome, agencyTrips, etc.) ✅
  - File: `lib/src/routing/app_router.dart`
- [ ] **2.8** Verify: login with `role: 'agency'` user (via seed_lite promote) → redirects correctly
- [ ] **2.9** Verify: existing consumer login still works unchanged

**Checkpoint:** Login → redirect based on role field. Consumer flow unbroken.

---

## Phase 3: Dashboard Shell

**Goal:** Responsive navigation working at both breakpoints (sidebar ↔ drawer).
**Approach:** Extract shell components from `design_mockups/03_agency_dashboard.html` → Flutter. Same shell used in `04`, `06`.

- [ ] **3.1** Convert sidebar from HTML → Flutter
  - File: `lib/src/features/agency_dashboard/presentation/components/dashboard_sidebar.dart` (NEW)
  - 240px fixed sidebar: logo, nav items (Dashboard, My Trips, Bookings, Messages, Payouts), Profile, Settings, Sign out
  - Used as permanent sidebar (desktop) and drawer content (mobile)
- [ ] **3.2** Convert topbar from HTML → Flutter
  - File: `components/dashboard_topbar.dart` (NEW)
  - Desktop: greeting + current date + notification bell + avatar
  - Mobile: hamburger menu + page title + bell + avatar
- [ ] **3.3** Create `NotificationPopover` component
  - File: `components/notification_popover.dart` (NEW)
  - Dropdown from bell icon — recent notifications list, "View All" link
  - Placeholder data initially, wired to real data in Phase 8
- [ ] **3.4** Create `AgencyShell` — responsive scaffold using LayoutBuilder
  - File: `lib/src/features/agency_dashboard/presentation/agency_shell.dart` (NEW)
  - > 900px: permanent sidebar + content
  - < 900px: drawer sidebar + hamburger topbar
- [ ] **3.5** Create placeholder screens (empty Scaffold with title)
  - `screens/agency_home_screen.dart`
  - `screens/agency_trips_screen.dart`
  - `screens/agency_bookings_screen.dart`
  - `screens/agency_messages_screen.dart`
  - `screens/agency_profile_screen.dart`
- [ ] **3.6** Wire `StatefulShellRoute` for agency in `app_router.dart`
  - Branches for sidebar nav items
- [ ] **3.7** Verify: resize browser → sidebar ↔ drawer transition works
- [ ] **3.8** Verify: all nav items route correctly, selected state highlights, bell icon shows popover

**Checkpoint:** Agency user sees responsive shell. Navigation works at all sizes.

---

## Phase 4: Agency Home + Profile + Settings

**Goal:** Real data displayed on dashboard. Profile and account settings working.
**Approach:** Data layer first — add missing providers and repository methods, then build screens against real data.
**Rule:** Never build a screen against placeholder/mocked data if the repository method can be added immediately.

### 4a — Data Layer (implement BEFORE screens)

- [x] **4.1** Confirm `agencyStreamProvider(agencyId)` already streams `agency.stats`, `agency.rating` ✅
  - `stats` map: `totalRevenue`, `activeBookings`, `completedTrips` — denormalized, updated by booking events
  - `rating` — `@Default(0.0) double rating`
- [ ] **4.2** Add `agencyTripsProvider(agencyId)` Riverpod provider to `trip_repository.dart`
  - Wrap existing `getTripsByAgency(agencyId)` as a `@riverpod` `FutureProvider`
  - Returns `List<Trip>` ordered by `createdAt desc`, limit 5 for home screen preview
- [ ] **4.3** Add `getBookingsForAgency(agencyId)` to `BookingRepository`
  - File: `lib/src/features/bookings/data/booking_repository.dart`
  - Query: `bookings` where `agencyId == agencyId`, order by `createdAt desc`, limit 5
  - Add `@riverpod agencyBookings(Ref, agencyId)` provider
- [ ] **4.4** Add `updateAgencyProfile(agencyId, fields)` to `AgencyRepository`
  - Partial Firestore update for: businessName, email, phone, description, specialties, teamSize, yearsExperience
  - File: `lib/src/features/agency/data/agency_repository.dart`

### 4b — Screens (implement AFTER data layer is done)

- [ ] **4.5** Create `StatsCard` reusable component
  - File: `lib/src/features/agency_dashboard/presentation/components/stats_card.dart` (NEW)
  - Props: icon, iconBg, iconColor, label, value, delta (String?), deltaUp (bool?)
  - Hover: slight scale + border highlight
- [ ] **4.6** Convert `03_agency_dashboard.html` content area → `AgencyHomeScreen`
  - File: `screens/agency_home_screen.dart`
  - Sections: stats grid (4-col → 2-col, AppShimmer while loading), recent trips list, quick actions grid, recent bookings list
  - Data: `authStateChangesProvider` → agencyId → `agencyStreamProvider` + `agencyTripsProvider` + `agencyBookingsProvider`
  - "Publish a Trip" CTA → `context.go('/agency/trips/add')`
- [ ] **4.7** Build `AgencyProfileScreen`
  - File: `screens/agency_profile_screen.dart`
  - Desktop: 2-col (avatar/cover left, form right). Mobile: single column.
  - Reads: `agencyStreamProvider`. Saves via `agencyRepository.updateAgencyProfile()`
  - Fields: businessName, email, phone, description, specialties chips, teamSize, yearsExperience
- [ ] **4.8** Build `AgencySettingsScreen`
  - File: `screens/agency_settings_screen.dart` (NEW), route: `/agency/settings`
  - Sections: Account Security (change password), Bank Details (view/update), Danger Zone (deactivate)

### 4c — Verification

- [ ] **4.9** Verify: stats grid shows real values from `agency.stats` (not zeros)
- [ ] **4.10** Verify: Recent Trips and Recent Bookings render from Firestore
- [ ] **4.11** Verify: agency can edit profile and changes persist in Firestore

**Checkpoint:** Agency sees real stats. Recent trips and bookings from Firestore. Can edit profile.

---

## Phase 5: Trip Management

**Goal:** Agency can create and manage trips.
**Approach:** Data layer first (repository methods + Riverpod providers), then screens.

### 5a — Data Layer (implement BEFORE screens)

- [ ] **5.1** Add `createTrip(Trip trip)` to `TripRepository`
  - Sets `agencyId`, `agencyName`, `isVerifiedAgency`, `status: draft`, `createdAt`
- [ ] **5.2** Add `updateTrip(String tripId, Map<String,dynamic> fields)` to `TripRepository`
- [ ] **5.3** Add `deleteTripDraft(String tripId)` to `TripRepository` (drafts only — check status)
- [ ] **5.4** Add `agencyTripsStreamProvider(agencyId)` — real-time stream of all trips for agency
  - File: `trip_repository.dart` — watch `trips` where `agencyId == agencyId`, order by `createdAt desc`
  - Used by both home screen preview AND full trips list screen
- [ ] **5.5** Add `saveTripDraft(Trip trip)` to `TripRepository`
  - Upsert to `trip_drafts` subcollection under `agencies/{agencyId}`

### 5b — Screens (implement AFTER data layer)

- [ ] **5.6** Convert `04_agency_trips.html` → `AgencyTripsScreen`
  - Filter tabs: All / Live / Pending / Drafts / Completed
  - Desktop: data table. Mobile: card list (breakpoint 768px)
  - Action buttons: edit, delete, more menu
  - "Add Trip" button → `/agency/trips/add`
  - Paginated: 20 per page
- [ ] **5.7** Convert `05_agency_add_trip.html` wizard shell → `AgencyAddTripScreen`
  - File: `screens/agency_add_trip_screen.dart` (NEW), route: `/agency/trips/add`
  - Full-screen wizard with stepper, back/next sticky footer, Save Draft + Unsaved Draft badge
- [ ] **5.8** Trip Wizard Step 1: Basic Info — title, description, location, duration, categories, group size, dates
- [ ] **5.9** Trip Wizard Step 2: Media — primary image + gallery (max 10), Firebase Storage
- [ ] **5.10** Trip Wizard Step 3: Pricing — dynamic list (name, price, accommodation, meals, inclusions)
- [ ] **5.11** Trip Wizard Step 4: Itinerary — day-by-day (title, description, activities)
- [ ] **5.12** Trip Wizard Step 5: Logistics — boarding + dropping points (name, address, date/time)
- [ ] **5.13** Trip Wizard Step 6: Review — read-only summary + Publish button
- [ ] **5.14** Build edit mode — pre-fill wizard from existing trip. Route: `/agency/trips/:id/edit`
- [ ] **5.15** Build `AgencyTripDetailScreen` — stats, itinerary summary, pricing, recent bookings. Route: `/agency/trips/:id`
- [ ] **5.16** Add routes: `/agency/trips/add`, `/agency/trips/:id`, `/agency/trips/:id/edit` to `app_router.dart`

### 5c — Verification

- [ ] **5.17** Verify: create trip via wizard → appears in consumer Explore feed
- [ ] **5.18** Verify: edit existing trip → changes reflected
- [ ] **5.19** Verify: trip detail shows correct analytics

**Checkpoint:** Full trip CRUD working. Trips visible to consumers.

---

## Phase 6: Booking Management

**Goal:** Agency can view bookings for their trips.
**Approach:** Convert `06_agency_bookings.html` → Flutter. Booking detail has no mockup.

- [ ] **6.1** Add `getBookingsForTrip(tripId)` to BookingRepository
  - File: `lib/src/features/bookings/data/booking_repository.dart`
- [ ] **6.2** Convert `06_agency_bookings.html` → Flutter
  - File: `screens/agency_bookings_screen.dart`
  - HTML→Flutter: filter tabs (All/Confirmed/Pending/Cancelled), data table with traveler avatars (desktop), card list (mobile at 768px)
  - Export CSV button from mockup
  - Paginated
- [ ] **6.3** Build Agency Trip Bookings Screen
  - File: `screens/agency_trip_bookings_screen.dart` (NEW)
  - Same layout but filtered to one trip
  - Header: trip name + total bookings + revenue
  - Route: /agency/trips/:id/bookings
- [ ] **6.4** Build Agency Booking Detail Screen (no mockup — build from plan spec 5.16)
  - File: `screens/agency_booking_detail_screen.dart` (NEW)
  - Desktop: slide-out drawer (400px) or modal
  - Mobile: full-screen push
  - Sections: traveler info, trip + package, boarding/dropping points, payment info, booking timeline
  - Actions: cancel booking (confirmation dialog), contact traveler (WhatsApp/email)
  - Route: /agency/bookings/:id
- [ ] **6.5** Add routes for trip bookings + booking detail in app_router.dart
- [ ] **6.6** Verify: agency views all bookings across trips
- [ ] **6.7** Verify: filter by status works
- [ ] **6.8** Verify: per-trip booking view shows correct data
- [ ] **6.9** Verify: tap booking opens detail with traveler info and actions

**Checkpoint:** Agency can view and filter all bookings.

---

## Phase 7: Superadmin

**Goal:** Admin can approve agencies, view platform stats.

- [ ] **7.1** Build Admin Shell (reuse DashboardScaffold pattern)
  - File: `lib/src/features/admin_dashboard/presentation/admin_shell.dart` (NEW)
- [ ] **7.2** Build Admin Home Screen
  - File: `screens/admin_home_screen.dart` (NEW)
  - Stats: Total Users, Total Agencies, Pending Approvals, Revenue, Active Trips
- [ ] **7.3** Build Admin Agencies Screen
  - File: `screens/admin_agencies_screen.dart` (NEW)
  - Tabs: Pending / Approved / Rejected
  - Card list with agency info + Approve/Reject buttons
- [ ] **7.4** Build Admin Agency Detail Screen
  - File: `screens/admin_agency_detail_screen.dart` (NEW)
  - Full agency info + documents + their trips
- [ ] **7.5** Wire StatefulShellRoute for admin in app_router.dart
  - /admin, /admin/agencies, /admin/agencies/:id
- [ ] **7.6** Deploy Firestore security rules
  - Users: own doc only
  - Agencies: owner + superAdmin can update
  - Trips: agency owner can CRUD their trips
  - Bookings: agency can read their trips' bookings
- [ ] **7.7** Verify: admin approves agency → agency auto-redirects to dashboard
- [ ] **7.8** Verify: admin rejects agency → agency sees rejected state
- [ ] **7.9** Verify: consumer cannot access /admin or /agency routes

**Checkpoint:** Full admin approval flow working. All roles properly gated.

---

## Phase 8: Messages, Notifications & Payouts

**Goal:** Agency can chat with travelers, receive notifications, and view financials.

- [ ] **8.1** Build Agency Messages Screen
  - File: `screens/agency_messages_screen.dart`
  - Desktop: 2-pane — conversation list (left, 320px) + active chat (right)
  - Mobile: conversation list → tap to open chat (push navigation)
  - Each conversation tied to a trip (trip name as header)
  - Unread badge count on sidebar/bottom nav
  - Reuses existing `ChatRepository` — filtered to agency's trips
- [ ] **8.2** Build Agency Notifications Screen
  - File: `screens/agency_notifications_screen.dart` (NEW)
  - Full notification list: icon + title + body + timestamp + read/unread
  - Mark as read on tap, "Mark all as read" action
  - Route: /agency/notifications
- [ ] **8.3** Wire Notification Popover to real data
  - Connect `notification_popover.dart` to Firestore `notifications` collection
  - Real-time stream filtered by agency owner UID
  - Unread count badge on bell icon
- [ ] **8.4** Create `notifications` collection in Firestore
  - Fields: notificationId, userId, type, title, body, read, createdAt
  - Types: new_booking, booking_cancelled, payout_processed, agency_approved, message_received
- [ ] **8.5** Build Agency Payouts Screen
  - File: `screens/agency_payouts_screen.dart` (NEW)
  - Summary cards: Total Revenue, Platform Fees, Net Payouts, Pending Payout
  - Payout history: DataTable (desktop) / Cards (mobile) — date, amount, status, reference
  - Filter by date range
  - Route: /agency/payouts
- [ ] **8.6** Add payout data source
  - Either `payouts` Firestore collection or computed aggregation from bookings
- [ ] **8.7** Verify: agency can send/receive messages in trip chats
- [ ] **8.8** Verify: notifications appear in real-time (new booking triggers notification)
- [ ] **8.9** Verify: payouts screen shows correct revenue breakdown

**Checkpoint:** Agency has full communication, notification, and financial visibility.

---

## Progress Summary

| Phase | Status | Data Layer | Screens | Notes |
|-------|--------|------------|---------|-------|
| 1. Agency Signup & Login | ✅ Complete | N/A | ✅ All screens | login, signup (3-step), pending, registerAgency(), routes |
| 2. Foundation | ✅ Complete | ✅ Models + repos | N/A | AppUser role/agencyId, Agency model, AgencyRepository, GoRouter role redirect |
| 3. Dashboard Shell | ✅ Complete | N/A | ✅ Shell + placeholders | AgencyShell, sidebar (450 lines), topbar, 5 placeholder screens |
| 4–8. Operations Dashboard | 🚫 Moved to Next.js | — | — | Continued in `../agency_dashboard/` |

### What Flutter owns (permanent)
- Consumer mobile app — full trip discovery, booking, chat, payments
- Agency login screen (`/agency-login`)
- Agency signup 3-step wizard (`/agency-signup`) — company details, document upload, bank details
- Agency pending screen (`/agency-pending`) — animated, auto-redirects on approval
- Role-based GoRouter redirect — consumer → `/`, agency+approved → `/agency`, agency+pending → `/agency-pending`, superAdmin → `/admin`
- Scroll-down hint indicator on signup screen

### What Next.js owns (new)
- All agency day-to-day operations: dashboard, trips, bookings, messages, profile, settings, payouts
- Superadmin approval queue
- See `../agency_dashboard/` for the full Next.js project

### Data Layer Rule
**Never implement a screen before its data layer is complete.**
Order for each phase: repository methods → Riverpod providers → screen widgets.

### Screens Without Mockups (build from plan spec)
- Agency Profile, Agency Settings, Agency Trip Detail, Agency Booking Detail
- Agency Messages, Agency Notifications, Agency Payouts
- All 3 Admin screens
