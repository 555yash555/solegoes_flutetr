# Pending Agency Screens & Features

An analysis of the newly created HTML mockups (`01_agency_signup` through `06_agency_bookings`) alongside the `AGENCY_WEB_APP_PLAN.md` has identified several call-to-action (CTA) buttons and functional areas that currently point to missing screens or unimplemented features. 

You can use this document to update your `AGENCY_WEB_APP_PLAN.md` and define the next set of mockups.

## 1. Messages / Chat Hub
*   **CTA Locations:** 
    *   Sidebar Navigation (`Messages` item with `href="#"` in Dashboard, Trips, and Bookings screens).
*   **Missing Implementation:** 
    *   A dedicated `agency_messages.html` or `agency_trip_chat.html` screen.
    *   **Purpose:** To allow agencies to communicate with travelers in trip-specific group chats or reply to direct inquiries.

## 2. Notifications Center
*   **CTA Locations:** 
    *   Topbar bell icon (`<i data-lucide="bell"></i>`) found across `03_agency_dashboard`, `04_agency_trips`, and `06_agency_bookings`.
*   **Missing Implementation:** 
    *   Either a popover dropdown panel or a dedicated `agency_notifications.html` screen.
    *   **Purpose:** To inform the agency of new bookings, application status changes, pending payouts, or unread messages.

## 3. Trip Details Viewer
*   **CTA Locations:** 
    *   The "View Details" button (`<i data-lucide="more-horizontal"></i>`) inside the data table rows of `04_agency_trips.html`.
*   **Missing Implementation:** 
    *   `agency_trip_details.html` (distinct from `05_agency_add_trip.html` which is for editing/creation).
    *   **Purpose:** A read-only analytical view of a single trip, showcasing conversion rates, a dedicated list of bookings for just that trip, revenue generated, and live itinerary details.

## 4. Specific Booking Details
*   **CTA Locations:** 
    *   The "View Details" buttons found inside the data table/mobile cards of the newly created `06_agency_bookings.html`.
*   **Missing Implementation:** 
    *   A slide-out drawer or a standalone `agency_booking_detail.html` screen.
    *   **Purpose:** To manage a specific traveler's reservation (e.g., process refunds, view specialized package requests, cancel booking, or view contact info).

## 5. Agency Profile & Settings
*   **CTA Locations:** 
    *   Currently vaguely represented by the Agency Logo/Name area in the sidebar/topbar. *(Note: Needs explicit sidebar links for "Profile" and "Settings")*.
*   **Missing Implementation:** 
    *   `agency_profile.html` and `agency_settings.html`.
    *   **Purpose:** To update the public-facing agency profile (cover image, description), manage team members, change password, or update banking/GST details submitted during signup.

## 6. Payouts & Financials
*   **CTA Locations:** 
    *   Implicitly required, but entirely missing from the current sidebar mockups. 
*   **Missing Implementation:** 
    *   `agency_payouts.html`
    *   **Purpose:** A ledger screen detailing total revenue, pending platform payouts, platform fee deductions, and withdrawal history. **Recommendation:** Add a "Finances" or "Payouts" link to the sidebar under the "Manage" section.

## 7. External Support Links
*   **CTA Locations:** 
    *   "WhatsApp" contact button in `02_agency_pending.html` (`href="#"`).
*   **Missing Implementation:** 
    *   Needs to be hard-linked to a `wa.me` URL for the SoleGoes partner success team.

---
### Next Steps Recommendation
To maintain feature parity for the Flutter development phase, consider designing `07_agency_messages.html`, `08_agency_profile.html`, and `09_agency_payouts.html`, and updating `AGENCY_WEB_APP_PLAN.md` to map out their respective Flutter screen equivalents (e.g. `AgencySettingsScreen`, `AgencyPayoutsScreen`).
