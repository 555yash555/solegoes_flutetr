# Project Rules

> If a task contradicts these rules, prompt the user: **Update Rule** vs **Follow Exception**.

---

## 1. Theming (Zero Hardcoding)

- **All colors** via `AppColors.*` — never hex literals in widgets
- **All text styles** via `AppTextStyles.*` — never raw `TextStyle()` in widgets
- **Override with `.copyWith()`** — don't create one-off styles
- **Check `app_theme.dart` first** before adding any new token
- Full token reference: `context/THEME_SYSTEM_GUIDE.md`

## 2. Architecture

- **Feature-First** folders: `features/{name}/domain/`, `data/`, `presentation/`
- **Riverpod 2.0** with `@riverpod` generator annotations for new providers
- **GoRouter** for navigation — use `context.push`, `context.go`
- **Repository Pattern** — UI never talks to Firebase directly
- **Freezed** for domain models — immutable, JSON-serializable
- Full patterns: `context/ARCHITECTURE_GUIDE.md`

## 3. Widget Reuse

- **Reuse > Create** — scan `common_widgets/` and `AppTheme` before making anything new
- **90% Rule** — if existing widget is ~90% similar, extend/configure it. Don't duplicate.
- **Prompt before deviating** — if a variation breaks the design system, ask the user first

## 4. Error Handling

- Repositories catch `FirebaseException` → return user-friendly strings
- General catch → `"Something went wrong"`
- Use `AppException.fromError()` to wrap errors
- Use `AppSnackbar.showError()` for display
- Use `AsyncValueUI.showSnackbarOnError()` extension in screens
- Controllers set state to `AsyncError` — global listener reacts

## 5. Fault Tolerance

- **Loading** — never blank screens. Use `AppShimmer` / skeleton widgets matching final layout.
- **Empty states** — always handle empty lists (`"No trips found"`)
- **Images** — use `AppImage` which handles loading/error placeholders

## 6. Data & Schema

- **Reference** `seed_lite.dart` for current Firestore field structures
- **Full schema** in `context/database_schema.md`
- **New collections** — prompt the user to confirm schema before implementing
- **Nested objects** — use dedicated sub-classes (e.g., `TripStyle`, `TripPoint`), don't dump into one class

## 7. Code Quality

- No unused imports, `const` constructors where possible
- Run `build_runner` after changing `@riverpod` / `@freezed` files
- Firestore writes use `SetOptions(merge: true)` to avoid overwrites

---
*Last Updated: 2026-02-02*
