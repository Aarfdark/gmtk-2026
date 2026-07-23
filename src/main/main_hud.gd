class_name MainHUD
extends Control

@export var game_state: GameState:
	set(value):
		game_state = value
		if not is_node_ready():
			await ready
		time_label_iso.game_state = game_state
		time_label_unix.game_state = game_state
		game_state.changed.connect(_on_game_state_changed)
		_on_game_state_changed()

@onready var sands_label: Label = %SandsLabel
@onready var time_label_iso: TimeLabel = %TimeLabelISO
@onready var time_label_unix: TimeLabel = %TimeLabelUnix
@onready var settings_menu: Control = %SettingsMenu
@onready var upgrade_button_grid: FlowContainer = %UpgradeButtonGrid
@onready var UpgradeButtonScene = preload("uid://dl2qapeg023np")

var _tick_progress: float = 0.0

func _process(delta: float) -> void:
	var time_diff: float = delta * game_state.ticks_per_second + _tick_progress
	game_state.seconds_remaining += int(time_diff)
	_tick_progress = fmod(time_diff, 1.0)


func _unhandled_input(event: InputEvent) -> void:
	if not OS.is_debug_build():
		return
	if event.is_action_pressed("DEBUG_increment_sands"):
		instantiate_button(load("res://upgrades/second_hand.tres"))
	if event.is_action_pressed("DEBUG_decrement_sands"):
		game_state.sands -= 100


func instantiate_button(upgrade: Upgrade) -> void:
	var new_upgrade_button: UpgradeButton = UpgradeButtonScene.instantiate() as UpgradeButton
	new_upgrade_button.upgrade = upgrade
	upgrade_button_grid.add_child(new_upgrade_button)
	new_upgrade_button.pressed.connect(_on_upgrade_button_pressed.bind(upgrade))


func _on_game_state_changed() -> void:
	sands_label.text = "Sands: %d" % game_state.sands


func _on_upgrade_button_pressed(upgrade: Upgrade) -> void:
	if game_state.sands < upgrade.cost:
		return
	game_state.sands -= upgrade.cost
	game_state.purchased_upgrades.append(upgrade)
	print(len(game_state.purchased_upgrades))
	for upgrade_effect: UpgradeEffect in upgrade.effects:
		game_state.active_effects.append(upgrade_effect)
	game_state.update_attributes()
	print("bought upgrade: %s" % upgrade.name)

func _on_clock_revolution_completed() -> void:
	game_state.seconds_remaining -= game_state.seconds_per_revolution
	
func _on_settings_button_pressed() -> void:
	settings_menu.visible = true
