# SoleGoes Brand & Design System

## Brand Identity

- **Name:** SoleGoes
- **Tagline:** solo but , not alone
- **What:** Mobile app connecting solo travelers — trip discovery, group booking, trip chat, payments
- **Audience:** Young solo travelers (20-35) in India
- **Personality:** Premium but approachable, adventurous, modern, trustworthy
- **Platform:** Mobile-first (Flutter app), dark theme only

---

## Color Palette

### Backgrounds (Zinc Scale)
| Name | Hex | Usage |
|------|-----|-------|
| Deep | `#09090B` | Main app background (Zinc 950) |
| Surface | `#18181B` | Cards, containers, elevated surfaces (Zinc 900) |
| Card | `#111111` | Card backgrounds |
| Glass | `rgba(24,24,27,0.7)` | Glassmorphic panels (70% surface) |
| Glass Light | `rgba(255,255,255,0.03)` | Subtle elevated surfaces |

### Text
| Name | Hex | Usage |
|------|-----|-------|
| Primary | `#FAFAFA` | Headings, important text (Zinc 50) |
| Secondary | `#A1A1AA` | Body text, descriptions (Zinc 400) |
| Tertiary | `#52525B` | Captions, muted icons (Zinc 600) |
| Placeholder | `rgba(255,255,255,0.3)` | Input placeholders |
| Muted | `rgba(255,255,255,0.5)` | De-emphasized text |
| Hint | `rgba(255,255,255,0.4)` | Hint text |

### Primary & Accents
| Name | Hex | Usage |
|------|-----|-------|
| **Primary** | `#6366F1` | Brand color, CTAs, active states (Indigo 500) |
| Violet | `#8B5CF6` | Gradient end, secondary accent (Violet 500) |
| Blue | `#3B82F6` | Informational accents |
| Teal | `#14B8A6` | Secondary highlights |
| Rose | `#F43F5E` | Destructive, required indicators |
| Green | `#4CAF50` | Positive indicators |
| Pink | `#EC4899` | Calendar, playful accents |
| Yellow | `#FACC15` | Sparkles, highlights, gold badges |

### Status Colors
| Name | Hex | Usage |
|------|-----|-------|
| Error | `#EF4444` | Errors, failures (Red 500) |
| Success | `#10B981` | Success states (Emerald 500) |
| Pending | `#EAB308` | Pending/waiting states (Yellow 500) |
| Confirmed | `#22C55E` | Confirmed bookings (Green 500) |

### Borders & Surfaces
| Name | Value | Usage |
|------|-------|-------|
| Border Subtle | `rgba(255,255,255,0.06)` | Default card/input borders |
| Border Glass | `rgba(255,255,255,0.10)` | Glass panel borders |
| Border Focus | `rgba(255,255,255,0.30)` | Focused input borders |
| Surface Hover | `rgba(255,255,255,0.05)` | Hover state backgrounds |
| Surface Pressed | `rgba(255,255,255,0.10)` | Pressed state backgrounds |
| Surface Selected | `rgba(255,255,255,0.15)` | Selected/active state backgrounds |
| Divider | `rgba(255,255,255,0.10)` | Section separators |

### Gradients
| Name | Value | Usage |
|------|-------|-------|
| **Primary Gradient** | `linear-gradient(135deg, #6366F1, #8B5CF6)` | Primary buttons, CTAs, nav FAB |
| Dark Gradient | `linear-gradient(135deg, #1A1A1A, #0A0A0A)` | Spin-the-globe card, dark panels |
| Primary Glow | `box-shadow: 0 4px 15px rgba(99,102,241,0.4)` | Glow behind primary buttons |

### Overlays & Scrims
| Name | Value | Usage |
|------|-------|-------|
| Modal Overlay | `rgba(0,0,0,0.5)` | Behind modals/sheets |
| Image Scrim | `rgba(0,0,0,0.7)` | Over hero images for text readability |
| Light Scrim | `rgba(0,0,0,0.4)` | Lighter image overlays |

---

## Typography

### Font
- **Family:** Plus Jakarta Sans
- **Import:** `@import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap')`
- **Rendering:** `-webkit-font-smoothing: antialiased`

### Scale
| Style | Size | Weight | Line Height | Usage |
|-------|------|--------|-------------|-------|
| h1 | 32px | 800 | 1.2 | Page titles |
| h2 | 24px | 700 | 1.3 | Section titles |
| h3 | 20px | 600 | 1.4 | Card titles, sub-sections |
| h4 | 18px | 600 | 1.4 | Smaller headings |
| h5 | 16px | 600 | 1.4 | List titles |
| heroTitle | 32px | 700 | 1.1 | Auth screens, hero sections |
| bodyLarge | 16px | 500 | 1.5 | Prominent body text |
| body | 15px | 500 | 1.5 | Default body text |
| bodyMedium | 14px | 500 | 1.5 | Secondary body text |
| bodySmall | 14px | 400 | 1.5 | Descriptions, meta text |
| label | 14px | 600 | — | Form labels, emphasis |
| labelSmall | 12px | 500 | — | Small labels, tags |
| sectionTitle | 12px | 700 | — | Uppercase section headers (0.5px letter-spacing) |
| button | 16px | 600 | — | Primary button text |
| buttonSmall | 14px | 600 | — | Secondary button text |
| caption | 12px | 400 | — | Timestamps, footnotes |
| price | 18px | 700 | — | Price displays |
| link | 14px | 500 | — | Clickable links (underlined, primary color) |
| overline | 10px | 600 | — | Category labels (1.5px letter-spacing, uppercase) |
| badge | 12px | 700 | — | Status badges, pills |

---

## Spacing

| Token | Value |
|-------|-------|
| xs | 8px |
| sm | 12px |
| md | 16px |
| lg | 24px |
| xl | 32px |
| xxl | 48px |

Standard content padding: `24px` (1.5rem) horizontal.

---

## Border Radius

| Token | Value | Usage |
|-------|-------|-------|
| sm | 8px | Small chips, badges |
| md | 16px | Cards, inputs, buttons, modals |
| lg | 24px | Featured cards, hero images |
| full | 9999px | Pills, avatars, search bars, nav island |

---

## Shadows

| Name | Value | Usage |
|------|-------|-------|
| sm | `0 2px 4px rgba(0,0,0,0.1)` | Subtle elevation |
| md | `0 4px 8px rgba(0,0,0,0.15)` | Cards |
| lg | `0 8px 16px rgba(0,0,0,0.2)` | Modals, popovers |
| Primary Glow | `0 4px 6px rgba(99,102,241,0.2)` | Primary buttons |
| Nav Island | `0 20px 25px rgba(0,0,0,0.5)` | Floating bottom nav |
| Featured Card | `0 10px 40px rgba(0,0,0,0.5)` | Hero trip cards |

---

## Design Language

### Core Aesthetic
- **Dark-only** — no light theme. Deep zinc blacks with subtle white-alpha surfaces.
- **Glassmorphism** — translucent panels with `backdrop-filter: blur(16px)` and subtle white-alpha borders.
- **Minimal chrome** — content-first, no heavy frames or borders.
- **Gradient accents** — primary actions use the indigo-to-violet gradient, never flat indigo.
- **Depth through opacity** — layers created with white-alpha percentages (3%, 5%, 10%) rather than distinct colors.

### Card Pattern
```
Background: rgba(255,255,255,0.03) or #111111
Border: 1px solid rgba(255,255,255,0.06)
Radius: 16px
Padding: 16px
Hover: background shifts to rgba(255,255,255,0.05), border to rgba(255,255,255,0.10)
Transition: all 0.3s ease
```

### Glass Panel Pattern
```
Background: rgba(24,24,27,0.7)  or rgba(24,24,27,0.9)
Backdrop-filter: blur(16px) to blur(20px)
Border: 1px solid rgba(255,255,255,0.10)
```

### Button Patterns
| Type | Background | Border | Text | Hover |
|------|-----------|--------|------|-------|
| Primary | Gradient `#6366F1 → #8B5CF6` | none | white | brightness(1.1), translateY(-1px), glow shadow |
| Secondary | `rgba(255,255,255,0.05)` | 1px subtle | primary text | bg to 0.10, translateY(-1px) |
| Ghost | transparent | none | secondary text | bg to 0.05, text to primary |
| Social | `rgba(255,255,255,0.03)` | 1px subtle | primary text | bg to 0.08, translateY(-1px) |
| Icon | `rgba(255,255,255,0.05)` | 1px subtle | white icon | bg to 0.10 |
| FAB (Nav) | Gradient `#6366F1 → #8B5CF6` | 4px deep border | white icon | scale(1.05) |

### Input Pattern
```
Background: rgba(255,255,255,0.03)
Border: 1px solid rgba(255,255,255,0.06)
Radius: 16px
Padding: 14px 16px
Placeholder: rgba(255,255,255,0.3)
Focus: border-color #6366F1, box-shadow 0 0 0 1px #6366F1 + 0 0 15px rgba(99,102,241,0.1)
```

### Pill / Chip Pattern
```
Default: bg rgba(255,255,255,0.03), border 1px subtle, text secondary, radius 16px
Hover: bg 0.08, border glass, text primary
Selected: bg rgba(99,102,241,0.15), border #6366F1, text white, glow shadow
```

### Navigation (Floating Island)
```
Position: fixed, bottom 24px, centered
Background: rgba(24,24,27,0.9)
Backdrop-filter: blur(20px)
Border: 1px solid rgba(255,255,255,0.10)
Radius: 9999px (pill)
Shadow: 0 20px 25px rgba(0,0,0,0.5)
Items: icon + label, tertiary color → primary when active
Center FAB: gradient circle, elevated -24px above bar
```

---

## Iconography

- **Library:** Lucide Icons
- **Web import:** `<script src="https://unpkg.com/lucide@latest/dist/umd/lucide.min.js"></script>`
- **Flutter package:** `lucide_icons`
- **Default size:** 20-24px
- **Default color:** textTertiary (`#52525B`) for inactive, textPrimary (`#FAFAFA`) for active
- **Style:** Outline/stroke only (no filled icons), consistent 1.5-2px stroke width

---

## Animation Timings

| Token | Duration | Usage |
|-------|----------|-------|
| fast | 150ms | Micro interactions, button presses |
| normal | 200ms | State transitions, focus changes |
| slow | 300ms | Card animations, page transitions |
| slower | 500ms | Complex reveals, onboarding |

### Standard Easings
- `ease` — default for most transitions
- `ease-out` — elements entering the viewport
- `ease-in-out` — looping animations

### Key Animations
| Name | Behavior |
|------|----------|
| Float | `translateY(0 → -6px → 0)` over 6s, infinite — decorative elements |
| Scale In | `scale(0) → scale(1.1) → scale(1)` over 0.5s — success states |
| Shake | `translateX(0 → -10px → 10px → 0)` over 0.3s — error feedback |
| Pulse Glow | Primary shadow 20px → 30px over 3s, infinite — attention CTAs |
| Spin | `rotate(0 → 360deg)` over 10s, linear, infinite — globe spinner |
| Hover Lift | `translateY(-1px)` on hover — buttons, cards |

---

## Image Handling

- **Hero images:** Full-bleed, `object-fit: cover`, scrim overlay for text legibility
- **Card thumbnails:** Fixed aspect ratio, rounded corners matching card radius
- **Avatars:** Circular (`border-radius: 9999px`), 36-48px diameter
- **Placeholder:** Shimmer effect with `rgba(255,255,255,0.2)` → `rgba(255,255,255,0.3)` pulse
- **Error state:** Subtle icon on dark surface
- **Sources for mockups:** Unsplash (real URLs only), `ui-avatars.com` for placeholder avatars

---

## Layout Principles

- **Mobile-first:** Max width 428px, centered
- **Content padding:** 24px horizontal
- **Section spacing:** 24-32px between sections
- **Safe areas:** Respect system status bar and home indicator
- **Bottom nav clearance:** 96px bottom padding on scrollable content (nav island height + margin)
- **Sticky headers:** `rgba(9,9,11,0.8)` with `blur(12px)`, 1px bottom border

---

## Screen Structure Template

```
┌─────────────────────────────────┐
│ [Status Bar - system]           │
├─────────────────────────────────┤
│ Sticky Header (glass, blur)     │
├─────────────────────────────────┤
│                                 │
│  Scrollable Content Area        │
│  - 24px horizontal padding      │
│  - 24-32px between sections     │
│                                 │
│                                 │
│                                 │
│  [96px bottom clearance]        │
├─────────────────────────────────┤
│  ┌─────────────────────────┐    │
│  │  Floating Nav Island    │    │
│  │  [pill shape, glass]    │    │
│  └─────────────────────────┘    │
└─────────────────────────────────┘
```

---

## Quick Reference (Copy-Paste)

### CSS Variables
```css
:root {
    --bg-deep: #09090b;
    --bg-surface: #18181b;
    --bg-glass: rgba(24, 24, 27, 0.7);
    --text-primary: #fafafa;
    --text-secondary: #a1a1aa;
    --text-tertiary: #52525b;
    --primary: #6366f1;
    --primary-gradient: linear-gradient(135deg, #6366f1, #8b5cf6);
    --accent-blue: #3b82f6;
    --accent-teal: #14b8a6;
    --accent-rose: #f43f5e;
    --accent-green: #4caf50;
    --border-subtle: rgba(255, 255, 255, 0.06);
    --border-glass: rgba(255, 255, 255, 0.1);
    --radius-sm: 8px;
    --radius-md: 16px;
    --radius-lg: 24px;
    --radius-full: 9999px;
    --font-main: 'Plus Jakarta Sans', sans-serif;
}
```

### Tailwind-Compatible Palette
```
zinc-950: #09090B (bg-deep)
zinc-900: #18181B (bg-surface)
zinc-600: #52525B (text-tertiary)
zinc-400: #A1A1AA (text-secondary)
zinc-50:  #FAFAFA (text-primary)
indigo-500: #6366F1 (primary)
violet-500: #8B5CF6 (gradient end)
```
