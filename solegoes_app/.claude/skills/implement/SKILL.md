---
name: implement
description: Load all SoleGoes project rules and guidelines before implementing any code changes. Use this before writing Flutter code, fixing tech debt, or building new features.
allowed-tools: Read, Grep, Glob, Bash, Write, Edit
argument-hint: [what to implement]
---

# SoleGoes Implementation Context

Before writing any code, read and follow all rules below.

---

## Branding & Identity

!`cat context/branding.md 2>/dev/null || echo "branding.md not found"`

---

## Theme Tokens (source of truth)

!`head -150 lib/src/theme/app_theme.dart 2>/dev/null || echo "app_theme.dart not found"`

---

## Common Widgets Available

!`ls lib/src/common_widgets/*.dart 2>/dev/null | while read f; do basename "$f" .dart; done || echo "No common widgets found"`

---

## Database Schema

!`cat context/database_schema.md 2>/dev/null || echo "No database schema"`

---

## Strict Rules

### Colors
- NEVER use hardcoded hex (`Color(0xFF...)`), `Colors.xxx`, or raw color values in screens.
- Always use `AppColors` tokens from `app_theme.dart`.
- If a color you need doesn't exist in `AppColors`, **add it** to `app_theme.dart` first, then use it.

### Text Styles
- NEVER use inline `TextStyle(fontSize: ..., fontWeight: ...)` in screens.
- Always use `AppTextStyles` tokens, with `.copyWith()` for overrides.
- If a text style you need doesn't exist, **add it** to `AppTextStyles` in `app_theme.dart` first.

### Buttons
- Use `AppButton` (variants: primary, secondary, outline, text, destructive, ghost).
- Never use raw `ElevatedButton`, `TextButton`, `OutlinedButton`.
- If a variant you need doesn't exist, **add it** to `AppButton` first.

### Text Fields
- Use `AppTextField` for all inputs.
- Never create private `_buildTextField()` helpers that duplicate AppTextField.
- If AppTextField is missing a param you need (e.g., maxLines, label), **add it** first.

### Images
- Use `AppImage` (wraps CachedNetworkImage with shimmer loading + error placeholder).
- Never use raw `Image.network()`.

### Snackbars
- Use `AppSnackbar.showError/showSuccess/showInfo()`.
- Never use raw `ScaffoldMessenger.showSnackBar()`.

### Loading States
- Use `AppShimmer` skeleton layouts for content loading (full-page `.when(loading:)` states).
- Use `AppButton(isLoading: true)` or `BottomActionButton(isLoading: true)` for button loading.
- Only use `CircularProgressIndicator` for splash screen or dialog overlays.

### Icons
- Use `lucide_icons` package for all screen icons.
- Never use Material `Icons.xxx` in consumer/agency screens (admin/seed screens excepted).

### Reusable Widgets
- Use `CircularIconButton` for circular icon buttons (back buttons, action buttons).
- Use `BottomActionButton` for gradient bottom CTAs with loading state.
- Use `AppConfirmDialog` for confirmation dialogs.
- Never hand-roll these patterns — if the widget doesn't exist yet, **create it** in `common_widgets/`.

### Error Handling
- Wrap Firebase errors with `AppException.fromError()`.
- Show user feedback via `AppSnackbar`.
- Use `AsyncValueUI.showSnackbarOnError()` extension in screens.
- Never use `print()` or `debugPrint()` in presentation layer.

### Spacing & Layout
- Use `AppSpacing` constants (xs, sm, md, lg, xl). Minimize magic numbers.
- Use `AppRadius` constants (sm, md, lg, full).
- Plus Jakarta Sans is configured globally — never set `fontFamily` manually.

### State Management
- Riverpod with `@riverpod` annotations and code generation.
- Controllers stay thin — business logic lives in repositories.
- Run `dart run build_runner build --delete-conflicting-outputs` after adding/changing `@riverpod` or `@freezed` annotations.

### Responsive Design
- Use `LayoutBuilder` for adaptive layouts — build separate widget trees per breakpoint, not just padding changes.
- Breakpoints: mobile (<600px), tablet (600-900px), desktop (>900px).
- Content grids should reflow at any width, not just at breakpoint boundaries.

### Verification
- Run `flutter analyze` after making changes — fix all warnings/errors before considering the task done.
- Never run the app without passing `flutter analyze` first.

### General
- Dark theme only — no light theme variants.
- Always use `SafeArea` for screens with custom backgrounds.
- Always use `AppColors.bgDeep` as scaffold background.

---

## Task

$ARGUMENTS
