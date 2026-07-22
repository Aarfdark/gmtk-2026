class_name MainHUD
extends Control

@export var game_state: GameState

@onready var sands_label: Label = %SandsLabel

func _ready() -> void:
	game_state.changed.connect(_on_game_state_changed)
	_on_game_state_changed()

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
