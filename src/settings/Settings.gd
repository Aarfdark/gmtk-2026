extends Control

@onready var clock: Node2D = %Clock
@onready var dropdown: OptionButton = $PanelContainer/VBoxContainer/HBoxContainer3/OptionButton

func _on_option_button_item_selected(index: int) -> void:
	var text = dropdown.get_item_text(index)
	clock.input_method = (text) 

func _on_button_pressed() -> void:
	visible = false
