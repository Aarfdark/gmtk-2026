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
		text = Time.get_datetime_string_from_unix_time(game_state.seconds_remaining, true)
	else:
		text = "%d" % game_state.seconds_remaining
