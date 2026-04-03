# SoleGoes Agency Dashboard — Next.js Implementation Plan

**Last Updated:** 2026-04-04
**Framework:** Next.js 14 (App Router) + Firebase JS SDK v10
**Platform:** Web only (`agency.solegoes.in`)
**Auth strategy:** Shared Firebase project with Flutter consumer app

---

## 1. Architecture Overview

```
solegoes_app/   (Flutter — consumer mobile + agency signup/pending)
agency_dashboard/  (Next.js — agency day-to-day operations)
  ↕ same Firebase project, same Firestore, same Auth UIDs
```

### Why Next.js for the dashboard
- Data-heavy admin UIs (sortable tables, filters, charts) are far faster to build in React ecosystem
- Full Firebase JS SDK is first-class (not a wrapper like FlutterFire)
- shadcn/ui + TanStack Table = DataTables in minutes, not days
- Server-side rendering for faster initial load

### Auth Handoff (Flutter → Next.js)

Agency users complete signup + pending flow in the Flutter app.
When approved, Flutter redirects to `agency.solegoes.in` (production) or `localhost:3000` (dev).

**Cross-origin session sharing:**
- Production: Firebase Auth auto-shares session via localStorage (same subdomain)
- Local dev: Agency can sign in directly at `localhost:3000` — same Firebase project, same credentials

**Token-based redirect (optional for production):**
```dart
// Flutter — after agency approved
final token = await FirebaseAuth.instance.currentUser!.getIdToken();
window.open('https://agency.solegoes.in/auth?token=$token');
```
```ts
// Next.js /auth/page.tsx
// signInWithCustomToken(auth, token) → redirect to /dashboard
```

---

## 2. Tech Stack

| Layer | Choice | Notes |
|-------|--------|-------|
| Framework | Next.js 14 (App Router) | File-based routing, RSC, layouts |
| Language | TypeScript | Strict mode |
| Auth | Firebase Auth JS SDK v10 | `onAuthStateChanged`, `signInWithEmailAndPassword`, `signInWithGoogle` |
| Database | Firebase Firestore JS SDK v10 | `onSnapshot` for real-time, `getDocs` for one-time |
| Storage | Firebase Storage JS SDK | Image/document uploads |
| UI Components | shadcn/ui | Built on Radix — accessible, unstyled base |
| Styling | Tailwind CSS v3 | Matches design tokens from branding.md |
| Tables | TanStack Table v8 | Sortable, filterable, paginated |
| Charts | Recharts | Revenue/booking analytics |
| Icons | Lucide React | Same icon library as Flutter app |
| Forms | React Hook Form + Zod | Validation matching Flutter field rules |
| State | Zustand (UI state) + React Query (server state) | Or use Firestore hooks directly |

---

## 3. Project Structure

```
agency_dashboard/
├── app/
│   ├── (auth)/
│   │   ├── login/page.tsx           ← Agency login (00_agency_login.html)
│   │   └── auth/page.tsx            ← Token handoff from Flutter
│   ├── (dashboard)/
│   │   ├── layout.tsx               ← AgencyShell (sidebar + topbar)
│   │   ├── page.tsx                 ← /  → redirect to /dashboard
│   │   ├── dashboard/page.tsx       ← AgencyHomeScreen (03_agency_dashboard.html)
│   │   ├── trips/
│   │   │   ├── page.tsx             ← AgencyTripsScreen (04_agency_trips.html)
│   │   │   ├── new/page.tsx         ← AgencyAddTripScreen (05_agency_add_trip.html)
│   │   │   └── [id]/
│   │   │       ├── page.tsx         ← AgencyTripDetailScreen
│   │   │       ├── edit/page.tsx    ← AgencyEditTripScreen
│   │   │       └── bookings/page.tsx ← AgencyTripBookingsScreen
│   │   ├── bookings/
│   │   │   ├── page.tsx             ← AgencyBookingsScreen (06_agency_bookings.html)
│   │   │   └── [id]/page.tsx        ← AgencyBookingDetailScreen
│   │   ├── messages/page.tsx        ← AgencyMessagesScreen
│   │   ├── profile/page.tsx         ← AgencyProfileScreen
│   │   ├── settings/page.tsx        ← AgencySettingsScreen
│   │   ├── payouts/page.tsx         ← AgencyPayoutsScreen
│   │   └── notifications/page.tsx   ← AgencyNotificationsScreen
│   └── admin/
│       ├── layout.tsx               ← AdminShell
│       ├── page.tsx                 ← AdminHomeScreen
│       ├── agencies/page.tsx        ← AdminAgenciesScreen
│       └── agencies/[id]/page.tsx   ← AdminAgencyDetailScreen
├── components/
│   ├── shell/
│   │   ├── agency-shell.tsx         ← Responsive sidebar/drawer layout
│   │   ├── dashboard-sidebar.tsx    ← 240px fixed sidebar (from 03 HTML)
│   │   └── dashboard-topbar.tsx     ← Greeting + bell + avatar (from 03 HTML)
│   ├── ui/                          ← shadcn/ui components
│   ├── stats-card.tsx               ← Metric card (from 03 HTML stats grid)
│   ├── data-table.tsx               ← TanStack Table wrapper
│   ├── trip-card.tsx                ← Trip card (mobile view)
│   ├── booking-row.tsx              ← Booking table row
│   └── trip-wizard/
│       ├── wizard-shell.tsx
│       ├── step-basic-info.tsx
│       ├── step-media.tsx
│       ├── step-pricing.tsx
│       ├── step-itinerary.tsx
│       ├── step-logistics.tsx
│       └── step-review.tsx
├── lib/
│   ├── firebase.ts                  ← Firebase app init (client-side)
│   ├── firebase-admin.ts            ← Firebase Admin SDK (server-side, optional)
│   ├── auth-context.tsx             ← AuthContext + AgencyContext providers
│   ├── firestore/
│   │   ├── agency.ts                ← getAgency, watchAgency, updateAgency
│   │   ├── trips.ts                 ← getTripsByAgency, createTrip, updateTrip
│   │   ├── bookings.ts              ← getBookingsForAgency, getBookingsForTrip
│   │   └── notifications.ts        ← watchNotifications, markAsRead
│   └── types.ts                     ← TypeScript interfaces matching Firestore schema
├── context/                         ← (this folder) — plans, schema, mockups guide
├── design_mockups/                  ← HTML reference files
└── middleware.ts                    ← Route protection (redirect if not auth'd/agency)
```

---

## 4. TypeScript Types (matching Firestore schema)

```ts
// lib/types.ts

export interface AppUser {
  uid: string;
  email: string;
  displayName: string;
  photoUrl?: string;
  role: 'consumer' | 'agency' | 'superAdmin';
  agencyId?: string;
}

export interface Agency {
  agencyId: string;
  ownerUid: string;
  businessName: string;
  email: string;
  phone: string;
  description: string;
  logoUrl: string;
  coverImageUrl: string;
  verificationStatus: 'pending' | 'approved' | 'rejected';
  gstin: string;
  teamSize: string;
  yearsExperience: number;
  isVerified: boolean;
  rating: number;
  totalTrips: number;
  totalBookings: number;
  specialties: string[];
  stats: { totalRevenue: number; activeBookings: number; completedTrips: number };
  documents: { gstCertificate?: string; portfolioPhotos?: string[] };
  bankAccountHolder: string;
  bankName: string;
  bankIfsc: string;
  bankAccountNumberMasked: string;
  createdAt: Timestamp;
}

export interface Trip {
  tripId: string;
  title: string;
  description: string;
  imageUrl: string;
  imageUrls: string[];
  location: string;
  duration: number;
  price: number;
  pricingStyles: TripStyle[];
  categories: string[];
  groupSize: string;
  rating: number;
  reviewCount: number;
  agencyId: string;
  agencyName: string;
  isVerifiedAgency: boolean;
  status: 'pending_approval' | 'live' | 'rejected' | 'completed' | 'draft';
  isTrending: boolean;
  isFeatured: boolean;
  startDate?: Timestamp;
  endDate?: Timestamp;
  inclusions: string[];
  itinerary: ItineraryDay[];
  boardingPoints: TripPoint[];
  droppingPoints: TripPoint[];
  createdAt: Timestamp;
  updatedAt: Timestamp;
}

export interface TripStyle {
  styleId: string;
  name: string;
  price: number;
  accommodationType: string;
  mealOptions: string[];
  inclusions: string[];
}

export interface TripPoint {
  name: string;
  address: string;
  dateTime: Timestamp;
}

export interface ItineraryDay {
  day: number;
  title: string;
  description: string;
  activities: string[];
}

export interface Booking {
  bookingId: string;
  tripId: string;
  userId: string;
  tripTitle: string;
  tripImageUrl: string;
  tripLocation: string;
  amount: number;
  paymentId: string;
  status: 'pending' | 'confirmed' | 'cancelled' | 'completed';
  paymentStatus: 'pending' | 'success' | 'failed' | 'refunded';
  userEmail?: string;
  userName?: string;
  agencyId: string;
  selectedStyleId?: string;
  selectedStyleName?: string;
  selectedBoardingPoint?: TripPoint;
  selectedDroppingPoint?: TripPoint;
  bookingDate: Timestamp;
  tripStartDate?: Timestamp;
}
```

---

## 5. Responsive Layout Strategy

### Breakpoints (matching HTML mockups)

| Name | Width | Navigation |
|------|-------|------------|
| Mobile | < 900px | Hamburger → sheet/drawer overlay |
| Desktop | ≥ 900px | Permanent sidebar (240px) |

### AgencyShell layout

```tsx
// app/(dashboard)/layout.tsx
export default function DashboardLayout({ children }) {
  return (
    <AuthGuard>          {/* redirects if not logged in or not agency */}
      <AgencyShell>      {/* sidebar + topbar + content area */}
        {children}
      </AgencyShell>
    </AuthGuard>
  );
}
```

Desktop: `flex flex-row` — sidebar (240px fixed) + main column (topbar + scrollable content)
Mobile: topbar with hamburger + Sheet component for sidebar drawer

---

## 6. Screen Specifications

### 6.1 Agency Home Screen
**Mockup:** `design_mockups/03_agency_dashboard.html`
- Stats grid: Total Revenue, Active Bookings, Live Trips, Rating (4-col → 2-col → 1-col)
- Recent trips: last 5 trips as compact cards with status badges
- Recent bookings: last 5 as list rows
- Quick actions: Publish Trip, View Bookings, Messages, Payouts
- Data: `agency.stats` (denormalized) + `getTripsByAgency(limit 5)` + `getBookingsForAgency(limit 5)`

### 6.2 Agency Trips Screen
**Mockup:** `design_mockups/04_agency_trips.html`
- Filter tabs: All / Live / Pending / Draft / Completed
- Desktop: TanStack DataTable (sortable columns: Title, Status, Price, Bookings, Date, Actions)
- Mobile: Card list with trip image + title + status badge
- Actions: Edit, View Bookings, Delete (drafts only)
- "Add Trip" button → `/trips/new`
- Paginated: 20 per page with cursor-based pagination

### 6.3 Agency Add Trip Screen (Wizard)
**Mockup:** `design_mockups/05_agency_add_trip.html`
- Full-screen wizard (exits the shell nav), content `max-w-2xl` centered
- Steps: Basic Info → Media → Pricing Styles → Itinerary → Logistics → Review
- Save as draft at any step (writes to Firestore with `status: 'draft'`)
- On publish: `createTrip()` with `status: 'live'`, `agencyId`, `agencyName`
- React Hook Form + Zod for field validation

### 6.4 Agency Bookings Screen
**Mockup:** `design_mockups/06_agency_bookings.html`
- Filter tabs: All / Confirmed / Pending / Cancelled
- Desktop: TanStack DataTable (Traveler, Trip, Package, Amount, Status, Date)
- Mobile: Card list with traveler + trip + status
- Tap row → booking detail page or slide-over drawer

### 6.5 Agency Login Screen
**Mockup:** `design_mockups/00_agency_login.html`
- Desktop: Two-column split (hero left, form right `max-w-sm`)
- Mobile: Stacked (hero collapses to 200px, form below)
- Fields: email + password, Google sign-in
- "Forgot password?" → Firebase sendPasswordResetEmail()
- "Not a partner? Apply now" → Flutter app signup URL

### 6.6 Other Screens (no mockup — build from spec)
- **Profile:** 2-col desktop (logo/cover left, form right), single col mobile
- **Settings:** Sectioned cards — security, bank details, notifications prefs, danger zone
- **Messages:** 2-pane chat hub desktop / list→detail mobile, reuses Firestore RTDB chat
- **Payouts:** Summary cards + payout history DataTable / card list
- **Notifications:** Full list with read/unread state, mark all read

---

## 7. HTML → React Conversion Guidelines

The HTML mockups are the **source of truth for layout and visual structure only**.

### What to trust
- Layout (sidebars, grids, card vs table breakpoints, wizard steppers)
- Visual hierarchy (spacing, typography scale, color tokens)
- Responsive behavior (breakpoints, stacking, drawer transitions)
- Interactions (hover states, filter tabs, status badges, upload zones)

### What NOT to blindly copy
- **Field names** — HTML shows display labels. Always map to TypeScript interface field names.
- **Static/demo data** — never hardcode. All values from Firebase.
- **Extra HTML fields** — if an HTML field has no schema equivalent, flag it and ask.

### CSS token mapping (HTML → Tailwind)

| HTML CSS var | Tailwind class | Hex |
|-------------|---------------|-----|
| `--bg-deep` | `bg-zinc-950` | `#09090B` |
| `--bg-surface` | `bg-zinc-900` | `#18181B` |
| `--text-primary` | `text-zinc-50` | `#FAFAFA` |
| `--text-secondary` | `text-zinc-400` | `#A1A1AA` |
| `--text-tertiary` | `text-zinc-600` | `#52525B` |
| `--primary` | `text-indigo-500` / `bg-indigo-500` | `#6366F1` |
| `--primary-gradient` | `bg-gradient-to-br from-indigo-500 to-violet-500` | |
| `--border-subtle` | `border-white/[0.06]` | |
| `--border-glass` | `border-white/10` | |
| `--surface-hover` | `hover:bg-white/5` | |

---

## 8. Auth & Route Protection

### middleware.ts
```ts
// Protect all /dashboard/* and /admin/* routes
// Redirect unauthenticated to /login
// Redirect non-agency to /login
// Redirect non-admin to /dashboard

export const config = {
  matcher: ['/(dashboard|admin)/:path*']
}
```

### AuthContext
```ts
// lib/auth-context.tsx
// Provides: user (AppUser | null), agency (Agency | null), loading
// Watches: onAuthStateChanged → reads users/{uid} → reads agencies/{agencyId}
// Used throughout the app for auth-gated data
```

---

## 9. Phased Roadmap

### Phase 1: Foundation & Auth ← START HERE
- [ ] Create Next.js 14 project with TypeScript + Tailwind
- [ ] Configure Firebase (`lib/firebase.ts`) — same project as Flutter app
- [ ] Create TypeScript types (`lib/types.ts`)
- [ ] Build AuthContext with `onAuthStateChanged` + user + agency fetch
- [ ] Build `middleware.ts` for route protection
- [ ] Build Agency Login page (`00_agency_login.html` → React)
- [ ] Build `/auth` token handoff page (for Flutter redirect)
- [ ] **Checkpoint:** Login works. Protected routes redirect correctly.

### Phase 2: Shell
- [ ] Build `DashboardSidebar` (from `03_agency_dashboard.html` sidebar)
- [ ] Build `DashboardTopbar` (greeting, bell, avatar)
- [ ] Build `AgencyShell` (LayoutBuilder: permanent sidebar ≥900px / drawer <900px)
- [ ] Build placeholder pages for all 5 nav routes
- [ ] **Checkpoint:** Sidebar ↔ drawer transitions. All nav items route correctly.

### Phase 3: Agency Home Screen
- [ ] Build `StatsCard` component (from `03` HTML stats grid)
- [ ] Implement Firestore queries: `watchAgency()`, `getTripsByAgency(limit 5)`, `getBookingsForAgency(limit 5)`
- [ ] Convert `03_agency_dashboard.html` content area → React
- [ ] **Checkpoint:** Real stats, recent trips, recent bookings from Firestore.

### Phase 4: Trip Management
- [ ] Add Firestore methods: `createTrip()`, `updateTrip()`, `deleteDraft()`
- [ ] Convert `04_agency_trips.html` → TanStack DataTable + mobile card list
- [ ] Build 6-step Add Trip wizard from `05_agency_add_trip.html`
- [ ] **Checkpoint:** Create trip → appears in consumer Flutter app Explore feed.

### Phase 5: Booking Management
- [ ] Add Firestore methods: `getBookingsForAgency()`, `getBookingsForTrip()`
- [ ] Convert `06_agency_bookings.html` → TanStack DataTable + mobile cards
- [ ] Build booking detail drawer/page
- [ ] **Checkpoint:** Agency views and filters all bookings.

### Phase 6: Profile, Settings, Payouts, Messages
- [ ] Agency Profile page (edit form with logo/cover upload)
- [ ] Settings page (security, bank, notifications, danger zone)
- [ ] Payouts page (summary cards + payout history)
- [ ] Messages page (2-pane chat, reuses Firestore RTDB)

### Phase 7: Superadmin
- [ ] Admin shell + home screen
- [ ] Admin agencies queue (Pending/Approved/Rejected tabs)
- [ ] Admin agency detail + approve/reject actions
