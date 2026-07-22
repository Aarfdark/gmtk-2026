class_name GameState
extends Resource

signal countdown_ended

const STARTING_SECONDS = 1785085200 # 2026-07-26 17:00:00

@export var seconds_remaining: int = STARTING_SECONDS:
	set(value):
		if value == seconds_remaining:
			return
		if value < 0:
			seconds_remaining = 0
			if not _end_fired:
				countdown_ended.emit()
				_end_fired = true
		else:
			seconds_remaining = value
		emit_changed()
@export var sands: int = 0:
	set(value):
		if value == sands:
			return
		if value < 0:
			push_error("Sand went into debt")
			sands = 0
			return
		sands = value
		emit_changed()

var _end_fired: bool = false

func get_datetime() -> String:
	return Time.get_datetime_string_from_unix_time(seconds_remaining, true)
