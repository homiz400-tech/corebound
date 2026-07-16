extends CharacterBody2D

# Corebound control prototype.
# One-thumb model: drag to aim (down = dig toward core, up = retreat to surface,
# left/right = traverse the layer band). Tap (no drag) toggles auto-dig on/off.
# The drill auto-moves in the aimed direction while digging is ON.

const DIG_SPEED := 160.0

var digging := true
var aim := Vector2(0, 1)        # default aim: down toward core
var drag_start := Vector2.ZERO
var dragging := false

@onready var arrow: Sprite2D = $AimArrow

func _ready() -> void:
	# Flat cel-blocky drill body (replaces empty sprite from control prototype).
	var body := $Body
	body.texture = _make_drill_texture()

func _make_drill_texture() -> ImageTexture:
	# 36x36 flat yellow block with a dark 3px outline -> cel-blocky look.
	var s := 36
	var img := Image.create(s, s, false, Image.FORMAT_RGBA8)
	img.fill(Palette.OUTLINE)
	img.fill_rect(Rect2i(3, 3, s - 6, s - 6), Palette.DRILL)
	var tex := ImageTexture.create_from_image(img)
	return tex

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			dragging = true
			drag_start = event.position
		else:
			# Released with negligible movement => treat as tap => toggle dig.
			if dragging and drag_start.distance_to(event.position) < 12:
				digging = not digging
			dragging = false
	elif event is InputEventScreenDrag:
		# Aim toward the drag direction (normalized); bias downward is natural.
		var dir: Vector2 = (event.position - drag_start).normalized()
		if dir.length() > 0.1:
			aim = dir
			arrow.rotation = dir.angle() + PI / 2.0

func _physics_process(_delta: float) -> void:
	if digging:
		velocity = aim * DIG_SPEED
	else:
		velocity = Vector2.ZERO
	arrow.visible = digging
	move_and_slide()
