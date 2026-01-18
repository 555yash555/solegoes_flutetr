# Project Rules & Guidelines

> **Note:** This document is maintained by the AI Agent. The user will be prompted if updates are required.

## 1. Project Maintenance
*   **Living Document:** This file (`rule.md`) serves as the single source of truth for coding standards, architecture, and design principles.
*   **Updates:** Any significant pattern change or new convention must be documented here.
*   **Prompting:** If a requested task contradicts these rules, the Agent must prompt the User for a decision (Update Rule vs. Follow Exception).

## 2. UI & Theme System
All UI components must strictly adhere to `lib/src/theme/app_theme.dart`.

### Colors (`AppColors`)
*   **Backgrounds:** `bgDeep` (Main), `bgSurface` (Cards/Containers), `bgGlass` (Blur effects).
*   **Text:** `textPrimary` (Headings), `textSecondary` (Body), `textTertiary` (Captions/Icons).
*   **Accents:** `primary` (Actions/Highlights), `error`, `success`.
### Strict Theming Rule 🚫
*   **No Hardcoded Values:** Colors, text styles, and recurring string constants MUST NOT be hardcoded in screen widgets.
*   **Theme First:** All styles must be defined in `AppTheme` / `AppColors` / `AppTextStyles`.
*   **Usage:** Use valid variable names (e.g., `AppColors.primary`, `AppTextStyles.body`).
*   **Goal:** Single-source-of-truth for theming to allow global updates.

### Typography (`AppTextStyles`)
*   **Headings:** `h1`, `h2`, `h3` (Plus Jakarta Sans).
*   **Body:** `bodyLarge`, `body`, `bodySmall`.
*   **Actions:** `button`, `link`.

### Common Widgets (`lib/src/common_widgets`)
*   **Buttons:** `AppButton` (Primary/Secondary variants).
*   **Inputs:** `AppTextField` (Standard styles, focus states).
*   **Cards:** `AppCard` (Standard border/radius), `TripCard` (Complex trip display).
*   **Feedback:** `AppSnackbar` (Toast messages), `AppShimmer` (Loading states).
*   **Images:** `AppImage` (Centralized image handling with network/asset support).

## 3. Modularity & Architecture
The project follows a **Feature-First Architecture** with Riverpod 2.0.

### Structure
*   `lib/src/features/[feature_name]/`
    *   `data/`: Repositories, Data Sources.
    *   `domain/`: Models (Entities).
    *   `presentation/`: Widgets, Controllers (Providers), Screens.

### Widget Modularity
*   **Atomic Design:** Build small, responsive, reusable widgets first (e.g., `CategoryPill`, `TripCard`).
*   **Composition:** Assemble screens using these atomic widgets.
*   **Responsiveness:** Use `Flexible`, `Expanded`, and strict layout constraints to prevent overflows (e.g., `SizedBox` wrapping lists).

## 4. Global Error Handling
Errors should be captured and displayed uniformly to ensuring a fault-tolerant user experience.

### Implementation
*   **Listener:** `AppErrorListener` (in `common_widgets`) watches `globalErrorProvider`.
*   **Display:** Errors are shown using `AppSnackbar.showError()`.
*   **Mechanism:**
    1.  Repositories catch low-level exceptions (Firebase, API).
    2.  Exceptions are mapped to user-friendly messages (e.g., "Network Error" -> "Please check your internet").
    3.  Controllers/Providers set the state to `AsyncError`.
    4.  Top-level widgets or the global listener react to these errors.

### Mapping Rule
*   **FirebaseAuth/Firestore:** Catch `FirebaseException` and return readable strings.
*   **General:** Catch `Exception` and default to "Something went wrong".

## 5. Fault Tolerance & User Experience
*   **Loading:** NEVER show a blank screen. Use `AppShimmer` or `Skeleton` widgets (e.g., `TripCardSkeleton`) matching the final layout.
*   **Empty States:** Always provide handling for empty lists (e.g., "No trips found").
*   **Images:** Use `AppImage` which handles loading/error placeholders automatically.

## 6. Development Workflow
*   **New Widgets (Reuse > Create):**
    *   **Check First:** Always scan `common_widgets` and `AppTheme`.
    *   **90% Rule:** If an existing widget is ~90% similar, **REUSE it** (extend or configure). DO NOT duplicate.
    *   **Variation Prompt:** If a specific variation is needed that deviates from the design system, **PROMPT THE USER** for a decision before creating a new widget.
*   **Code Quality:**
    *   **Linting:** No unused imports, const constructors where possible.
    *   **Riverpod:** Use `@riverpod` annotations (Generator) for new providers.
    *   **Navigation:** Use `GoRouter` context extensions (`context.push`, `context.go`).

## 7. Architecture Consistency
*   **State Management:** Riverpod 2.0 (Generator pattern preferred).
*   **Navigation:** GoRouter.
*   **Data Layer:** Repositories Pattern (Abstract interface + Implementation).
*   **Model Layer:** Immutable data classes (Freezed preferred, or strict conventions).

---
*Last Updated: 2026-01-18*
