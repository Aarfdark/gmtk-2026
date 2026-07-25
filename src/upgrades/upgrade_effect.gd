class_name UpgradeEffect
extends Resource

enum Type {
	DIAL_RATE,
	DIAL_MAG,
	HAMSTER_QUANTITY,
	HAMSTER_RATE,
}
@export var type: Type
@export var upgrade_value: float
## In cases where order matters, lower values are applied first
@export var apply_order: int = 0
