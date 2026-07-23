class_name TimeLabel
extends Label

@export var game_state: GameState:
	set(value):
		game_state = value
		if not is_node_ready():
			await ready
		game_state.changed.connect(_on_game_state_changed)
		_on_game_state_changed()
@export var convert_to_iso: bool


func _on_game_state_changed() -> void:
	if convert_to_iso:
		text = game_state.get_datetime()
	else:
		text = "%010d" % game_state.seconds_remaining
