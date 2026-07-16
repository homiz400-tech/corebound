# Corebound — Game Design Document (v1 Solo Loop)

> Status: **Foundations locked.** This doc is the planning artifact the Wayfinder map
> (github.com/homiz400-tech/corebound/issues/1) was charting toward. Every decision
> below is resolved; open items are flagged as FOG and must be specified before build.
> Engine: Godot 4.7.1. Target: Android (portrait). Solo dev, multi-week plan.

---

## 1. Destination & Scope

Corebound is a 2.5D side-view, timed dig-run mobile game. The player drills downward
through layered bands toward a final boss, managing shield plates against hazards,
collecting ability cards and Core-mon, then fights the boss in an auto-battler instance.

**In scope (this doc):** the solo v1 experience — one timed run from surface to boss.
**Out of scope:** online PvP, shared-world sphere, Tunnel Traces, player-looting. These
are a later effort, explicitly deferred until art/controls/loop are proven.

---

## 2. Locked Decisions (from Wayfinder map)

| # | Pillar | Decision |
|---|--------|----------|
| 8 | Dev environment | Godot 4.7.1, JDK 17, Android SDK (API 34), graphify viewer. Headless build verified. |
| 2 | Engine | **Godot 4.7.1** (MIT, free). GDScript only (no Mono/C#). AI-buildable + human-reviewable text scenes. |
| 3 | Control | **One-thumb: drag-to-aim + tap-to-stop.** Auto-dig on by default; drag aims (down=core, up=surface, L/R=traverse); tap toggles dig. |
| 4 | Shield/HP | **Two systems.** Run = 5 shield plates (burn/poison DoT; 0 = death + lose run inventory). Combat = Core-mon HP duel; loser drops 2 plates. |
| 5 | Ability cards | **Hybrid consumable.** 3-slot belt, tap-to-activate, found in chests/drops. Phase Drill, Sonar, Teleport, Shield Burst. |
| 6 | Loadout | **4 Core-mon slots**, player-picked, feed the auto-battler. |
| 7 | Loop | Timed dig-run-to-boss vertical slice (see §4). |

---

## 3. World & Presentation

- **2.5D side-view:** 3D viewport with orthographic camera; layered 2D-style assets.
  Feels 3D, is not. "Spherical layers" = vertical layer bands dug downward; orientable
  within the side view (left/right traverse, up/down depth).
- **Viewport:** portrait 540×960 (phone). Surfaces at top, core/boss at bottom.
- **Art style:** FOG — palette, lighting, particle/screen-shake juice unspecified.
  Target: vibrant, low-poly/stylized, runs on older Android devices.
- **Juice (hook):** satisfying block-break particles, screen shake on rare blocks,
  distinct loot pickup sounds. FOG until art-style decided.

---

## 4. Core Gameplay Loop (v1)

```
[Surface: 5 plates, 90s timer, 3 cards, 4 Core-mon loadout]
   │
   ▼
[Dig down — auto-dig (#3): drag aim, tap stop; break blocks]
   │
   ├──────────────► [Avoid hazards (#4): traps/curses chip plates;
   │                  burn & poison = plate DoT; 0 plates = death + lose inventory]
   │
   ▼
[Discover: colored chests → ability cards (#5) + rare Core-mon; blocks break]
   │
   ▼
[Mid-run decisions: spend cards (tap belt) — Shield Burst +plates,
   Teleport escape, Phase Drill/Sonar save time; race the 90s timer]
   │
   ▼
[Reach boss → auto-battler instance (#4/#6): 4 Core-mon fight;
   first to 0 HP loses; loser drops 2 plates]
   │
   ▼
[Resolve: win = run complete (loot secured); die = lose run inventory;
   surface deposit secures loot]
```

**Timer:** 90s (FOG — tuning). Global pressure linking cards (save time) and plates
(save life).

---

## 5. Systems Detail

### 5.1 Controls (#3)
- Auto-dig ON; velocity = aim × DIG_SPEED.
- Drag → aim vector (arrow HUD shows direction). Tap (negligible drag) → toggle dig.
- Prototype: `drill.gd` / `drill.tscn` (validated). May snap aim to 4/8 directions later.

### 5.2 Shield Plates (#4)
- 5 plates; chipped by traps/curses. Burn & poison = damage-over-time on plates.
- 0 plates → death, lose run inventory (not owned Core-mon).
- Recharge: Shield Batteries in dirt or return to surface.
- Combat loss → −2 plates (links run survival to fights).

### 5.3 Ability Cards (#5)
- 3-slot belt; each card single-use (consumable). Tap icon = activate instantly.
- Found: colored chests + rare block drops.
- Cards: Phase Drill (phase 1 hard block), Sonar (reveal loot), Teleport (blink up
  band / safe point), Shield Burst (+1–2 plates). More FOG.
- Distinct from Core-mon combat abilities (§5.4).
- Research: `ability-cards-research.md`.

### 5.4 Core-mon & Auto-Battler (#4/#6)
- Core-mon = cards with HP + defence. Player picks **4** into a loadout (prototype:
  `loadout.tscn`/`loadout.gd`).
- Boss (and future PvE/PvP) = auto-battler instance: sides resolve automatically on
  stats; player watches. First to 0 HP loses.
- Combat resolution logic = FOG (follow-up build).

### 5.5 Loadout & Collection
- 4 active slots. Collection cap / how many Core-mon held = FOG (rarity/balancing).
- Rare Core-mon from colored chests.

---

## 6. Prototype Assets (built, validated headless)
- `drill.tscn` / `drill.gd` — control prototype (#3).
- `loadout.tscn` / `loadout.gd` — 4-slot picker (#6).
- `run.tscn` / `run.gd` — v1 loop vertical slice (#7), wires #3/#4/#5/#6.
- `ability-cards-research.md` — ability-card research (#5).
- Open with `godot-gui` (see dev-env #8).

---

## 7. FOG — must be specified before/while building
1. **Art style:** palette, lighting, particle/screen-shake juice for 2.5D.
2. **Core-mon:** rarity tiers, stat balancing, collection cap.
3. **Loot economy:** chest-color loot tables, drop rates, material uses.
4. **Hazards:** trap/curse sources, burn/poison tick rates, Shield Battery values.
5. **Boss design:** encounter shape within the timed run; auto-battler resolution.
6. **Tuning:** timer length, plate counts, card belt size confirmation.
7. **graphify:** map the project architecture as systems are built.

## 8. Out of Scope (deferred effort)
- Online PvP sphere, Tunnel Traces (see other players' tunnels), player-looting.
- Begin only after art/controls/loop proven in solo v1.

---

## 9. Next Steps (build phase)
1. Pick an art-style direction (§7.1) — gates all visual work.
2. Build the block/trap world layer (needs §5.2 hazard implementation).
3. Implement chests + Core-mon drops (§5.3/§5.5 loot tables).
4. Implement the auto-battler resolution (§5.4).
5. Tune timer/plates/cards against the vertical slice.
6. Android export via Godot preset (#8) and device test.
