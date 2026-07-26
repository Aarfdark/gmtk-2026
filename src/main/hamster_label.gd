@tool
class_name HamsterLabel
extends Label

@export var format_string: String = "x %.f (%.02f sec/sec)":
	set(value):
		format_string = value
		if not game_state:
			text = format_string % [0, 0]
			return
		_on_game_state_changed()
@export var game_state: GameState:
	set(value):
		game_state = value
		if not is_node_ready():
			await ready
		game_state.changed.connect(_on_game_state_changed)


func _on_game_state_changed() -> void:
	text = format_string % [game_state.hamster_count, game_state.ticks_per_second]
