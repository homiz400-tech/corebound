extends Node2D

# Corebound v1 run vertical slice (prototype for #7).
# Wires together the locked pillars:
#   #3 drag-to-aim + tap-to-stop drill
#   #4 5 shield plates, 0 = death + lose inventory
#   #5 3-slot consumable ability cards (tap to use)
#   #6 4 Core-mon loadout -> auto-battler on boss
# Plus the timed-run-to-boss loop beats.

const RUN_TIME := 90.0
const MAX_PLATES := 5

var plates := MAX_PLATES
var time_left := RUN_TIME
var reached_boss := false
var belt := ["Phase Drill", "Sonar", "Shield Burst"]   # 3 slots (#5)

@onready var plates_label: Label = $HUD/Plates
@onready var timer_label: Label = $HUD/Timer
@onready var boss_prompt: Label = $HUD/BossPrompt
@onready var cards_box: HBoxContainer = $HUD/Cards

func _ready() -> void:
	for c in belt:
		var b := Button.new()
		b.text = c
		b.pressed.connect(_use_card.bind(c))
		cards_box.add_child(b)
	_update_hud()

func _use_card(name: String) -> void:
	match name:
		"Shield Burst":
			plates = mini(plates + 2, MAX_PLATES)
		"Phase Drill", "Sonar":
			pass  # demo: no world yet; effect hooks live in #7 follow-up
	plates = maxi(plates - 0, 0)
	_update_hud()
	print("used card: ", name)

func _on_hazard() -> void:   # called by future trap tiles (#4 burn/poison)
	plates -= 1
	if plates <= 0:
		_die()
	_update_hud()

func _physics_process(delta: float) -> void:
	if reached_boss:
		return
	time_left -= delta
	if time_left <= 0:
		_die()
	_update_hud()

func _reach_boss() -> void:
	reached_boss = true
	boss_prompt.text = "BOSS! Auto-battle with 4 Core-mon"
	print("boss reached -> launch auto-battler (#4/#6)")

func _die() -> void:
	boss_prompt.text = "DIED - run inventory lost"
	print("death: 0 plates or timer -> lose run inventory")
	get_tree().paused = true

func _update_hud() -> void:
	plates_label.text = "Plates: %d/%d" % [plates, MAX_PLATES]
	timer_label.text = "Time: %d" % int(ceil(time_left))
