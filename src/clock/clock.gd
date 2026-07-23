extends Node2D

signal revolution_completed

@export_range(1, 25, 0.5) var follow_rate: float = 4.0
@export_enum("Toggle Click", "Click and Hold") var input_method: String
@export var halo_change_rate: float = 5.0

var hovering := false
var grabbing := false
var progress: float = 0.0

@onready var halo: Sprite2D = $Halo
@onready var hand: Node2D = $Hand
@onready var last_rotation := hand.rotation
@onready var sand_particles: CPUParticles2D = %SandParticles


func _physics_process(delta: float) -> void:
	if not grabbing:
		halo.modulate.a = move_toward(halo.modulate.a, 0.0, delta * halo_change_rate)
		return

	_drag_towards_mouse(delta)

	progress += hand.rotation - last_rotation
	last_rotation = hand.rotation

	if progress <= -TAU:  # one counter-clockwise rotation
		progress += TAU
		sand_particles.emitting = true
		var tween := create_tween().set_trans(Tween.TRANS_QUART)
		tween.tween_property(halo, "modulate", Color(Color.YELLOW, 0.0), 0.3).from(Color.YELLOW)
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
	var wrong_way: bool = starting_angle < target_angle
	var decay: float
	if wrong_way:
		halo.modulate = Color(Color.RED, halo.modulate.a)
		halo.modulate.a = move_toward(halo.modulate.a, 1.0, delta * halo_change_rate)
		decay = 0.5
	else:
		halo.modulate.a = move_toward(halo.modulate.a, 0.0, delta * halo_change_rate)
		decay = follow_rate
	hand.rotation = Utils.exp_decay(starting_angle, target_angle, delta, decay)


func _on_area_2d_mouse_entered() -> void:
	hovering = true


func _on_area_2d_mouse_exited() -> void:
	hovering = false
