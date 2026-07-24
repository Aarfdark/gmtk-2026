class_name Upgrade
extends Resource

const HAMSTER_ICON = preload("uid://dags5e7uwwpq1")

@export var cost: int
@export var texture: Texture2D = HAMSTER_ICON
@export var name: String
@export_multiline var description: String
@export var effects: Array[UpgradeEffect]
