class_name MainHUD
extends Control

@export var game_state: GameState:
	set(value):
		game_state = value
		if not is_node_ready():
			await ready
		time_label_iso.game_state = game_state
		time_label_unix.game_state = game_state
		game_state.changed.connect(_on_game_state_changed)
		_on_game_state_changed()

@onready var sands_label: Label = %SandsLabel
@onready var time_label_iso: TimeLabel = %TimeLabelISO
@onready var time_label_unix: TimeLabel = %TimeLabelUnix


func _unhandled_input(event: InputEvent) -> void:
	if not OS.is_debug_build():
		return
	if event.is_action_pressed("DEBUG_increment_sands"):
		game_state.sands += 100
	if event.is_action_pressed("DEBUG_decrement_sands"):
		game_state.sands -= 100


func _on_game_state_changed() -> void:
	sands_label.text = "Sands: %d" % game_state.sands


func _on_upgrade_button_pressed(upgrade: Upgrade) -> void:
	# TODO: implement
	print("bought upgrade: %s" % upgrade.name)


func _on_clock_revolution_completed() -> void:
	game_state.seconds_remaining -= 60
