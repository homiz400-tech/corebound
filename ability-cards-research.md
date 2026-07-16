# Ability-Card System — Research Summary (Corebound #5)

Scope: how ability cards function inside the **timed solo dig run** (v1, no multiplayer).

## Cards in scope (from original concept)
- **Phase Drill** — pass through one hard-rock block.
- **Sonar** — reveal nearby loot / chests on the minimap for a few seconds.
- **Teleport** — blink up one layer band (toward surface) or to last safe point.
- **Shield Burst** — restore 1–2 shield plates instantly.
- (Open list; more can be added as fog clears.)

## Key decisions

### 1. Consumable vs cooldown
**Hybrid, biased consumable:**
- Cards are found in the run (chests + rare drops) and stored in a small **card belt** (recommend 3 slots, matching thumb reach — see #3 HUD).
- Each card is **single-use (consumable)**. This keeps the timed-run tension high: you spend, not stack.
- Exception: a future "charged" variant could be cooldown-based, but v1 = consumable only. Simpler, ponytail-aligned.

### 2. How found
- **Colored chests** (concept) drop cards + rare Core-mon. Chest-color loot tables are fog.
- Small chance a dug block drops a card directly (keeps inventory flowing).

### 3. How triggered on mobile (one-thumb context)
- Card belt rendered as 3 tappable icons at the bottom corner, within thumb reach.
- **Tap icon = activate** that card immediately (no drag conflict — drag is aim, tap is card, matches #3 input split).
- No casting cursor for v1: cards are instant-effect to avoid a second input mode.

### 4. Interaction with shield model (#4) and timer (#7)
- **Shield Burst** directly restores plates (links to the 5-plate run model).
- **Teleport** is a panic escape from a hazard/DoT tile — preserves plates.
- **Phase Drill / Sonar** are progress/economy cards; they don't touch plates but save time on the run timer.
- The **run timer** (#7) is the global pressure: cards that save time (Sonar, Phase Drill) and cards that save plates (Shield Burst, Teleport) are the two ways to beat the clock+death pressure.

## Godot 4 implementation sketch (feasibility, all validated)
- Card data = `Resource` (`.tres`): `name`, `effect_type`, `value`, `icon`. Human-readable text, diffable.
- Effect logic = `CardEffect` script switched on `effect_type`.
- Belt UI = `HBoxContainer` of `TextureButton` (tap = `pressed`), same pattern as #6 loadout.
- Cooldown/consumable state = plain `bool`/`int` on the run controller.
- Timer = `Timer` node (already standard in 4.x).

## Caveats / links
- Exact card count in belt (3), drop rates, and chest-color tables = tuning → fog + #7.
- Cooldown variant deferred; v1 consumable only.
- Cards in combat instance (#4 auto-battler) are a SEPARATE system (Core-mon abilities), not these run cards — keep distinct.
