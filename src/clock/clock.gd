extends Node2D

@onready var hand: Sprite2D = $Hand
@onready var hand_pos := hand.global_position
@onready var last_rotation := hand.rotation

var mouse_on_hand := false
var clicking_on_hand := false
var progress: float = 0.0

signal revolution_completed

var debug = 0
func _physics_process(_delta: float) -> void:
	############# DEBUG #############
	#if debug == (0.5)*60:
		#print("progress: %f" % progress)
		#debug = 0
	#debug += 1
	############# DEBUG #############
	
	if !clicking_on_hand:
		return
		
	hand.look_at(get_global_mouse_position())
	progress += hand.rotation - last_rotation
	last_rotation = hand.rotation
	
	if progress <= -TAU: # one counter-clockwise rotation
		progress += TAU
		revolution_completed.emit()
	if progress >= TAU: # one clockwise rotation (doesn't do anything)
		progress -= TAU

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		if mouse_on_hand:
			clicking_on_hand = !clicking_on_hand
		else:
			if clicking_on_hand:
				clicking_on_hand = false
	

func _on_area_2d_mouse_entered() -> void:
	mouse_on_hand = true

func _on_area_2d_mouse_exited() -> void:
	mouse_on_hand = false
