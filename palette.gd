extends Node

# Corebound flat / cel-blocky palette (§art-style decision).
# Vibrant, high-contrast, readable on phone. Single source of truth for colors.

# Layer bands (top = surface, bottom = core)
const SURFACE   := Color(0.55, 0.80, 0.95, 1)  # warm sky
const CRUST     := Color(0.80, 0.62, 0.40, 1)  # outer crust earth
const MANTLE    := Color(0.62, 0.42, 0.55, 1)  # moderate hazard band
const CORE      := Color(0.95, 0.45, 0.30, 1)  # hot core

# Entities
const DRILL     := Color(0.95, 0.85, 0.20, 1)  # bright drill yellow
const PLATE     := Color(0.30, 0.85, 1.0, 1)   # shield cyan
const CARD      := Color(0.65, 0.45, 0.95, 1)  # ability purple
const COREMON   := Color(0.40, 0.95, 0.55, 1)  # core-mon green
const CHEST     := Color(0.95, 0.70, 0.20, 1)  # chest gold

# Hazards
const HAZARD    := Color(0.95, 0.25, 0.35, 1)  # trap red
const BURN      := Color(1.0, 0.55, 0.15, 1)   # fire orange
const POISON    := Color(0.55, 0.85, 0.25, 1)  # toxic green

# UI / outline
const OUTLINE   := Color(0.07, 0.05, 0.12, 1)  # near-black outline
const BG_DARK   := Color(0.12, 0.09, 0.18, 1)  # backdrop
