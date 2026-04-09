# Implementation Plan: Neon Grid Action Runner

This is the step-by-step build plan for Neon Grid Action Runner. It is organized into sequential phases so that each phase produces a testable result before moving to the next. The game uses Flutter for all UI screens and Flame for the gameplay rendering and loop.

Reference the **Game Design Document (GDD)** for what the game does, and the **Design Language System (DLS)** for how it looks. This plan covers how to build it.

---

## Phase 1: Project Foundation

**Goal:** Get the project scaffolding, dependencies, and design system in place so every subsequent phase builds on a consistent base.

### 1.1 Dependencies

The Flutter project already exists. The following packages need to be added to `pubspec.yaml`:

* `flame` - Already present. Core game engine.
* `flame_audio` - Already present. Can be removed since the game has no audio. If kept, it is unused.
* `shared_preferences` - For saving Star Bits, high score, unlocked skins, and settings toggles locally on device.
* `google_fonts` - To load the Orbitron typeface specified in the DLS.

### 1.2 Asset Directories

Create the following directories if they don't already exist:

* `assets/images/` - For all sprite and visual assets.
The `assets/audio/` directory and its declaration in `pubspec.yaml` can be removed since the game has no audio.

Ensure `assets/images/` is declared in `pubspec.yaml` under the `flutter.assets` section (already done).

For initial development, use simple colored placeholder shapes (solid colored circles, triangles, and squares on transparent backgrounds) so the game is playable before final art is produced.

### 1.3 Design Language Setup

Implement the DLS as the app's global theme:

* Set up a centralized constants file defining all the colors from the DLS palette (Deep Space, Sphere Cyan, Apex Magenta, Block Yellow, Star Bit White, Fail Red-Orange, Stardust).
* Configure the app-level ThemeData using Orbitron as the default font, with the text style hierarchy from the DLS (Display, Button, HUD, Body).
* Set the Flame game class background color to Deep Space (`#0B0C10`). This replaces the current placeholder color in `neon_grid_action_runner_game.dart`.

### 1.4 Game Class Setup

The main game class (`NeonGridActionRunnerGame`) extending `FlameGame` needs to be set up with:

* Collision detection mixin enabled.
* Vertical drag detection for swipe input handling.
* The overlay system configured to map themed overlay keys to Flutter widget builders (see Phase 4 for the full list of overlays).

---

## Phase 2: Core Gameplay Loop

**Goal:** Build the minimum playable game - a shape that morphs on swipe and passes or fails against gates.

### 2.1 Player Entity

Create the player component:

* It has a shape state that can be Sphere, Apex, or Block.
* Visually, it swaps between three different sprite assets (or colored shapes) instantly when the state changes.
* It is positioned in the left third of the screen as specified in the DLS.
* It has a hitbox for collision detection.
* On each morph, apply a brief squash-and-stretch scale animation (~150ms) for game feel.

### 2.2 Input Handling

Wire up swipe detection on the game class:

* Swipe up sets the player state to Apex (triangle).
* Swipe down sets the player state to Block (square).
* Tap sets the player state back to Sphere (circle).
* After a short delay with no input, the player automatically reverts to Sphere.

### 2.3 Matter Gates

Create the gate component:

* Each gate has a required shape state assigned when it spawns.
* Gates scroll from right to left at the current Warp Speed.
* Visually, the gate is a barrier with a cutout shape in the center showing which form is needed.

### 2.4 Pass/Fail Logic

When the player reaches a gate's position:

* Compare the player's current shape state against the gate's required shape state.
* If they match: the player passes through, and the run continues.
* If they don't match: the run ends immediately. Pause the game engine and trigger the Form Collapsed (Game Over) overlay.

This is a simple state comparison, not a physics simulation. The gate's "hitbox" triggers the check when the player's X position overlaps the gate's X position.

---

## Phase 3: World Management & Progression

**Goal:** Make the game infinite, performant, and progressively harder.

### 3.1 Gate Manager & Object Pooling

To maintain smooth performance:

* Create a gate manager that maintains a small pool of gate objects (3-5 is sufficient).
* When a gate scrolls off the left edge of the screen, recycle it: move it back to the right edge off-screen, assign it a new random required shape, and let it scroll again.
* This avoids constantly creating and destroying objects, which keeps frame rate stable.

### 3.2 Scrolling Background

Add a parallax scrolling background using Flame's built-in parallax support:

* Use 2-3 layers of star/space imagery scrolling at different speeds to create depth.
* The scroll speed should be tied to the current Warp Speed so the background feels faster as difficulty increases.

### 3.3 Difficulty Scaling (Sectors)

Implement the Sector progression system from the GDD:

* Track the player's Lightyears score, which increments over time.
* As the score crosses Sector thresholds (500, 1500, 3000, 6000), increase two variables:
  * **Warp Speed** - How fast gates and the background scroll.
  * **Gate Density** - How frequently gates spawn (shorter gap between them).
* Both values have a maximum cap (reached at The Deep Void, 6000+ Lightyears).
* No other special mechanics are introduced. Difficulty comes purely from speed and density.

### 3.4 Score Tracking

* Lightyears accumulate automatically based on time survived, scaled by current Warp Speed.
* Display the running Lightyears count on the HUD during gameplay.

---

## Phase 4: UI Overlays & Screen Flow

**Goal:** Build all the Flutter UI screens and wire them to the Flame game engine through the overlay system.

### 4.1 Overlay Registration

Register the following overlay keys in the GameWidget's overlay builder map:

* `Singularity` - Splash screen.
* `CosmicHub` - Main menu.
* `GameHUD` - In-game score and pause button.
* `TemporalStasis` - Pause menu.
* `FormCollapsed` - Game over screen.
* `MorphingManual` - How to play guide.
* `Calibrations` - Haptic toggle.
* `Arsenal` - Cosmetic shop.
* `DataBlackhole` - Privacy policy.

### 4.2 The Singularity (Splash Screen)

* Show the game logo and title text.
* After 2 seconds, automatically transition to the CosmicHub overlay.
* This is the first thing the user sees when opening the app.

### 4.3 Cosmic Hub (Main Menu)

Build the main menu following the DLS layout rules:

* Buttons stacked vertically in the bottom third of the screen.
* "Warp In" as the primary button (cyan border style from DLS).
* "Morphing Manual", "Calibrations", "The Arsenal", and "Data Blackhole" as secondary buttons.
* Tapping "Warp In" removes the menu overlay, shows the GameHUD overlay, and starts/resumes the game engine.

### 4.4 Game HUD

* A lightweight overlay shown during active gameplay.
* Displays Lightyears (top-left) and Star Bits collected this run (below or beside it).
* Shows a small Temporal Stasis (pause) icon button in the top-right.
* All elements respect the 24dp safe area margins from the DLS.

### 4.5 Temporal Stasis (Pause)

* Triggered by the pause icon or when the app is backgrounded.
* Pauses the Flame game engine.
* Shows three options: Break Stasis (resume with 3-2-1 countdown), Calibrations (haptic toggle), and Abandon Orbit (forfeit and return to Cosmic Hub).

### 4.6 Form Collapsed (Game Over)

* Shown when the player fails a gate.
* Displays: Lightyears traveled this run, Star Bits collected this run, and the all-time Sector Best.
* Two action buttons: "Re-Initiate Warp" (restart immediately) and "Return to Hub" (go to main menu).
* At this point, save the run's Star Bits to the lifetime bank and update the Sector Best if this run was a new record.

### 4.7 Morphing Manual (How to Play)

* A static visual overlay with three panels showing each shape-swipe pairing.
* Panel 1: "Tap = Sphere" with an illustration of the circle shape and a circular gate.
* Panel 2: "Swipe Up = Apex" with an illustration of the triangle shape and a triangular gate.
* Panel 3: "Swipe Down = Block" with an illustration of the square shape and a square gate.
* A close/back button to return to the Cosmic Hub.

### 4.8 Calibrations (Settings)

* A single toggle switch for: Haptics (on/off).
* Toggle states are saved to local storage immediately when changed.
* Accessible from both the Cosmic Hub and the Temporal Stasis pause menu.

### 4.9 The Arsenal (Shop)

* A grid displaying 6-8 cosmetic color skin options for the player entity.
* Each skin is a color theme that changes the glow color of all three shape states.
* The default skin (Cyan/Magenta/Yellow) is always unlocked.
* Other skins have a fixed Star Bits price displayed on them.
* Tapping a locked skin with enough Star Bits unlocks it and deducts the cost.
* Tapping an unlocked skin equips it.
* The currently equipped skin is visually highlighted.
* Purchases are saved to local storage.

### 4.10 Data Blackhole (Privacy Policy)

* A scrollable text screen with the privacy policy statement.
* Content: "Neon Grid Action Runner is a fully offline game. It does not collect, store, or transmit any personal data, usage analytics, or telemetry. All game data (scores, preferences, purchases) is stored locally on your device."
* A close/back button to return to the Cosmic Hub.

---

## Phase 5: Star Bits, Haptics & Polish

**Goal:** Add the currency pickups, haptic feedback, and all the game-feel polish that makes the game feel complete and publishable.

### 5.1 Star Bit Pickups

* Create a Star Bit component - a small, glowing white sprite with a cyan outer glow.
* Star Bits spawn in the gaps between gates, managed by the gate manager.
* When the player touches a Star Bit (any shape state), it is collected: the pickup disappears with a small scale-down/fade animation, the HUD counter increments, and a haptic pulse fires.
* Star Bits are added to the lifetime bank only when the run ends (on the Form Collapsed screen).

### 5.2 Haptic Feedback

The game has no music or sound effects. All player feedback is delivered through haptics.

* A light haptic tap on each morph.
* A medium haptic pulse on Star Bit collection.
* A strong haptic burst on Form Collapsed (crash).
* All haptics respect the Calibrations toggle.

### 5.3 Visual Polish

* **Morph animation:** Squash-and-stretch scale effect on shape change (~150ms), as specified in the DLS.
* **Gate pass effect:** A brief flash or glow on the player entity when successfully passing a gate.
* **Form Collapsed effect:** Camera shake and a brief red-orange screen flash.
* **Parallax speed:** Background scroll speed should visibly increase as Sectors advance, reinforcing the sense of acceleration.

---

## Phase 6: Final Integration & Play Store Preparation

**Goal:** Tie everything together, test, and prepare for Google Play submission.

### 6.1 Full Flow Testing

Test the complete user journey end-to-end:

* App opens to Singularity (splash) then auto-transitions to Cosmic Hub.
* "Warp In" starts gameplay with HUD visible.
* Swiping changes shapes, gates scroll, Star Bits are collectable.
* Difficulty increases through all Sectors.
* Dying shows Form Collapsed with correct stats.
* "Re-Initiate Warp" restarts cleanly. "Return to Hub" returns to Cosmic Hub cleanly.
* Pause works. Resume countdown works. Abandon Orbit works.
* Morphing Manual displays correctly.
* Calibrations haptic toggle works and persists across app restarts.
* Arsenal allows purchasing and equipping skins with Star Bits.
* Data Blackhole displays the privacy policy.
* All local storage (Star Bits, high score, skins, settings) persists across app restarts.

### 6.2 Performance

* Run the app in profile mode on a physical Android device.
* Ensure consistent 60fps during gameplay, especially in higher-speed Sectors.
* Verify that the object pooling for gates prevents memory allocation spikes.

### 6.3 App Icon & Store Assets

* Create an app icon that reflects the Neon Grid Action Runner identity (a glowing shape on the Deep Space background).
* Prepare Play Store listing assets: feature graphic, screenshots of key screens (gameplay, menu, shop).

### 6.4 Android Configuration

* Set the app's minimum SDK version, target SDK version, and version code/name appropriately.
* Configure the app signing for release builds.
* Ensure the AndroidManifest has the correct app name and permissions (no special permissions should be needed since the app is fully offline).

### 6.5 Google Play Compliance

* Confirm the Data Blackhole (privacy policy) is accessible from the main menu.
* The game must present as a complete, polished product: multiple screens, clear visual identity, progression mechanics, haptic feedback, and a shop. This combination should comfortably exceed Google Play's minimum quality bar.
* Fill out the Play Store data safety questionnaire accurately: no data collection, fully offline, no ads, no third-party SDKs collecting data.

---

## Summary: Build Order at a Glance

1. **Phase 1** - Dependencies, asset folders, DLS theme, game class setup.
2. **Phase 2** - Player, swipe controls, gates, pass/fail logic. You should have a playable prototype.
3. **Phase 3** - Object pooling, parallax background, Sector difficulty scaling, score tracking. The game is now infinite and gets harder.
4. **Phase 4** - All UI screens (splash, menu, HUD, pause, game over, how-to-play, settings, shop, privacy policy). The game now has a complete user flow.
5. **Phase 5** - Star Bits, haptics, visual polish. The game now feels good.
6. **Phase 6** - End-to-end testing, performance tuning, store assets, Android config, Play Store submission.
