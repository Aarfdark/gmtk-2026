extends Node2D

var mouse_on_second_hand


func _on_area_2d_area_entered(area: Area2D) -> void:
	mouse_on_second_hand = true

func _on_area_2d_area_exited(area: Area2D) -> void:
	mouse_on_second_hand = false
