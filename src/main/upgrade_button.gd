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

@onready var icon_rect: TextureRect = %Icon


func _on_mouse_entered() -> void:
	if upgrade:
		#print(upgrade.name)
		pass
