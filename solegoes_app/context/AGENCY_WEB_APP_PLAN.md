# Agency & Superadmin Web App Plan

## 📋 Executive Summary
This document outlines the implementation plan for the **Agency and Superadmin Web Application** within the existing `solegoes_app` Flutter codebase. The goal is to provide a robust, responsive, and aesthetically consistent dashboard for travel agencies to manage their business and for superadmins to oversee the platform.

**Core Philosophy:**
*   **One Codebase:** Reuse 80% of logic (Models, Repositories, Auth).
*   **Feature-First:** New features live in their own modular folders.
*   **Responsive Desktop:** Not a stretched mobile app; a dedicated sidebar layout.
*   **Subtle Premium:** Strict adherence to `AppTheme` (Zinc colors) and `Plus Jakarta Sans`.

---

## 🛠 Functional Requirements

### 1. Unified Authentication & Roles
*   **Single Entry:** agencies and admins log in via the standard Login screen.
*   **Role-Based Access Control (RBAC):**
    *   `UserRole.consumer`: Redirects to Home (Mobile View).
    *   `UserRole.agency`: Redirects to Agency Dashboard.
    *   `UserRole.superAdmin`: Redirects to Admin Dashboard.
*   **Registration:** Self-serve Agency Signup with "Pending Verification" state.

### 2. Agency Dashboard (Web/Desktop)
*   **Stats Overview:** Revenue, Active Bookings, Total Trips, Rating.
*   **Trip Management:**
    *   **Create Trip:** A multi-step "Wizard" form handling:
        *   Basic Info (Title, Location, Category).
        *   Media (Multiple Image Uploads).
        *   **Pricing Styles:** Dynamic addition of Budget/Standard/Premium tiers.
        *   Itinerary: Day-wise breakdown.
        *   Boarding/Dropping Points: Location & Time selection.
    *   **View Trips:** Data table with status (Live, Draft, Ended).
*   **Booking Management:**
    *   View all bookings with filters (Upcoming, Completed).
    *   Status is "Auto-Confirmed" upon payment.
*   **Profile Management:** Edit Logo, Cover Image, Description, Specialties.

### 3. Superadmin Dashboard
*   **Agency Verification:** View list of "Pending" agencies. Review documents (GST, etc.) and Approve/Reject.
*   **Platform Stats:** Global Revenue, Total Users, Active Agencies.

---

## 🏗 Architecture & Best Practices

### 1. Feature-First Structure
We will add two new top-level feature folders:
```
lib/src/features/
├── agency_dashboard/          <-- NEW
│   ├── domain/               <-- Dashboard specific models (if any)
│   ├── data/                 <-- Dashboard specific repos
│   └── presentation/
│       ├── components/       <-- Modular widgets (Sidebar, StatsCard)
│       └── screens/          <-- The actual pages
├── admin_dashboard/           <-- NEW
└── ... (existing features)
```

### 2. Responsive UI Strategy (Native Feel)
*   **ShellRoute Pattern:** Use `GoRouter` 's `ShellRoute` to wrap all agency pages in a `DashboardScaffold` (Sidebar + Topbar + Content Area).
*   **Unified Layout Widget (`DashboardScaffold`):**
    *   **Desktop (> 900px):** 
        *   Permanent Sidebar (280px width) on the left.
        *   **Cursor Interactions:** Hover effects on cards, rows, and buttons (`AppColors.surfaceHover`).
        *   **Scrollbars:** Visible, styled scrollbars for tables.
    *   **Tablet/Phone (< 900px):** 
        *   **Navigation:** Bottom Navigation Bar (instead of Drawer) for primary dashboard tabs (Home, Trips, Bookings, Profile) to feel fast and native.
        *   **Touch Targets:** Minimum 44px tap targets.
        *   **Gestures:** Swipe-to-refresh on lists, swipe-to-dismiss on cards.
        *   **Modals:** Use `showModalBottomSheet` on mobile vs `Dialog` on desktop.
    *   **Content Area:** 
        *   Uses `Center(child: ConstrainedBox(maxWidth: 1200))` to prevent stretching on huge monitors.
        *   Padding adjusts: `24px` on Desktop, `16px` on Phone.
*   **Design Tokens:**
    *   **Colors:** strict use of `AppColors.bgDeep`, `AppColors.bgSurface`, `AppColors.primary`.
    *   **Text:** `AppTextStyles.h3` for page titles, `AppTextStyles.body` for table content.
    *   **Input:** Reuse `AppTextField` and `PrimaryButton`.

### 3. Global Error & State Handling
*   **AsyncValueUI:** Continue using `ref.listen` with `AsyncValueUI` extension for standardized error snackbars.
*   **Loading States:** Use `AppLoadingIndicator` overlay for async operations (e.g., creating a trip).

---

## 🗄 Database Schema (Strict Compliance)

We must adhere strictly to the JSON structure defined in `seed_lite.dart` (which mirrors the master `seed_trips_screen.dart`).

### Agency Model Updates
*   **Collection:** `agencies`
*   **Fields:**
    *   `verificationStatus`: 'pending' | 'approved' | 'rejected'
    *   `documents`: Map of URLs (GST, Portfolio).
    *   `stats`: Nested object for quick read access.
    *(See `seed_lite.dart` for full JSON)*

### Trip Model Updates (Crucial)
*   **Collection:** `trips`
*   **Pricing Styles Array:**
    ```json
    "pricingStyles": [
      {
        "styleId": "budget",
        "name": "Budget Explorer",
        "price": 38000,
        "accommodationType": "sharing-3",
        "mealOptions": ["veg"],
        "inclusions": ["..."]
      }
    ]
    ```
    *(See `seed_lite.dart` for full pricing style options)*
    *The "Add Trip" form must strictly generate this JSON structure.*

---

## 🛣 Phased Implementation Roadmap

### Phase 1: Foundation & Auth (Priority: HIGH)
*   **Goal:** Secure routing and model preparation.
*   **Steps:**
    1.  Update `AppUser` with `role` and `agencyId`.
    2.  Create `Agency` domain model (Freezed) matching seed data.
    3.  Implement `AgencyRepository` (fetch by ID, create pending).
    4.  Configure `GoRouter` with `DashboardShell` and Role Guards.
*   **Checkpoint:** Login as "Agency User" -> Redirect to empty Dashboard Shell.

### Phase 2: Agency Dashboard Core (Priority: HIGH)
*   **Goal:** A working home for agencies.
*   **Steps:**
    1.  **Dashboard Layout:** Build `DashboardScaffold` with adaptive Sidebar.
    2.  **Stats UI:** Create `StatsCard` widget using `AppColors.bgCard`.
    3.  **Profile Page:** Form to edit Agency public details.
*   **Checkpoint:** Agency can log in, see a sidebar, and view their mocked stats.

### Phase 3: The "Add Trip" Wizard (Priority: CRITICAL)
*   **Goal:** The core business function.
*   **Steps:**
    1.  **Step 1 Basic Info:** Title, Description, Duration, Category.
    2.  **Step 2 Media:** Drag-and-drop image uploader (Firebase Storage).
    3.  **Step 3 Pricing Styles:** Complex dynamic form to add/remove Styles. **Strict Schema Check.**
    4.  **Step 4 Logistics:** Itinerary & Boarding Points.
    5.  **Review & Submit:** Shows summary before writing to Firestore.
*   **Checkpoint:** Successfully create a Trip that appears correctly in the Mobile App "Explore" feed.

### Phase 4: Superadmin & Polish (Priority: MEDIUM)
*   **Goal:** Platform management.
*   **Steps:**
    1.  **Admin Layout:** Reused Dashboard Shell with Admin menu.
    2.  **Agency Approvals:** List view of pending agencies -> "Approve" Action.
    3.  **Global Stats:** Aggregate counts.
*   **Checkpoint:** Admin can approve a new agency, allowing them to log in.

---

## rules for AI Assistant (Me)
1.  **Do not invent new colors.** Use `AppColors`.
2.  **Do not create new button styles.** Use `PrimaryButton` and `SecondaryButton`.
3.  **Always validate JSON.** When writing Trip creation logic, cross-reference `seed_trips_screen.dart`.
4.  **Keep it Modular.** Put the Trip Wizard logic in its own sub-feature folder `agency_dashboard/presentation/trip_wizard/`.

---

## 🎨 Design Guide & Principles

### 1. Color Palette (Zinc & Indigo)
We strictly adhere to the `AppTheme` palette. Start with **Dark Mode** first.
-   **Backgrounds:**
    -   `AppColors.bgDeep` (`#09090B`): Main page background.
    -   `AppColors.bgSurface` (`#18181B`): Secondary background (Sidebars).
    -   `AppColors.bgCard` (`#111111`): Cards and Containers.
-   **Accents:**
    -   `AppColors.primary` (`#6366F1`): Primary actions (Buttons, Active States).
    -   `AppColors.violet` (`#8B5CF6`): Secondary accents (Gradient start/end).
    -   `AppColors.success` (`#10B981`) / `AppColors.error` (`#EF4444`): Status indicators.
-   **Typography:**
    -   `AppColors.textPrimary` (`#FAFAFA`): Headings, Main text.
    -   `AppColors.textSecondary` (`#A1A1AA`): Subtitles, Metadata.
    -   `AppColors.textTertiary` (`#52525B`): Icons, Borders.

### 2. Typography (Plus Jakarta Sans)
-   **Headings (`h1`, `h2`, `h3`):** Bold weights (700/800). Use for page titles and section headers.
-   **Body:** Medium weights (400/500). Readability is key for tables.
-   **Monospace:** Use for IDs (e.g., Booking ID: `#BKG-1234`).

### 3. Core UI Patterns

#### A. The Glassmorphic Sidebar
The Agency Dashboard uses a permanent vertical sidebar on Desktop.
*   **Style:** `AppColors.bgSurface` with a subtle right border (`AppColors.borderSubtle`).
*   **Navigation:**
    *   **Active Item:** `AppColors.primary` (10% opacity) background + `AppColors.primary` text/icon.
    *   **Inactive Item:** `AppColors.textSecondary` text/icon + Hover effect (`AppColors.surfaceHover`).

#### B. Data Cards (Stats)
Used for displaying "Total Revenue", "Active Bookings".
*   **Background:** `AppColors.bgCard`.
*   **Border:** `Border.all(color: AppColors.borderSubtle, width: 1)`.
*   **Radius:** `AppRadius.md` (16px).
*   **Padding:** `padding: EdgeInsets.all(24)`.
*   **Shadow:** None (Flat design) or `AppShadows.sm` for hover state.

#### C. Data Tables (Lists)
Used for Trip List and Booking List.
*   **Header Row:**
    *   Background: `AppColors.bgSurface`.
    *   Text: `AppTextStyles.labelSmall` (Slightly muted, UPPERCASE).
*   **Data Rows:**
    *   Hover Effect: Change background to `AppColors.surfaceHover`.
    *   Separators: `Divider(color: AppColors.divider)`.
*   **Status Badges:** Use `AppBadge` pattern (Glass container + color dot + text).

#### D. Interactive Elements
*   **Buttons:**
    *   **Primary:** `AppButtonVariant.primary` (Solid Indigo).
    *   **Secondary:** `AppButtonVariant.outline` (Border only).
    *   **Ghost:** Transparent background, text only (for Table Actions).
*   **Inputs:**
    *   Standard `AppTextField`: Filled with `AppColors.bgGlassLight`, Border `AppColors.borderSubtle`.
    *   Focus State: `AppColors.primary` border ring.

### 4. Layout Principles
*   **Container Width:** Max-width `1200px` for the content area to prevent "stretching" on huge monitors. Center the content if necessary.
*   **Grid System:**
    *   **Dashboard Home:** 4-column grid for Stats.
    *   **Trips List:** 3-column grid for Cards (if showing cards) or 1-column Table.
*   **Whitespace:** Be generous. Use `gap: 24` or `gap: 32` between sections.
