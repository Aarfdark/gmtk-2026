extends Node2D

@onready var hand: Sprite2D = $Hand
@onready var hand_pos := hand.global_position
@onready var last_rotation := hand.rotation

var mouse_on_hand := false
var clicking_on_hand := false
var progress: float = 0.0
var rot_speed: float = PI/45
var angle_threshold = PI/60

signal revolution_completed

var debug = 0
func _physics_process(_delta: float) -> void:	
	if !clicking_on_hand:
		return
	
	hand.look_at(get_global_mouse_position())
	#var hand_to_mouse_vec := get_global_mouse_position() - position
	#var hand_to_mouse_dir := atan2(hand_to_mouse_vec.y, hand_to_mouse_vec.x)
	#
	#if hand.rotation + hand_to_mouse_dir < angle_threshold:
		#hand.look_at(get_global_mouse_position())
	#if hand.rotation > hand_to_mouse_dir + angle_threshold:
		#hand.rotate(-rot_speed)
	#elif hand.rotation < hand_to_mouse_dir - angle_threshold:
		#hand.rotate(rot_speed)
	#else:
		#hand.look_at(get_global_mouse_position())
	
	progress += hand.rotation - last_rotation
	last_rotation = hand.rotation
	
	if progress <= -TAU: # one counter-clockwise rotation
		progress += TAU
		revolution_completed.emit()
	elif progress >= TAU: # one clockwise rotation (doesn't do anything)
		progress -= TAU
	
	############# DEBUG #############
	#if debug == (1)*60:
		#debug = 0
		#print("hand_rotation: %f | hand_to_mouse_dir: %f" % [hand.rotation, hand_to_mouse_dir])
	#debug += 1
	############# DEBUG #############

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
