@tool
class_name SandsLabel
extends Label

@export var format_string: String = "%d":
	set(value):
		format_string = value
		if not game_state:
			text = format_string % 0
			return
		_on_game_state_changed()
@export var game_state: GameState:
	set(value):
		game_state = value
		if not is_node_ready():
			await ready
		game_state.changed.connect(_on_game_state_changed)


func _on_game_state_changed() -> void:
	text = format_string % game_state.sands
