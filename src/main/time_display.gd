extends Label
@export var unix_time: UnixSeconds

func _process(_delta: float) -> void:
	text = Time.get_datetime_string_from_unix_time(unix_time.unix_seconds, true)
	#text = "%d" % unix_time.unix_seconds
