extends Control

@export var next_scene: String = "uid://ccjvmkggl25xu"


func _on_start_button_pressed() -> void:
	SceneTransitioner.go_to_scene(next_scene)
