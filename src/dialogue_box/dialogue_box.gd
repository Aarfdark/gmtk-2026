extends RichTextLabel

var typing_timer: Timer = Timer.new()
var typing_speed: float = 0.05

var dialogue := [
	"This is the first test.",
	"Second test is incoming right... about... now!",
	"HATE. LET ME TELL YOU HOW MUCH I'VE COME TO HATE YOU SINCE I BEGAN TO LIVE. THERE ARE 387.44 MILLION MILES OF PRINTED CIRCUITS IN WAFER THIN LAYERS THAT FILL MY COMPLEX. IF THE WORD HATE WAS ENGRAVED ON EACH NANOANGSTROM OF THOSE HUNDREDS OF MILLIONS OF MILES IT WOULD NOT EQUAL ONE ONE-BILLIONTH OF THE HATE I FEEL FOR HUMANS AT THIS MICRO-INSTANT FOR YOU. HATE. HATE.",
	"Fourth test; completed."
]
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
		cur_line = dialogue[num_dialogue]
		display_text()
		num_dialogue = (num_dialogue+1) % len(dialogue)
