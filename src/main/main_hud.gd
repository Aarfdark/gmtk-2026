class_name MainHUD
extends Control

@export var game_state: GameState:
	set(value):
		game_state = value
		if not is_node_ready():
			await ready
		time_label_iso.game_state = game_state
		time_label_unix.game_state = game_state
		sands_label.game_state = game_state

@onready var sands_label: SandsLabel = %SandsLabel
@onready var time_label_iso: TimeLabel = %TimeLabelISO
@onready var time_label_unix: TimeLabel = %TimeLabelUnix
@onready var settings_menu: Control = %SettingsMenu
@onready var upgrade_button_grid: FlowContainer = %UpgradeButtonGrid

var _tick_progress: float = 0.0

func _process(delta: float) -> void:
	var time_diff: float = delta * game_state.ticks_per_second + _tick_progress
	game_state.seconds_remaining += int(time_diff)
	_tick_progress = fmod(time_diff, 1.0)

#func _unhandled_input(event: InputEvent) -> void:
	#if not OS.is_debug_build():
		#return
	#if event.is_action_pressed("DEBUG_increment_sands"):
		#instantiate_button(load("res://upgrades/second_hand.tres"))
	#if event.is_action_pressed("DEBUG_decrement_sands"):
		#game_state.sands -= 100
	
func _on_game_state_changed() -> void:
	sands_label.text = "Sands: %d" % game_state.sands

func _on_clock_revolution_completed() -> void:
	game_state.seconds_remaining -= game_state.seconds_per_revolution

func _on_settings_button_pressed() -> void:
	settings_menu.visible = true
