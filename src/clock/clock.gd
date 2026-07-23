extends Node2D

signal revolution_completed

@export_range(1, 25, 0.5) var follow_rate: float = 8
@export_enum("Toggle Click", "Click and Hold") var input_method: String

@onready var hand: Node2D = $Hand
@onready var last_rotation := hand.rotation

var hovering := false
var grabbing := false
var progress: float = 0.0


func _physics_process(delta: float) -> void:
	if not grabbing:
		return

	_drag_towards_mouse(delta)

	progress += hand.rotation - last_rotation
	last_rotation = hand.rotation

	if progress <= -TAU:  # one counter-clockwise rotation
		progress += TAU
		revolution_completed.emit()
	elif progress >= TAU:  # one clockwise rotation (doesn't do anything)
		progress -= TAU
		

func _input(event: InputEvent) -> void:
	#print("Input method from Settings.input_method: %d" % Settings.input_method)
	if input_method == "Toggle Click":
		if event.is_action_pressed("grab"):
			if hovering:
				grabbing = not grabbing
			else:
				grabbing = false
	elif input_method == "Click and Hold":
		if event.is_action_pressed("grab"):
			if hovering:
				grabbing = true
			else:
				grabbing = false
		elif event.is_action_released("grab"):
			grabbing = false


func _drag_towards_mouse(delta: float) -> void:
	var target_angle: float = get_angle_to(get_global_mouse_position())
	var starting_angle: float = hand.rotation
	var dist: float = starting_angle - target_angle
	if abs(dist + TAU) < abs(dist):
		starting_angle += TAU
		progress -= TAU
	elif abs(dist - TAU) < abs(dist):
		starting_angle -= TAU
		progress += TAU
	# slower if going the wrong way
	var decay: float = 1.0 if starting_angle < target_angle else follow_rate
	hand.rotation = Utils.exp_decay(starting_angle, target_angle, delta, decay)


func _on_area_2d_mouse_entered() -> void:
	hovering = true


func _on_area_2d_mouse_exited() -> void:
	hovering = false
