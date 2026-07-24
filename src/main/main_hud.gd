class_name MainHUD
extends Control

@export var game_state: GameState:
	set(value):
		game_state = value
		if not is_node_ready():
			await ready
		time_label_iso.game_state = game_state
		time_label_unix.game_state = game_state
		shop_panel.game_state = game_state
		sands_label.game_state = game_state

@onready var sands_label: SandsLabel = %SandsLabel
@onready var time_label_iso: TimeLabel = %TimeLabelISO
@onready var time_label_unix: TimeLabel = %TimeLabelUnix
@onready var shop_panel: ShopPanel = %ShopPanel
@onready var settings_menu: Control = %SettingsMenu

var _tick_progress: float = 0.0


func _unhandled_key_input(event: InputEvent) -> void:
	if not ProjectSettings.get_setting("custom/enable_debug_keybinds"):
		return
	if event.is_action_pressed("DEBUG_go_to_title"):
		get_tree().change_scene_to_file("uid://d0dn16nq6qsd7")


func _process(delta: float) -> void:
	var time_diff: float = delta * game_state.ticks_per_second + _tick_progress
	game_state.seconds_remaining += int(time_diff)
	_tick_progress = fmod(time_diff, 1.0)


func _on_clock_revolution_completed() -> void:
	game_state.seconds_remaining -= game_state.seconds_per_revolution


func _on_settings_button_pressed() -> void:
	settings_menu.visible = true
