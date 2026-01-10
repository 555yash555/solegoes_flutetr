# SoleGoes - Project Idea

## Overview
SoleGoes is a comprehensive travel aggregation and agency management platform designed to modernize the travel booking experience. It bridges the gap between travelers seeking curated, personalized experiences and travel agencies looking for a streamlined way to manage their business and reach customers.

## Core Value Proposition
- **For Travelers:** A "Subtle Premium" experience to discover trips, get AI-powered recommendations based on interests (Vector Search), and book seamless adventures.
- **For Agencies:** A powerful dashboard to manage trips, track bookings, handle payments, and analytics.
- **For Admins:** Robust oversight tools to verify agencies and approve trips.

## Key Features

### 1. Smart Exploration & AI
- **Vector-Based Recommendations:** Matches travelers to trips based on their `travelStyle`, `budget`, and specific interests (e.g., "hiking", "beaches") using Firestore Vector Search.
- **Interactive Explore UI:** Swipeable or grid-based exploration of curated trips.

### 2. Agency Empowerment
- **Agency Signup & Verification:** Strict oneness/verification flow (GST, Aadhaar) to ensure trust.
- **Dashboard:** Real-time stats on revenue and bookings.
- **Trip Management:** Detailed trip creation with itineraries, inclusions, and photos.

### 3. Community & Social
- **Group Chats:** Automatically added to trip-specific group chats upon booking.
- **Direct Messaging:** Communication between users and agencies.

### 4. Booking & Payments
- **Single Verified Payment Source:** A unified, secure payment gateway acting as the sole trusted intermediary for all transactions, regardless of the agency.
- **Multiple Payment Options:** Supports diverse methods (UPI, Credit/Debit Cards, Netbanking, Wallets) within the verified gateway to ensure user convenience.
- **Booking Management:** Track status from "Pending" to "Confirmed" to "Completed".

## User Roles
- **Customer:** Browses, chats, books.
- **Agency:** Creates trips, manages bookings, verifies business.
- **Admin:** Oversees platform, approves agencies/trips.

## Technical Architecture
- **Frontend:** HTML/Tailwind/JS (Current Design Phase).
- **Backend/Database:** Google Firestore (NoSQL).
- **Authentication:** Firebase Auth.
- **Search:** Firestore Vector Search.
