class_name DialogBox
extends RichTextLabel


signal dialog_complete

var current_dialogue: PackedStringArray

@export var advance_button: Button

# var dialog_pause: Timer = Timer.new()
# @export var dialog_pause_time: float = 1.0
var num_dialogue: int = 0
var cur_line: String

var dialogue_queue: Array[Dialog] = []

@onready var typing_timer: Timer = $TypingTimer


func _ready() -> void:
	advance_button.pressed.connect(advance)

	# dialog_pause.one_shot=true

	# dialog_pause.timeout.connect(play_next_line)
	# add_child(dialog_pause)


func init_game_state(gs: GameState) -> void:
	gs.dialog_reached.connect(queue_dialog)


func queue_dialog(to_queue: Dialog) -> void:
	dialogue_queue.append(to_queue)
	advance_button.disabled = false
	if is_dialog_completed():
		play_next_dialog()


func is_dialog_completed() -> bool:
	return typing_timer.is_stopped() and num_dialogue == current_dialogue.size()


func display_text(line: String) -> void:
	text = line
	visible_characters = 0
	typing_timer.start()


func _on_typing_timer_timeout() -> void:
	if visible_characters < cur_line.length():
		visible_characters += 1
	else:
		finish_typing()


func finish_typing() -> void:
	typing_timer.stop()
	advance_button.disabled = (
		dialogue_queue.is_empty() and num_dialogue == current_dialogue.size()
	)
	if advance_button.disabled:
		dialog_complete.emit()


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
	play_next_line()


func advance() -> void:
	if typing_timer.is_stopped():
		play_next_line()
	else:
		finish_typing()
		visible_ratio = 1.0


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("skip_dialog"):
		advance()

# add to queue -> if paused then play_next_dialog
# dialog start -> play line -> next line[loop] -> play_next_dialog
# typing timer finished -> if more lines, play next line else if more dialog play next dialog
