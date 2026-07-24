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

@onready var icon_rect: TextureRect = %Icon
