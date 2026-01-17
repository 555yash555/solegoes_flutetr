# SoleGoes App Architecture Guide

This guide summarizes the architectural patterns, state management concepts, and best practices used in the SoleGoes Flutter application.

## 1. High-Level Architecture

The app uses a **Feature-First, Layered Architecture**.
Instead of organizing by file type (controllers/, views/), we organize by **Business Feature**.

### Folder Structure
```
lib/src/features/
├── authentication/      <-- Feature Name
│   ├── domain/          <-- Data Models (Pure Dart)
│   ├── data/            <-- Repositories (Talk to Firebase/API)
│   └── presentation/    <-- UI Screens + Logic Controllers
├── trips/
├── bookings/
└── ...
```

---

## 2. The Three Layers (The "Cake")

### Layer 1: Domain (The "Shape")
*   **Purpose:** Define *what* data looks like. No logic, no Firebase.
*   **Key Tech:** `Freezed` (Immutable models).
*   **Example:** `AppUser`, `Trip`.
*   **Why:** Prevents bugs caused by mutable state. You cannot accidentally change `user.email`; you must create a copy.

### Layer 2: Data (The "Workhorse")
*   **Purpose:** Talk to the outside world (Firestore, APIs, Device).
*   **Key Concept:** **Repository Pattern**.
    *   The UI never talks to Firebase directly.
    *   It asks the Repository for "Domain Objects" (e.g., `List<Trip>`), not "Firestore Documents".
*   **Example:** `AuthRepository`, `TripRepository`.

### Layer 3: Presentation (The "Brain" & "Face")
*   **Purpose:** Manage state and draw pixels.
*   **Key Tech:** **Riverpod Controllers** + **Widgets**.
*   **Logic:** Controllers hold `state` (`AsyncValue`).
*   **UI:** Widgets `watch` the state to redraw and `listen` to state for side effects.

---

## 3. Riverpod Concepts

### The "Remote Control" (`ref`)
`ref` is the tool that lets any object talk to any other object in the Provider Container.

1.  **`ref.read(provider)`**: **"Get it once."**
    *   Use inside functions or button callbacks.
    *   *Example:* `ref.read(authController).login()`
2.  **`ref.watch(provider)`**: **"Get it & keep watching."**
    *   Use inside `build()` methods.
    *   *Example:* `final user = ref.watch(userProvider);` (Rebuilds if user changes).
3.  **`ref.listen(provider, callback)`**: **"Poke me if it changes."**
    *   Use for side effects (Snackbars, Dialogs, Navigation).
    *   *Example:* If error state appears -> Show Snackbar.

### Handling Async Data (`AsyncValue`)
Riverpod wrappers `Future`s in an `AsyncValue` to track their lifecycle for the UI.

**The Declarative UI Pattern:**
```dart
final tripsAsync = ref.watch(tripsProvider);

return tripsAsync.when(
  data: (trips) => ListView(children: ...),
  loading: () => CircularProgressIndicator(),
  error: (err, stack) => Text('Error: $err'),
);
```

**The Action Pattern (Double Bookkeeping):**
Controllers often manage two values simultaneously:
1.  **Public State (`AsyncValue`):** For spinners/errors.
2.  **Function Return (`Future<bool>`):** For the specific button click to know if it succeeded (routing logic).

---

## 4. Code Generation (`@riverpod`)
We use `riverpod_generator` to write the boilerplate wiring.

*   **Syntax:**
    ```dart
    @riverpod
    class MyController extends _$MyController { ... }
    ```
*   **Benefit:** Automatic type safety, automatic dependency injection, and automatic disposal (`AutoDispose`) when screens are closed.

---

## 5. Specific Feature Patterns

### Authentication
*   **Flow:** Button -> Controller -> Repository -> Firebase -> Repository (returns User) -> Controller (updates State) -> UI (redraws).
*   **Guard:** `AsyncValue.guard(() => repo.doWork())` automatically catches errors and sets the state to `AsyncError`.

### Trips (Lists & Reading)
*   **Family Providers:** `ref.watch(tripProvider(tripId))` caches each trip individually. If you revisit a trip, it loads instantly.

### Bookings (Relationships)
*   **Denormalization:** We copy Trip details (Title, Image) into the Booking document.
*   **Reason:** Performance (fewer reads) and History (receipts shouldn't change if the trip changes later).

### Payments (External SDKs)
*   **Wrapper Pattern:** Wrap 3rd party SDKs (Razorpay) in a Service class.
*   **Provider-izing Services:** Even simple classes should be Providers so we can:
    1.  Test them (mocking).
    2.  Manage their lifecycle (auto-dispose listeners).

---

## 6. Key Files Guide

*   `main.dart`: App entry, Theme setup.
*   `lib/src/routing/app_router.dart`: **GoRouter** configuration. Centralized redirection logic (Auth Guards).
*   `lib/src/utils/async_value_ui.dart`: Extension to show standard Snackbars from `AsyncValue` errors.
*   `lib/src/common_widgets/`: Reusable UI components (Buttons, Inputs) that follow the design system.
