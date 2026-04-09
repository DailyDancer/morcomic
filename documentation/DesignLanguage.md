# Design Language System: Neon Grid Action Runner

This document defines the visual identity for Neon Grid Action Runner. Every color, font choice, spacing rule, and component style described here should be implemented as constants and theme data so the entire app inherits a consistent look automatically.

---

## 1. Visual Direction

* **Aesthetic:** "Neon Lo-Fi Sci-Fi." Dark, infinite backgrounds with bright, glowing geometric foreground elements.
* **Shape Language:** UI elements use slightly rounded corners for a friendly, casual feel. Gameplay shapes (Triangle, Square, Circle) have sharp, distinct silhouettes for instant recognition during fast gameplay.
* **Motion:** Fluid and bouncy. Menus slide or fade in with ease-out curves. The player entity squashes and stretches briefly when morphing between shapes.

---

## 2. Typography

The entire game uses a single typeface to maintain a unified identity.

* **Font:** Orbitron (from Google Fonts).
* **Why:** Futuristic, geometric, highly legible at a glance. Fits the space/shape-shifting theme perfectly.

**Hierarchy:**

| Usage | Weight | Size | Notes |
| :--- | :--- | :--- | :--- |
| Display / Titles (Splash, Game Over) | Black (900) | 48sp - 64sp | Scale dynamically with screen width. |
| Primary Buttons (Warp In, Re-Initiate Warp) | Bold (700) | 24sp | Uppercase, generous letter-spacing. |
| HUD (Lightyears, Star Bits) | Medium (500) | 20sp | Drop-shadow for contrast against scrolling backgrounds. |
| Body Text (Privacy Policy, descriptions) | Regular (400) | 14sp - 16sp | 1.5x line height for readability. |

---

## 3. Color Palette

The palette is built around a dark void background to make gameplay shapes instantly identifiable by both color and silhouette.

### Backgrounds & Surfaces

| Name | Hex | Usage |
| :--- | :--- | :--- |
| Deep Space | `#0B0C10` | App background, game background. This is the canonical background color for the entire app. |
| Stardust | `#1F2833` at 80% opacity | Menu cards, overlays, glassmorphism panels. |

### Gameplay & UI Accents

| Name | Hex | Usage |
| :--- | :--- | :--- |
| Sphere (Cyan) | `#00E5FF` | Default player state. Also used as the primary UI accent (button borders, highlights). |
| Apex (Magenta) | `#FF007F` | Swipe-up triangle state. Bright, aggressive, upward energy. |
| Block (Yellow) | `#FFD600` | Swipe-down square state. Heavy, solid, grounding. |
| Star Bits | `#FFFFFF` with `#00E5FF` outer glow | Currency pickups. White core with cyan glow to stand out from gates. |
| Fail / Crash | `#FF3D00` | Used only for the Form Collapsed screen flash and screen-shake overlay. |

**Important:** The background color `#0B0C10` must be used consistently everywhere - in the Flutter ThemeData, in the Flame game's background color, and in any overlay backgrounds. No other background tint should be used.

---

## 4. Spacing & Layout

All spacing uses a **Base-8 system** (every margin, padding, and size value is a multiple of 8).

### Safe Zones & Touch Targets

* All interactive UI elements must respect device safe areas with a minimum **24dp** margin from screen edges (to avoid notches and curved displays).
* Minimum touch target size for any button or toggle: **48x48dp**.

### Screen Layouts

* **Cosmic Hub (Main Menu):** Stack primary actions vertically in the bottom third of the screen (natural thumb-reach zone for one-handed play).
* **The Void (Gameplay):** The player entity is positioned in the left third of the screen (X-axis), giving maximum visibility of incoming gates on the right side.
* **HUD Placement:** Score (Lightyears) in top-left. Pause button in top-right. Both pushed to the corners so the center screen stays clear for gameplay focus.

---

## 5. UI Components

### Primary Buttons (e.g., "Warp In", "Re-Initiate Warp")
* Background: Transparent.
* Border: 2dp solid Sphere Cyan (`#00E5FF`).
* Corner radius: 16dp.
* Press state: Fill with Sphere Cyan at 30% opacity.

### Secondary Buttons (e.g., "Calibrations", "Return to Hub")
* Background: Transparent.
* Border: 1dp solid Stardust (`#1F2833`).
* Text: White at 70% opacity.

### Arsenal (Shop) Cards
* Square tiles (approximately 100x100dp) with 8dp rounded corners.
* Locked items: Grayscale filter.
* Unlocked items: Glow with their respective neon color.

### HUD Elements
* Borderless text anchored to top corners.
* Drop-shadow behind text for readability against the scrolling parallax background.

---

## 6. Animations & Game Feel

* **Morph transition:** When the player swipes, the entity briefly squashes and stretches over approximately 150ms before settling into the new shape. This is a simple scale effect, not a complex skeletal animation.
* **Gate pass:** A subtle flash or brief glow on the entity when passing through a gate successfully.
* **Form Collapsed (death):** A brief camera shake and a red-orange flash overlay (`#FF3D00` at low opacity) on the screen.
* **Star Bit collection:** The pickup disappears with a small scale-down and fade-out.
* **Menu transitions:** All screen transitions use ease-out slide or fade animations, approximately 300ms duration.
