extends Node2D

# Art-demo scene: shows the flat/cel-blocky palette (§art-style decision).
# Draws one block per layer band + the drill + a 5-plate HUD row.

func _ready() -> void:
	var plates := $HUD/Plates
	for i in 5:
		var p := Panel.new()
		p.custom_minimum_size = Vector2(28, 28)
		var sb := StyleBoxFlat.new()
		sb.bg_color = Palette.PLATE
		sb.border_color = Palette.OUTLINE
		sb.border_width_left = 3
		sb.border_width_top = 3
		sb.border_width_right = 3
		sb.border_width_bottom = 3
		p.add_theme_stylebox_override("panel", sb)
		plates.add_child(p)
