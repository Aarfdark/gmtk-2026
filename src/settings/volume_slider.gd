class_name VolumeSlider
extends Slider

@export var bus_name: String

@onready var bus_index: int = AudioServer.get_bus_index(bus_name)


func _ready() -> void:
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	value_changed.emit(value)


func _on_value_changed(new_value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(new_value))
