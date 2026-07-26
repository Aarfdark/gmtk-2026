class_name DateCondition
extends UnlockCondition

@export var datetime_threshold: String:
	set(value):
		datetime_threshold = value
		var secs: int = Time.get_unix_time_from_datetime_string(datetime_threshold)
		if not secs:
			push_error("Invalid datetime: %s" % value)
		num_seconds = secs

var num_seconds: int


func is_condition_cleared(game_state: GameState):
	return num_seconds > game_state.seconds_remaining
