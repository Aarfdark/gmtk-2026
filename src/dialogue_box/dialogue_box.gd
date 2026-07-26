class_name DialogBox
extends RichTextLabel

signal dialog_line_finished

@export var current_dialogue: PackedStringArray

var typing_timer: Timer = Timer.new()
var typing_speed: float = 0.03

var dialog_pause: Timer = Timer.new()
var dialog_pause_time: float = 1.0
var num_dialogue: int = 0
var cur_line: String

var dialogue_queue: Array[Dialog] = [] # Likely should be updated so dialog is a custome resource


func _ready() -> void:
	typing_timer.timeout.connect(_on_typing_timer_timeout)
	add_child(typing_timer)

	dialog_pause.one_shot = true

	dialog_pause.timeout.connect(play_next_line)
	add_child(dialog_pause)


func init_game_state(gs: GameState) -> void:
	gs.dialog_reached.connect(queue_dialog)
	gs.check_dialog()


func queue_dialog(to_queue: Dialog) -> void:
	print(to_queue)
	dialogue_queue.append(to_queue)
	if typing_timer.is_stopped() and dialog_pause.is_stopped():
		play_next_dialog()
		print("play")


func display_text(line: String) -> void:
	text = line
	visible_characters = 0
	typing_timer.start(typing_speed)


func _on_typing_timer_timeout() -> void:
	if visible_characters < cur_line.length():
		visible_characters += 1
	else:
		typing_timer.stop()
		dialog_pause.start(dialog_pause_time)


func play_next_line() -> void:
	if num_dialogue == current_dialogue.size():
		play_next_dialog()
		return
	cur_line = current_dialogue.get(num_dialogue)
	display_text(cur_line)
	num_dialogue += 1


func play_next_dialog() -> void:
	if dialogue_queue.is_empty():
		return
	var d: Dialog = dialogue_queue.pop_front()
	current_dialogue = d.lines.split("\n")
	num_dialogue = 0


func _input(event: InputEvent) -> void:
	if not ProjectSettings.get_setting("custom/enable_debug_keybinds"):
		return
	if event.is_action_pressed("DEBUG_increment_sands"):
		pass
# add to queue -> if paused then play_next_dialog
# dialog start -> play line -> next line[loop] -> play_next_dialog
# typing timer finished -> if more lines, play next line else if more dialog play next dialog
