class_name GameState
extends Resource

signal countdown_ended
signal upgrade_unlocked(upgrade: Upgrade)

const STARTING_SECONDS = 1785085200 # 2026-07-26 17:00:00

@export var seconds_remaining: int = STARTING_SECONDS:
	set(value):
		if value == seconds_remaining:
			return
		if value < 0:
			seconds_remaining = 0
			if not _end_fired:
				countdown_ended.emit()
				_end_fired = true
			emit_changed()
			return
		var diff := seconds_remaining - value
		if diff > 0:
			sands += diff
		seconds_remaining = value
		emit_changed()
@export var sands: int = 0:
	set(value):
		if value == sands:
			return
		if value < 0:
			push_error("Sand went into debt")
			sands = 0
			return
		sands = value
		check_unlocks()
		emit_changed()

@export var locked_upgrades: Array[Upgrade] = []
@export var purchased_upgrades: Array[Upgrade] = []
@export var active_effects: Array[UpgradeEffect] = []

@export var dial_mag_base: int = 1
@export var hamster_speed_base: float = 0.5

var hamster_count: float = 0.0
var hamster_speed: float = hamster_speed_base
var dial_mag: int = dial_mag_base
var ticks_per_second: float = 0.0
var dial_rate_mod: float = 0.0

var _end_fired: bool = false


func update_attributes() -> void:
	active_effects.sort_custom(
		func(a: UpgradeEffect, b: UpgradeEffect) -> bool:
			return a.apply_order < b.apply_order,
	)
	dial_mag = dial_mag_base
	hamster_count = 0
	hamster_speed = hamster_speed_base
	dial_rate_mod = 0
	for effect: UpgradeEffect in active_effects:
		match effect.type:
			UpgradeEffect.Type.DIAL_MAG:
				dial_mag *= int(effect.upgrade_value)
			UpgradeEffect.Type.DIAL_RATE:
				dial_rate_mod += effect.upgrade_value
			UpgradeEffect.Type.HAMSTER_QUANTITY:
				hamster_count += effect.upgrade_value
			UpgradeEffect.Type.HAMSTER_RATE:
				hamster_speed *= effect.upgrade_value
	ticks_per_second = -1 * hamster_count * hamster_speed


func add_upgrade(upgrade: Upgrade) -> void:
	# WARN: might need special case for more hamster
	if upgrade in purchased_upgrades:
		push_error("Took the same upgrade twice")
		return
	purchased_upgrades.append(upgrade)
	for upgrade_effect: UpgradeEffect in upgrade.effects:
		active_effects.append(upgrade_effect)
	changed.emit()
	update_attributes()


func get_datetime() -> String:
	return Time.get_datetime_string_from_unix_time(seconds_remaining, true)

func check_unlocks() -> void:
	var to_unlock: Array[Upgrade] = []
	
	for upgrade in locked_upgrades:
		if upgrade.unlock_conditions == null:
			to_unlock.append(upgrade)
			continue
		var passing: bool = true
		for cond in upgrade.unlock_conditions:
			if not cond.is_condition_cleared(self):
				passing = false
				break
		if passing:
			to_unlock.append(upgrade)
	for u in to_unlock:
		locked_upgrades.erase(u)
		upgrade_unlocked.emit(u)

			
			
			
