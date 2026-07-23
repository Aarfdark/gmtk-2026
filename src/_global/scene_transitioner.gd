extends Node

@onready var radial_black: TextureProgressBar = $RadialBlack

var _root_window: Window
var tween: Tween


func _ready() -> void:
	_root_window = get_tree().root
	_root_window.remove_child.call_deferred(self)


func go_to_scene(path: String) -> void:
	_root_window.add_child(self)
	ResourceLoader.load_threaded_request(path)
	await wipe_to_black()
	get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(path))
	await wipe_from_black()
	_root_window.remove_child.call_deferred(self)


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("DEBUG_increment_sands"):
		wipe_to_black()
	if event.is_action_pressed("DEBUG_decrement_sands"):
		wipe_from_black()


func wipe_to_black(duration: float = 0.7) -> void:
	if tween and tween.is_running():
		push_error("Tried to tween while already running")
		return
	radial_black.fill_mode = TextureProgressBar.FILL_COUNTER_CLOCKWISE
	tween = create_tween().set_parallel().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(radial_black, "value", 100.0, duration).from(0.0)
	await tween.finished


func wipe_from_black(duration: float = 0.7) -> void:
	if tween and tween.is_running():
		push_error("Tried to tween while already running")
		return
	radial_black.fill_mode = TextureProgressBar.FILL_CLOCKWISE
	tween = create_tween().set_parallel().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(radial_black, "value", 0.0, duration).from(100.0)
	await tween.finished
