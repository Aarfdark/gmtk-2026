@tool
class_name UpgradeButton
extends Button

@export var upgrade: Upgrade:
	set(value):
		if upgrade == value:
			return
		upgrade = value
		if not is_node_ready():
			await ready
		icon_rect.texture = upgrade.texture
@export var game_state: GameState:
	set(value):
		game_state = value
		if not is_node_ready():
			await ready
		game_state.changed.connect(_on_game_state_changed)
		_on_game_state_changed()

@onready var icon_rect: TextureRect = %Icon
@onready var border: Panel = %Border


func _on_game_state_changed() -> void:
	border.modulate = Color.YELLOW if game_state.sands >= upgrade.cost else Color.GRAY
