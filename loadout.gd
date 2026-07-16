extends Control

# Core-mon loadout picker prototype.
# Decision under test: how many slots fit a phone portrait view while staying
# tappable + readable. Loadout size is a single const -> flip 3/4/5 to compare.

const SLOT_COUNT := 4
const CARD_W := 120
const CARD_H := 160

# Fake collected Core-mon pool (HP / defence) the player picks from.
const POOL := [
	{"name": "Emberling", "hp": 40, "def": 6},
	{"name": "Tidewisp",  "hp": 32, "def": 10},
	{"name": "Boulderon", "hp": 55, "def": 3},
	{"name": "Zephyra",   "hp": 28, "def": 8},
	{"name": "Gloomaw",   "hp": 46, "def": 5},
	{"name": "Sparkrit",  "hp": 35, "def": 7},
]

var selected := []   # indices into POOL

func _ready() -> void:
	var slots := $Slots
	slots.custom_minimum_size = Vector2(SLOT_COUNT * (CARD_W + 12), CARD_H)
	for i in SLOT_COUNT:
		var card := _make_card(i)
		slots.add_child(card)
	$FightButton.pressed.connect(_on_fight)

func _make_card(slot_idx: int) -> Panel:
	var p := Panel.new()
	p.custom_minimum_size = Vector2(CARD_W, CARD_H)
	p.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	var mon: Dictionary = POOL[slot_idx % POOL.size()]
	var lbl := Label.new()
	lbl.text = "%s\nHP %d\nDEF %d" % [mon.name, mon.hp, mon.def]
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	lbl.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	p.add_child(lbl)
	p.gui_input.connect(_on_card_tap.bind(slot_idx))
	return p

func _on_card_tap(ev: InputEvent, slot_idx: int) -> void:
	if ev is InputEventMouseButton and ev.pressed:
		# Toggle this slot's selection (simple demo: cycles the pool entry).
		if selected.has(slot_idx):
			selected.erase(slot_idx)
		else:
			selected.append(slot_idx)
		print("selected slots: ", selected)

func _on_fight() -> void:
	print("FIGHT with loadout size ", selected.size(), "/ ", SLOT_COUNT)
