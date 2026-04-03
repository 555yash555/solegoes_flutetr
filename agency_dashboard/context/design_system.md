# SoleGoes Agency Dashboard — Design System

**This is the source of truth for all styling in the Next.js agency dashboard.**
There is no `app_theme.dart` here — use this doc + Tailwind classes instead.
The HTML mockups (`design_mockups/`) use the same tokens as CSS variables — they map 1:1 below.

---

## Brand Identity

- **Name:** SoleGoes — Agency Dashboard
- **Subdomain:** `agency.solegoes.in`
- **Tagline:** Scale your travel business
- **Aesthetic:** Dark-only, premium, glassmorphic, data-dense
- **Font:** Plus Jakarta Sans (Google Fonts)
- **Icon library:** Lucide React (`lucide-react` npm package)

---

## Color Tokens

### Tailwind config additions (`tailwind.config.ts`)

```ts
colors: {
  bg: {
    deep:    '#09090B',   // zinc-950 — main page background
    surface: '#18181B',   // zinc-900 — cards, sidebar, elevated surfaces
    card:    '#111111',   // slightly darker card backgrounds
    glass:   'rgba(24,24,27,0.7)',  // glassmorphic panels
  },
  text: {
    primary:   '#FAFAFA',  // zinc-50 — headings, important text
    secondary: '#A1A1AA',  // zinc-400 — body text, descriptions
    tertiary:  '#52525B',  // zinc-600 — captions, muted icons
  },
  brand: {
    primary: '#6366F1',   // indigo-500 — CTAs, active nav, links
    violet:  '#8B5CF6',   // violet-500 — gradient end
  },
  status: {
    pending:   '#EAB308',  // yellow-500
    confirmed: '#22C55E',  // green-500
    cancelled: '#EF4444',  // red-500
    completed: '#A1A1AA',  // zinc-400
    live:      '#10B981',  // emerald-500
    draft:     '#3B82F6',  // blue-500
  },
  accent: {
    blue:   '#3B82F6',
    teal:   '#14B8A6',
    rose:   '#F43F5E',
    green:  '#4CAF50',
    yellow: '#FACC15',
  },
},
```

### Quick reference — most-used classes

| Purpose | Class |
|---------|-------|
| Page background | `bg-[#09090B]` or `bg-zinc-950` |
| Card / sidebar background | `bg-[#18181B]` or `bg-zinc-900` |
| Primary text | `text-zinc-50` |
| Secondary text | `text-zinc-400` |
| Muted/tertiary text | `text-zinc-600` |
| Primary brand color | `text-indigo-500` / `bg-indigo-500` |
| Primary gradient bg | `bg-gradient-to-br from-indigo-500 to-violet-500` |
| Subtle border | `border border-white/[0.06]` |
| Glass border | `border border-white/10` |
| Hover surface | `hover:bg-white/5` |
| Active/selected surface | `bg-white/[0.15]` |
| Input background | `bg-white/[0.03]` |

---

## Typography

**Font setup** — add to `app/layout.tsx`:
```tsx
import { Plus_Jakarta_Sans } from 'next/font/google';
const font = Plus_Jakarta_Sans({ subsets: ['latin'], weight: ['400','500','600','700','800'] });
```

### Scale

| Name | Size | Weight | Usage |
|------|------|--------|-------|
| `text-3xl font-extrabold` | 32px / 800 | Page titles (h1) |
| `text-2xl font-bold` | 24px / 700 | Section titles (h2) |
| `text-xl font-semibold` | 20px / 600 | Card titles (h3) |
| `text-lg font-semibold` | 18px / 600 | Sub-headings (h4) |
| `text-base font-medium` | 16px / 500 | Body text |
| `text-sm font-medium` | 14px / 500 | Secondary body, table cells |
| `text-sm font-semibold` | 14px / 600 | Labels, emphasis |
| `text-xs font-medium` | 12px / 500 | Captions, timestamps |
| `text-xs font-semibold tracking-wide uppercase` | 12px / 700 | Section headers, overlines |

---

## Spacing

| Token | Value | Tailwind |
|-------|-------|---------|
| xs | 8px | `gap-2` / `p-2` |
| sm | 12px | `gap-3` / `p-3` |
| md | 16px | `gap-4` / `p-4` |
| lg | 24px | `gap-6` / `p-6` |
| xl | 32px | `gap-8` / `p-8` |
| xxl | 48px | `gap-12` / `p-12` |

Standard content padding: `px-6` (24px) horizontal.

---

## Border Radius

| Token | Value | Tailwind | Usage |
|-------|-------|---------|-------|
| sm | 8px | `rounded-lg` | Chips, badges, small buttons |
| md | 16px | `rounded-2xl` | Cards, inputs, modals |
| lg | 24px | `rounded-3xl` | Featured cards, hero |
| full | 9999px | `rounded-full` | Pills, avatars, nav items |

---

## Shadows

| Name | CSS | Usage |
|------|-----|-------|
| sm | `shadow-sm` | Subtle elevation |
| md | `shadow-md` | Cards |
| lg | `shadow-lg` | Modals, popovers |
| primary glow | `shadow-[0_4px_15px_rgba(99,102,241,0.4)]` | Primary buttons, active states |

---

## Component Patterns

### Card
```tsx
<div className="bg-[#111111] border border-white/[0.06] rounded-2xl p-4
                hover:bg-white/[0.05] hover:border-white/10 transition-all duration-300">
```

### Glass Panel (sidebar, topbar)
```tsx
<div className="bg-[rgba(24,24,27,0.9)] backdrop-blur-xl border border-white/10">
```

### Primary Gradient Button
```tsx
<button className="bg-gradient-to-br from-indigo-500 to-violet-500 text-white
                   rounded-2xl px-4 py-2 font-semibold
                   hover:brightness-110 hover:-translate-y-px transition-all
                   shadow-[0_4px_15px_rgba(99,102,241,0.4)]">
```

### Secondary Button
```tsx
<button className="bg-white/[0.05] border border-white/[0.06] text-zinc-50
                   rounded-2xl px-4 py-2 font-semibold
                   hover:bg-white/10 hover:-translate-y-px transition-all">
```

### Ghost Button
```tsx
<button className="text-zinc-400 hover:text-indigo-500 hover:bg-white/5
                   rounded-xl px-3 py-2 transition-all">
```

### Input Field
```tsx
<input className="w-full bg-white/[0.03] border border-white/[0.06] rounded-2xl
                  px-4 py-3 text-zinc-50 placeholder:text-zinc-600
                  focus:outline-none focus:border-indigo-500
                  focus:ring-1 focus:ring-indigo-500
                  focus:shadow-[0_0_15px_rgba(99,102,241,0.1)]
                  transition-all" />
```

### Status Badge
```tsx
// Use these color combos for status badges:
// pending    → bg-yellow-500/10  text-yellow-500  border-yellow-500/20
// confirmed  → bg-green-500/10   text-green-500   border-green-500/20
// cancelled  → bg-red-500/10     text-red-500     border-red-500/20
// live       → bg-emerald-500/10 text-emerald-500 border-emerald-500/20
// draft      → bg-blue-500/10    text-blue-500    border-blue-500/20
// completed  → bg-zinc-400/10    text-zinc-400    border-zinc-400/20

<span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-full text-xs font-semibold
                 border bg-yellow-500/10 text-yellow-500 border-yellow-500/20">
  Pending
</span>
```

### Nav Item (sidebar)
```tsx
// Default
<a className="flex items-center gap-3 px-3 py-2.5 rounded-xl text-zinc-400
              hover:bg-white/5 hover:text-zinc-50 transition-all cursor-pointer">

// Active
<a className="flex items-center gap-3 px-3 py-2.5 rounded-xl
              bg-indigo-500/10 text-indigo-400 border border-indigo-500/20">
```

### Stats Card
```tsx
<div className="bg-[#111111] border border-white/[0.06] rounded-2xl p-5
                hover:scale-[1.02] hover:shadow-[0_4px_15px_rgba(99,102,241,0.15)]
                transition-all duration-150">
  <div className="flex items-center justify-between mb-3">
    <div className="p-2 rounded-lg bg-indigo-500/10">
      <Icon className="w-5 h-5 text-indigo-500" />
    </div>
    <span className="text-xs text-green-500 font-semibold">+12%</span>
  </div>
  <p className="text-2xl font-bold text-zinc-50">₹2.4L</p>
  <p className="text-sm text-zinc-400 mt-1">Total Revenue</p>
</div>
```

### DataTable Row
```tsx
<tr className="border-b border-white/[0.06] hover:bg-white/[0.03] transition-colors cursor-pointer">
  <td className="px-4 py-3 text-sm text-zinc-50">...</td>
</tr>
```

### Section Divider
```tsx
<div className="border-t border-white/[0.06] my-6" />
```

---

## Responsive Breakpoints (Dashboard)

| Name | Width | Layout |
|------|-------|--------|
| Mobile | `< 900px` (`max-lg`) | No sidebar — hamburger + Sheet drawer |
| Desktop | `≥ 900px` (`lg:`) | Permanent 240px fixed sidebar |

```tsx
// Content area grid cols
<div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">  // stats
<div className="grid grid-cols-1 lg:grid-cols-2 gap-6">                  // two-col panels
```

---

## Animations & Transitions

| Element | Class |
|---------|-------|
| Default transition | `transition-all duration-200` |
| Card hover | `hover:scale-[1.02] transition-transform duration-150` |
| Button hover lift | `hover:-translate-y-px transition-transform` |
| Fade in | `animate-in fade-in duration-200` (shadcn/ui) |
| Slide in from left | `animate-in slide-in-from-left duration-300` |

---

## Icons

Use `lucide-react` exclusively:
```tsx
import { LayoutDashboard, MapPin, Calendar, Users, Bell } from 'lucide-react';

// Default size: w-5 h-5 (20px)
// Active nav: text-indigo-400
// Inactive nav: text-zinc-400
// Card icon in colored bg: w-5 h-5 text-indigo-500 inside bg-indigo-500/10 rounded-lg p-2
```

---

## Rules — What NOT To Do

- ❌ Never use hardcoded hex colors inline — always use Tailwind classes
- ❌ Never use `style={{ color: '#...' }}` — use `className="text-zinc-50"` etc.
- ❌ Never use light backgrounds — dark-only, always
- ❌ Never use `font-family` inline — Plus Jakarta Sans is set globally
- ❌ Never use Material UI or Ant Design — use shadcn/ui + Tailwind only
- ❌ Never use `Icons.xxx` (Material) — use `lucide-react` only
- ❌ Never hardcode pixel values for spacing — use Tailwind spacing scale
- ❌ Never show loading with a plain spinner div — use shadcn/ui `Skeleton`
- ✅ Always use `transition-all duration-200` on interactive elements
- ✅ Always add `cursor-pointer` to clickable non-button elements
- ✅ Always use `rounded-2xl` for cards and inputs (16px)
- ✅ Always use `border border-white/[0.06]` as default card border
