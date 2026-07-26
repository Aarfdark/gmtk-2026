class_name DialogBox
extends RichTextLabel

var current_dialogue: PackedStringArray

var typing_timer: Timer = Timer.new()
@export var typing_speed: float = 0.03

# var dialog_pause: Timer = Timer.new()
# @export var dialog_pause_time: float = 1.0
var num_dialogue: int = 0
var cur_line: String

var dialogue_queue: Array[Dialog] = []


func _ready() -> void:
	typing_timer.timeout.connect(_on_typing_timer_timeout)
	add_child(typing_timer)

	# dialog_pause.one_shot=true

	# dialog_pause.timeout.connect(play_next_line)
	# add_child(dialog_pause)


func init_game_state(gs: GameState) -> void:
	gs.dialog_reached.connect(queue_dialog)


func queue_dialog(to_queue: Dialog) -> void:
	dialogue_queue.append(to_queue)
	if is_dialog_completed():
		play_next_dialog()


func is_dialog_completed() -> bool:
	return typing_timer.is_stopped() and num_dialogue == current_dialogue.size()


func display_text(line: String) -> void:
	text = line
	visible_characters = 0
	typing_timer.start(typing_speed)


func _on_typing_timer_timeout() -> void:
	if visible_characters < cur_line.length():
		visible_characters += 1
	else:
		typing_timer.stop()


func play_next_line() -> void:
	if num_dialogue == current_dialogue.size():
		play_next_dialog()
		return
	cur_line = current_dialogue.get(num_dialogue)
	display_text(cur_line)
	num_dialogue += 1


func play_next_dialog() -> void:
	if dialogue_queue.is_empty():
		current_dialogue = []
		num_dialogue = 0
		text = ""
		return
	var d: Dialog = dialogue_queue.pop_front()
	current_dialogue = d.lines.split("\n")
	num_dialogue = 0
	play_next_line()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("skip_dialog"):
		if typing_timer.is_stopped():
			play_next_line()
		else:
			typing_timer.stop()
			visible_ratio = 1.0

# add to queue -> if paused then play_next_dialog
# dialog start -> play line -> next line[loop] -> play_next_dialog
# typing timer finished -> if more lines, play next line else if more dialog play next dialog
