extends Node2D

# Flat cel-block: a square fill with a dark outline. The visual unit of the dig
# world. Set `band` to recolor per layer (surface/crust/mantle/core).

const SIZE := 48

@export var band: int = 1   # 0 surface,1 crust,2 mantle,3 core

@onready var fill: Polygon2D = $Fill
@onready var outline: Line2D = $Outline

func _ready() -> void:
	var half := SIZE / 2.0
	var corners := PackedVector2Array([
		Vector2(-half, -half), Vector2(half, -half),
		Vector2(half, half), Vector2(-half, half)
	])
	fill.polygon = corners
	outline.points = PackedVector2Array(corners)
	outline.add_point(corners[0])  # close the loop
	_apply_color()

func _apply_color() -> void:
	match band:
		0: fill.color = Palette.SURFACE
		1: fill.color = Palette.CRUST
		2: fill.color = Palette.MANTLE
		3: fill.color = Palette.CORE
		_: fill.color = Palette.CRUST

func set_band(b: int) -> void:
	band = b
	if is_inside_tree():
		_apply_color()
