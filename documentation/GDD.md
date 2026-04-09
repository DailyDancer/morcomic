# Game Design Document: Neon Grid Action Runner

## 1. Overview

**Neon Grid Action Runner** is an infinite-style 2D runner built with Flutter and Flame, targeting Android (Google Play) as the primary release platform. The player controls a malleable energy spirit traveling through a cosmic tunnel. Instead of jumping or shooting, the player must rapidly shift their physical form to match geometric cutouts in approaching barriers called Matter Gates.

The game is designed to be simple to build, engaging to play, and polished enough to meet Google Play's quality standards.

---

## 2. Core Game Loop

The player experience follows this repeating cycle:

1. **Warp In** - The player starts a run from the main menu.
2. **Observe** - An approaching Matter Gate displays a geometric shape (circle, triangle, or square).
3. **Morph** - The player swipes to change their form to match the gate.
4. **Pass or Fail** - If the shape matches, the player passes through safely and earns score. If not, the run ends.
5. **Collect** - Between gates, the player collects Star Bits (currency pickups).
6. **Form Collapsed** - When a run ends, the player sees their score, can spend Star Bits in the shop, and starts again.

---

## 3. Gameplay Mechanics

### Player States

The player entity exists in one of three shape states at any time:

* **Sphere (Default)** - The resting state. A circle. The entity returns to this form automatically after a brief delay if no input is held.
* **Apex (Swipe Up)** - A tall, glowing triangle.
* **Block (Swipe Down)** - A dense, glowing square.

### Controls

* **Swipe Up** - Transforms the entity into the Apex (triangle).
* **Swipe Down** - Transforms the entity into the Block (square).
* **Tap** - Returns the entity to the Sphere (circle).
* The entity automatically reverts to Sphere after a short duration if no further input is given.

### Matter Gates (Obstacles)

* Gates are barriers that scroll from right to left across the screen.
* Each gate has a cutout in a specific shape: circle, triangle, or square.
* The player must be in the matching shape state when they reach the gate.

### Collision & Pass Logic

When the player's position intersects a gate, the game performs a simple state comparison: does the player's current shape match the gate's required shape? If yes, the player passes through. If no, the run ends. This is a straightforward state-match check, not physics-based collision.

### Star Bits (Currency)

* Small glowing pickups that appear between gates.
* Collected by touching them in any shape state.
* Accumulated across runs and saved locally on device.
* Spent in The Arsenal (shop) on cosmetic color skins.

---

## 4. Screens & Navigation

All UI uses thematic terminology to maintain immersion. There are no generic "Play" or "Settings" labels.

### The Singularity (Splash Screen)
* Displays the game logo and title.
* Automatically transitions to the Cosmic Hub after 2 seconds.

### Cosmic Hub (Main Menu)
* **Warp In** - Starts a new run.
* **Morphing Manual** - Opens a static "how to play" visual guide.
* **Calibrations** - Opens a toggle for haptics.
* **The Arsenal** - Opens the cosmetic shop.
* **Data Blackhole** - Links to the offline privacy policy.

### The Void (Gameplay Screen)
* **Lightyears (Score)** - Displayed in the top-left corner.
* **Star Bits (Currency)** - Displayed below or beside the score.
* **Temporal Stasis (Pause)** - A small icon in the top-right corner.

### Temporal Stasis (Pause Overlay)
* Triggered by the pause icon or by backgrounding the app.
* **Break Stasis** - Resumes the game after a 3-2-1 countdown.
* **Calibrations** - Access the haptic toggle.
* **Abandon Orbit** - Ends the run and returns to the Cosmic Hub.

### Form Collapsed (Game Over Screen)
* Shown when the player fails a gate.
* **Run Diagnostics** - Shows Lightyears traveled and Star Bits collected this run.
* **Sector Best** - Shows the player's all-time highest Lightyears score.
* **Re-Initiate Warp** - Instantly restarts a new run.
* **Return to Hub** - Goes back to the Cosmic Hub.

### Morphing Manual (How to Play)
* A simple static visual overlay showing each shape and its corresponding swipe direction.
* Three panels: "Tap = Sphere", "Swipe Up = Apex", "Swipe Down = Block", each with an illustration of the shape and the gate it passes through.

### The Arsenal (Shop)
* Displays a grid of cosmetic color skins for the player entity.
* Each skin changes the glow color of all three shape states.
* Skins cost a fixed Star Bits price. Locked skins show as grayscale. Unlocked skins glow with their color.
* The default skin is always available (Cyan/Magenta/Yellow from the DLS).
* Keep the number of skins small (6-8 total) to keep scope manageable.

### Data Blackhole (Privacy Policy)
* A scrollable text screen stating that Neon Grid Action Runner is fully offline and collects no personal data.

---

## 5. Progression & Difficulty

The game scales difficulty over time using distance-based "Sectors." As the player survives longer, the game gets faster and the gates appear more frequently.

### Difficulty Variables
* **Warp Speed** - How fast gates scroll from right to left.
* **Gate Density** - The time/distance gap between consecutive gates.

### Sector Table

| Sector | Distance (Lightyears) | Warp Speed | Gate Density | Notes |
| :--- | :--- | :--- | :--- | :--- |
| Sector Alpha | 0 - 500 | Slow | Low (far apart) | Tutorial pace. Basic gates only. |
| Sector Beta | 501 - 1,500 | Medium | Medium | Star Bit clusters begin appearing more frequently. |
| Sector Gamma | 1,501 - 3,000 | Fast | High (close together) | Rapid shape-shifting required. Back-to-back gates of different shapes. |
| Sector Delta | 3,001 - 6,000 | Very Fast | Very High | Near-maximum speed. Tests endurance and rhythm. |
| The Deep Void | 6,000+ | Maximum (capped) | Maximum (capped) | Speed and density hit their ceiling. Pure survival. |

Note: There are no "decoy spawns" or visual distractors. The difficulty comes purely from speed and density. This keeps implementation simple and the challenge fair.

---

## 6. Scoring

* **Lightyears (Score)** - Accumulates automatically over time at a steady rate while the player is alive. The rate is tied to the current Warp Speed, so faster sectors earn score faster.
* **Star Bits (Currency)** - Earned by collecting pickups during a run. The total is banked to local storage when the run ends.
* **Sector Best** - The highest single-run Lightyears score, saved locally.

There is no "perfect clear" bonus. Score is purely time-survived plus speed scaling. This keeps the scoring system simple and easy to understand.

---

## 7. Haptic Feedback

The game uses haptic feedback instead of audio to provide tactile responses to player actions. There is no music or sound effects.

* **Morph** - A light haptic tap when the player changes shape.
* **Star Bit collect** - A medium haptic pulse when picking up a Star Bit.
* **Form Collapsed (crash)** - A strong haptic burst when the run ends.
* **Settings** - Haptics can be toggled on/off from Calibrations.

---

## 8. Data & Storage

* All data is stored locally on the device using simple key-value storage.
* **Saved data:**
  * Total Star Bits (lifetime bank).
  * Sector Best (highest Lightyears in a single run).
  * Unlocked skins (list of purchased Arsenal items).
  * Haptic toggle preference.
* No online features. No accounts. No analytics. No ads. Fully offline.

---

## 9. Target Platform & Compliance

* **Primary platform:** Android (Google Play).
* The game must include a visible, accessible privacy policy (Data Blackhole) from the main menu.
* The game must feel polished and substantial enough to avoid rejection as "spam" or "minimum viable functionality." This means: smooth animations, a cohesive visual style, clear progression, haptic feedback, and a complete set of screens (splash, menu, gameplay, pause, game over, how-to-play, shop, privacy policy).
