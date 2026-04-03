# Agency Dashboard — Implementation Tracker

**Reference:** `context/AGENCY_WEB_APP_PLAN.md`
**Last Updated:** 2026-04-04
**Framework:** Next.js 14 (App Router) + Firebase JS SDK v10
**Design reference:** `context/design_system.md` (replaces app_theme.dart)
**HTML mockups:** `design_mockups/` (layout/styling source of truth — not data)

---

## Progress Summary

| Phase | Status | Notes |
|-------|--------|-------|
| 1. Foundation & Auth | ❌ Not started | |
| 2. Dashboard Shell | ❌ Not started | |
| 3. Agency Home Screen | ❌ Not started | |
| 4. Trip Management | ❌ Not started | |
| 5. Booking Management | ❌ Not started | |
| 6. Profile / Settings / Payouts / Messages | ❌ Not started | |
| 7. Superadmin | ❌ Not started | |

---

## Phase 1: Foundation & Auth

**Goal:** Project scaffolded, Firebase connected, auth working, routes protected.

- [ ] **1.1** Scaffold Next.js 14 project with TypeScript + Tailwind CSS
  - `npx create-next-app@latest ./ --typescript --tailwind --app --src-dir-no`
  - Install deps: `firebase`, `lucide-react`, `shadcn/ui`, `react-hook-form`, `zod`, `@tanstack/react-table`
- [ ] **1.2** Configure Tailwind (`tailwind.config.ts`) with custom color tokens from `design_system.md`
  - Add Plus Jakarta Sans via `next/font/google` in `app/layout.tsx`
- [ ] **1.3** Create `lib/firebase.ts` — initialize Firebase app with same project as Flutter app
  - Copy `firebaseConfig` from Flutter app's `google-services.json` / `GoogleService-Info.plist`
- [ ] **1.4** Create `lib/types.ts` — TypeScript interfaces for `AppUser`, `Agency`, `Trip`, `Booking`, etc.
  - Reference: `context/database_schema.md`
- [ ] **1.5** Create `lib/auth-context.tsx`
  - `onAuthStateChanged` → fetch `users/{uid}` → fetch `agencies/{agencyId}`
  - Provides: `user`, `agency`, `loading`, `signOut`
- [ ] **1.6** Create `middleware.ts` — protect `/dashboard/**` and `/admin/**`
  - Unauthenticated → redirect to `/login`
- [ ] **1.7** Build Agency Login page (`app/(auth)/login/page.tsx`)
  - Reference mockup: `design_mockups/00_agency_login.html`
  - Desktop: 2-col split (hero left, form right `max-w-sm`)
  - Mobile: stacked (hero 200px, form below)
  - Fields: email + password, Google sign-in button
  - "Forgot password?" → `sendPasswordResetEmail()`
  - Post-login: check `user.role === 'agency'` → redirect to `/dashboard`
- [ ] **1.8** Build `/auth/page.tsx` — token handoff from Flutter redirect
  - Reads `?token=` from URL → `signInWithCustomToken()` → redirect to `/dashboard`
- [ ] **1.9** Verify: Login → redirected to `/dashboard` (placeholder). Non-agency user → redirected back to login.

**Checkpoint ✅:** Auth works. Protected routes enforce redirect. Login page matches mockup on desktop + mobile.

---

## Phase 2: Dashboard Shell

**Goal:** Responsive navigation working — permanent sidebar on desktop, drawer on mobile.

- [ ] **2.1** Build `DashboardSidebar` component
  - File: `components/shell/dashboard-sidebar.tsx`
  - Reference: sidebar from `design_mockups/03_agency_dashboard.html`
  - 240px fixed: SoleGoes logo + "Agency" badge, nav items (Dashboard, My Trips, Bookings, Messages, Payouts), divider, Profile, Settings, Sign out
  - Active nav item: `bg-indigo-500/10 text-indigo-400 border border-indigo-500/20`
  - Hover: `hover:bg-white/5 hover:text-zinc-50`
- [ ] **2.2** Build `DashboardTopbar` component
  - File: `components/shell/dashboard-topbar.tsx`
  - Reference: topbar from `design_mockups/03_agency_dashboard.html`
  - Desktop: greeting ("Good morning, {businessName}") + current date + notification bell + avatar
  - Mobile: hamburger icon + page title + bell + avatar
  - Notification bell → popover with recent 5 notifications + "View All" link
- [ ] **2.3** Build `AgencyShell` responsive scaffold
  - File: `components/shell/agency-shell.tsx`
  - `>= lg (900px)`: `flex flex-row` — sidebar 240px fixed + main column (topbar + scrollable content)
  - `< lg`: topbar with hamburger + shadcn/ui `Sheet` component as drawer sidebar
- [ ] **2.4** Create `app/(dashboard)/layout.tsx` — wraps all dashboard routes with `AgencyShell`
- [ ] **2.5** Create placeholder pages for all 5 nav routes (just heading + page title):
  - `app/(dashboard)/dashboard/page.tsx`
  - `app/(dashboard)/trips/page.tsx`
  - `app/(dashboard)/bookings/page.tsx`
  - `app/(dashboard)/messages/page.tsx`
  - `app/(dashboard)/profile/page.tsx`
- [ ] **2.6** Verify: resize browser → sidebar ↔ drawer transitions. All nav items route correctly. Active state highlights. Bell icon shows popover (placeholder data).

**Checkpoint ✅:** Shell works at all screen sizes. Navigation functional.

---

## Phase 3: Agency Home Screen

**Goal:** Real data displayed on dashboard overview.

**Data layer first:**
- [ ] **3.1** Create `lib/firestore/agency.ts`
  - `getAgency(agencyId)` → one-time fetch
  - `watchAgency(agencyId, callback)` → `onSnapshot` real-time stream
  - `updateAgency(agencyId, fields)` → partial Firestore update
- [ ] **3.2** Create `lib/firestore/trips.ts`
  - `getTripsByAgency(agencyId, limit?)` → ordered by `createdAt desc`
  - `watchTripsByAgency(agencyId, callback)` → real-time stream
- [ ] **3.3** Create `lib/firestore/bookings.ts`
  - `getBookingsForAgency(agencyId, limit?)` → ordered by `bookingDate desc`
  - `getBookingsForTrip(tripId, limit?)` → ordered by `bookingDate desc`

**Screens:**
- [ ] **3.4** Build `StatsCard` component (`components/stats-card.tsx`)
  - Props: `icon`, `iconBg`, `iconColor`, `label`, `value`, `delta?`, `deltaUp?`
  - Reference: stats grid from `design_mockups/03_agency_dashboard.html`
  - Hover: `hover:scale-[1.02]` + primary glow shadow
  - Loading state: shadcn/ui `Skeleton`
- [ ] **3.5** Build Agency Home Screen (`app/(dashboard)/dashboard/page.tsx`)
  - Reference mockup: `design_mockups/03_agency_dashboard.html`
  - Stats grid: Total Revenue (`agency.stats.totalRevenue`), Active Bookings (`stats.activeBookings`), Live Trips (`agency.totalTrips`), Rating (`agency.rating`)
  - Grid: `grid-cols-1 sm:grid-cols-2 lg:grid-cols-4`
  - Recent trips section: last 5 trips as compact rows (image, title, status badge, price)
  - Recent bookings section: last 5 bookings as list rows (traveler, trip, amount, status)
  - Quick actions grid: Publish Trip, View Bookings, Messages, Payouts
  - All sections: Skeleton loading states while data loads
- [ ] **3.6** Verify: real stats from `agency.stats`. Recent trips + bookings from Firestore. Skeletons show during load.

**Checkpoint ✅:** Agency sees real live data on dashboard.

---

## Phase 4: Trip Management

**Goal:** Agency can create, view, edit, and manage trips.

**Data layer first:**
- [ ] **4.1** Add to `lib/firestore/trips.ts`:
  - `createTrip(trip: Omit<Trip, 'tripId' | 'createdAt' | 'updatedAt'>)` → returns `tripId`
  - `updateTrip(tripId, fields)` → partial update
  - `deleteDraft(tripId)` → only if `status === 'draft'`

**Screens:**
- [ ] **4.2** Build Agency Trips Screen (`app/(dashboard)/trips/page.tsx`)
  - Reference mockup: `design_mockups/04_agency_trips.html`
  - Filter tabs: All / Live / Pending / Drafts / Completed
  - Desktop: TanStack Table columns: Thumbnail, Title, Status, Price, Bookings, Start Date, Actions
    - Sortable columns, hover highlight on rows
    - Actions: Edit → `/trips/[id]/edit`, View Bookings → `/trips/[id]/bookings`, Delete (drafts only)
  - Mobile (`< lg`): Card list with trip image, title, status badge, price. Tap to open detail.
  - "Add Trip" button (top right on desktop, FAB on mobile) → `/trips/new`
  - Paginated: 20 per page
- [ ] **4.3** Build Add Trip Wizard shell (`app/(dashboard)/trips/new/page.tsx`)
  - Reference mockup: `design_mockups/05_agency_add_trip.html`
  - Full-screen (no sidebar nav — use separate layout without shell)
  - Step indicator at top, content `max-w-2xl` centered
  - Sticky bottom bar: Back + Next/Publish buttons + "Save Draft" link
- [ ] **4.4** Trip Wizard Step 1: Basic Info
  - Fields: title, description, location, duration (days), categories (multi-select chips), group size, start date, end date
  - React Hook Form + Zod validation
- [ ] **4.5** Trip Wizard Step 2: Media
  - Primary image upload + gallery (max 10) via Firebase Storage
  - Drag-and-drop zone
- [ ] **4.6** Trip Wizard Step 3: Pricing Styles
  - Dynamic list (min 1, max 5): name, price, accommodation type, meal options (chips), inclusions (tag input)
  - Add/remove style rows
- [ ] **4.7** Trip Wizard Step 4: Itinerary
  - Auto-generate day entries from `duration` field
  - Each day: title, description, activities (tag input)
- [ ] **4.8** Trip Wizard Step 5: Logistics
  - Boarding points list: name, address, date/time picker
  - Dropping points list: name, address, date/time picker
  - Add/remove point rows
- [ ] **4.9** Trip Wizard Step 6: Review
  - Read-only summary of all steps
  - "Publish" button → `createTrip()` with `status: 'live'` → redirect to `/trips`
  - "Save Draft" → `createTrip()` with `status: 'draft'`
- [ ] **4.10** Build Trip Detail Screen (`app/(dashboard)/trips/[id]/page.tsx`)
  - Header: trip image + title + status badge + Edit button
  - Stats row: total bookings, revenue, avg rating
  - Sections: itinerary summary, pricing styles, boarding/dropping points, last 10 bookings
- [ ] **4.11** Add routes to sidebar: trips link active on `/trips/**`
- [ ] **4.12** Verify: create trip → appears in Flutter consumer app Explore feed. Edit trip → changes reflected. Delete draft works.

**Checkpoint ✅:** Full trip CRUD working. Published trips visible to consumers.

---

## Phase 5: Booking Management

**Goal:** Agency can view and filter all bookings.

- [ ] **5.1** Build Agency Bookings Screen (`app/(dashboard)/bookings/page.tsx`)
  - Reference mockup: `design_mockups/06_agency_bookings.html`
  - Filter tabs: All / Confirmed / Pending / Cancelled
  - Desktop: TanStack Table — Traveler Name, Trip, Package, Amount, Status, Date
  - Mobile: Card list — traveler + trip name + amount + status badge
  - Click row/card → booking detail
  - Export CSV button (from mockup)
  - Paginated
- [ ] **5.2** Build Agency Trip Bookings Screen (`app/(dashboard)/trips/[id]/bookings/page.tsx`)
  - Same layout as bookings screen but filtered to one trip
  - Header: trip name + total bookings count + total revenue
- [ ] **5.3** Build Booking Detail (`app/(dashboard)/bookings/[id]/page.tsx`)
  - Desktop: slide-over drawer (400px) or full-page
  - Mobile: full page
  - Sections: traveler info (name, email, phone), trip + package, boarding/dropping points, payment info, booking timeline
  - Actions: Cancel booking (with shadcn `AlertDialog` confirmation), Contact traveler (WhatsApp link)
- [ ] **5.4** Verify: filter by status works. Booking detail shows correct traveler info and actions.

**Checkpoint ✅:** Agency views and filters all bookings. Booking detail shows full info.

---

## Phase 6: Profile, Settings, Payouts, Messages

- [ ] **6.1** Build Agency Profile Screen (`app/(dashboard)/profile/page.tsx`)
  - No mockup — build from plan spec
  - Desktop 2-col: logo/cover upload left, form right. Mobile: single column.
  - Fields: businessName, email, phone, description, specialties (chip select), teamSize, yearsExperience
  - Save via `updateAgency()`
- [ ] **6.2** Build Agency Settings Screen (`app/(dashboard)/settings/page.tsx`)
  - Sections: Account Security (change password), Bank Details (view/update), GST & Documents, Notification Preferences, Danger Zone (deactivate)
- [ ] **6.3** Build Agency Payouts Screen (`app/(dashboard)/payouts/page.tsx`)
  - Summary cards: Total Revenue, Platform Fees (10%), Net Payouts, Pending Payout
  - Payout history: TanStack Table (desktop) / cards (mobile) — date, amount, status, reference ID
  - Filter by date range
- [ ] **6.4** Build Agency Messages Screen (`app/(dashboard)/messages/page.tsx`)
  - Desktop: 2-pane — conversation list (left 320px) + active chat (right)
  - Mobile: conversation list → tap to open chat
  - Reuses Firebase RTDB `trip_chats` collection
  - Each conversation: trip name as header, last message preview, unread count badge
- [ ] **6.5** Wire notification bell popover to real Firestore `notifications` collection

**Checkpoint ✅:** Agency can edit profile, manage settings, view financials, chat with travelers.

---

## Phase 7: Superadmin

- [ ] **7.1** Build Admin Shell (`app/admin/layout.tsx`)
  - Same shell pattern — sidebar with Admin nav items: Home, Agencies
- [ ] **7.2** Build Admin Home Screen (`app/admin/page.tsx`)
  - Stats: Total Users, Total Agencies, Pending Approvals, Revenue, Active Trips
- [ ] **7.3** Build Admin Agencies Screen (`app/admin/agencies/page.tsx`)
  - Tabs: Pending / Approved / Rejected
  - Card list: agency name, logo, owner email, submission date, specialties
  - Actions: Approve (→ `verificationStatus: 'approved'`, `isVerified: true`) + Reject (dialog with reason)
- [ ] **7.4** Build Admin Agency Detail Screen (`app/admin/agencies/[id]/page.tsx`)
  - Full agency info + documents + their trips list
- [ ] **7.5** Verify: Admin approves agency → Flutter app auto-redirects them to dashboard.

**Checkpoint ✅:** Full admin approval flow. All roles properly gated.

---

## Key Rules

### Data Layer Rule
**Never build a screen before its Firestore query functions exist.** Order: `lib/firestore/*.ts` functions → component → page.

### Conversion Rule
HTML mockups are source of truth for **layout + visual structure only**. Always map HTML display labels to actual TypeScript interface field names from `context/database_schema.md`.

### No Static Data
Every text, number, badge, and list item must come from Firebase. Use `Skeleton` components for loading states.

### Design Rule
All styling from `context/design_system.md`. No hardcoded hex values in JSX. No inline styles.
