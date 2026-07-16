extends Node2D

# Diggable world grid (flat/cel-blocky, Kenney CC0 tiles).
# Builds layered bands from surface (top) to core (bottom). The drill breaks the
# block it overlaps while digging (#3). Chest blocks drop loot (#5).

const COLS := 9
const TILE := 64
const ROWS := 40
const MARGIN_X := 12

# band boundaries (row index where each band starts)
const BAND_SURFACE := 0
const BAND_CRUST := 4
const BAND_MANTLE := 16
const BAND_CORE := 30

var block_scenes := {}
var grid := {}   # "c,r" -> Sprite2D (or null if dug)

@onready var blocks_node: Node2D = $Blocks

func _ready() -> void:
	block_scenes = {
		BAND_SURFACE: preload("res://assets/tiles/surface.png"),
		BAND_CRUST: preload("res://assets/tiles/crust.png"),
		BAND_MANTLE: preload("res://assets/tiles/mantle.png"),
		BAND_CORE: preload("res://assets/tiles/core.png"),
	}
	_build_grid()
	# Hook drill digging into block breaking.
	$Drill.digged.connect(_on_drill_digged)

func _band_for_row(r: int) -> int:
	if r >= BAND_CORE: return BAND_CORE
	if r >= BAND_MANTLE: return BAND_MANTLE
	if r >= BAND_CRUST: return BAND_CRUST
	return BAND_SURFACE

func _build_grid() -> void:
	var origin_x := MARGIN_X
	for r in ROWS:
		for c in COLS:
			var tex: Texture2D = block_scenes[_band_for_row(r)]
			var s := Sprite2D.new()
			s.texture = tex
			s.position = Vector2(origin_x + c * TILE + TILE/2, r * TILE + TILE/2)
			# every 7th block in mantle/core is a chest (rare Core-mon drop, #5/#6)
			if r >= BAND_MANTLE and (c + r) % 11 == 0:
				s.texture = preload("res://assets/tiles/chest.png")
				s.add_to_group("chest")
			blocks_node.add_child(s)
			grid["%d,%d" % [c, r]] = s

func _on_drill_digged(pos: Vector2) -> void:
	# Find the block under the drill and remove it.
	var c := int((pos.x - MARGIN_X) / TILE)
	var r := int(pos.y / TILE)
	var key := "%d,%d" % [c, r]
	if grid.has(key) and grid[key] != null:
		var b: Sprite2D = grid[key]
		var is_chest := b.is_in_group("chest")
		b.queue_free()
		grid[key] = null
		if is_chest:
			print("chest broken -> drop Core-mon / cards (#5/#6)")
		else:
			print("block dug")
