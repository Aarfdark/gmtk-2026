extends RichTextLabel

@export var dialogue : Array[String]

var typing_timer: Timer = Timer.new()
var typing_speed: float = 0.03

var num_dialogue: int = 0
var cur_line : String

func _ready() -> void:
	typing_timer.timeout.connect(_on_typing_timer_timeout)
	add_child(typing_timer)

func display_text() -> void:
	text = cur_line
	visible_characters = 0
	typing_timer.start(typing_speed)

func _on_typing_timer_timeout() -> void:
	if visible_characters < cur_line.length():
		visible_characters += 1
	else:
		typing_timer.stop()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("DEBUG_increment_sands"):
		#cur_line = dialogue[num_dialogue]
		#display_text()
		#num_dialogue = (num_dialogue+1) % len(dialogue)
		pass
