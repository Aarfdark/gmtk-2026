extends Node2D

signal revolution_completed

@onready var hand: Node2D = $Hand
@onready var hand_pos := hand.global_position
@onready var last_rotation := hand.rotation

var hovering_hand := false
var grabbing_hand := false
var progress: float = 0.0
var rot_speed: float = PI / 45
var angle_threshold = PI / 60

var debug = 0


func _physics_process(_delta: float) -> void:
	if not grabbing_hand:
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

	if progress <= -TAU:  # one counter-clockwise rotation
		progress += TAU
		revolution_completed.emit()
	elif progress >= TAU:  # one clockwise rotation (doesn't do anything)
		progress -= TAU

	############# DEBUG #############
	#if debug == (1)*60:
	#debug = 0
	#print("hand_rotation: %f | hand_to_mouse_dir: %f" % [hand.rotation, hand_to_mouse_dir])
	#debug += 1
	############# DEBUG #############


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("grab"):
		if hovering_hand:
			grabbing_hand = not grabbing_hand
		else:
			grabbing_hand = false


func _on_area_2d_mouse_entered() -> void:
	hovering_hand = true


func _on_area_2d_mouse_exited() -> void:
	hovering_hand = false
