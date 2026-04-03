---
name: implement
description: Load all SoleGoes agency dashboard rules and context before implementing any code. Use this before writing any React/Next.js code, fixing bugs, or building new features for the agency dashboard.
allowed-tools: Read, Grep, Glob, Bash, Write, Edit
argument-hint: [what to implement]
---

# SoleGoes Agency Dashboard — Implementation Context

Before writing any code, read and follow all rules below.

---

## Design System (source of truth — replaces app_theme.dart)

!`cat context/design_system.md 2>/dev/null || echo "design_system.md not found"`

---

## Database Schema

!`cat context/database_schema.md 2>/dev/null || echo "database_schema.md not found"`

---

## HTML Mockups Available

!`ls design_mockups/*.html 2>/dev/null | while read f; do basename "$f"; done || echo "No mockups found"`

---

## Implementation Tracker (check what's done before starting)

!`cat context/agency_implementation_tracker.md 2>/dev/null || echo "tracker not found"`

---

## Strict Rules

### Colors & Styling
- NEVER use hardcoded hex values (`style={{ color: '#6366F1' }}`) in JSX.
- NEVER use inline `style` props for colors, spacing, or typography.
- Always use Tailwind classes from `context/design_system.md`.
- If a color combo you need isn't in `design_system.md`, **add it there first**, then use it.
- Dark theme ONLY — never use light backgrounds or light mode variants.

### Typography
- Plus Jakarta Sans is configured globally via `next/font` — never set `fontFamily` manually.
- Use the typography scale from `design_system.md` (Tailwind size + weight classes).

### Components
- Use `shadcn/ui` for all base components (Button, Input, Dialog, Sheet, Skeleton, Tabs, etc.).
- Use `lucide-react` for ALL icons — never use emoji, Material Icons, or other icon libraries.
- Use `@tanstack/react-table` for all data tables.
- Use `react-hook-form` + `zod` for all forms with validation.
- Never hand-roll a modal — use shadcn `Dialog` or `AlertDialog`.
- Never hand-roll a drawer — use shadcn `Sheet`.
- Never hand-roll a toast/notification — use shadcn `Sonner` or `Toast`.

### Loading States
- Always use shadcn `Skeleton` for content loading (not spinners, not "Loading...").
- Use `disabled` + loading spinner inside button for button loading states.
- Never block the full page with a loading overlay.

### Firebase / Data
- All data from Firebase — zero hardcoded/static data in production components.
- Use `onSnapshot` for real-time data (dashboard stats, bookings, notifications).
- Use `getDocs` / `getDoc` for one-time reads (trip detail, booking detail).
- Always handle Firestore errors with `try/catch` and show a toast via shadcn Sonner.
- Never fetch Firestore data directly inside a component — always via `lib/firestore/*.ts` helper functions.

### Auth
- Always check `user.role === 'agency'` before rendering dashboard content.
- Use `AuthContext` (`lib/auth-context.tsx`) — never call `getAuth()` directly in components.
- Route protection is handled by `middleware.ts` — never duplicate auth checks in every page.

### HTML Mockup Conversion
- HTML mockups are source of truth for **layout and visual structure ONLY**.
- Data fields must match TypeScript interfaces in `lib/types.ts` and `context/database_schema.md`.
- HTML may have demo/static data — never copy it. All values from Firebase.
- If HTML shows a field not in the schema, **flag it and ask** before inventing new Firestore fields.
- Map HTML CSS variables to Tailwind classes using the table in `context/design_system.md`.

### Responsive Design
- Use `lg:` (900px) as the main breakpoint: sidebar visible `lg:flex`, hidden `max-lg:hidden`.
- Build separate layout trees per breakpoint where needed (not just padding changes).
- Tables → card lists at `max-lg`. Stats 4-col → 2-col → 1-col.
- Touch targets min 44px height on mobile.

### Spacing & Layout
- Use Tailwind spacing scale — minimize magic numbers.
- Content padding: `px-6` horizontal, `py-6` vertical.
- Card padding: `p-4` or `p-5`.
- Gap between cards/sections: `gap-4` or `gap-6`.

### Verification
- Run `npm run build` after making changes — fix all TypeScript errors before considering done.
- Run `npm run lint` — fix all ESLint warnings in production files.
- Check responsive layout at 375px (mobile) and 1280px (desktop) before calling a screen done.

### General
- Use TypeScript strict mode — no `any` types.
- Use `async/await` — never `.then().catch()` chains.
- Keep components small and focused — extract reusable pieces to `components/`.
- Use `'use client'` directive only when the component needs browser APIs or React hooks.
- Prefer React Server Components for data-fetching pages where possible.

---

## Task

$ARGUMENTS
