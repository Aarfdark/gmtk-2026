extends Node2D

@onready var hand: Sprite2D = $Hand
@onready var hand_pos := hand.global_position

var mouse_on_hand := false
var clicking_on_hand := false

func _process(_delta: float) -> void:
	if clicking_on_hand:
		var mouse_pos := get_viewport().get_mouse_position()
		hand.look_at(mouse_pos)
		
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") and mouse_on_hand:
		clicking_on_hand = true
	elif event.is_action_released("left_click"):
		clicking_on_hand = false

func _on_area_2d_mouse_entered() -> void:
	mouse_on_hand = true

func _on_area_2d_mouse_exited() -> void:
	mouse_on_hand = false
