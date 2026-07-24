class_name ShopPanel
extends PanelContainer

const UpgradeButtonScene = preload("uid://dl2qapeg023np")

@export var tween_duration := 0.5
@export var tween_scale := 1.5
@export var return_scale := 1.0

var game_state: GameState

var _return_pos: Vector2
var _tween: Tween
var _selected_button: UpgradeButton

@onready var upgrade_button_grid: FlowContainer = %UpgradeButtonGrid
@onready var scroll_container: ScrollContainer = %ScrollContainer
@onready var buy_prompt: Control = %BuyPrompt
@onready var displayed_slot: Control = %DisplayedSlot
@onready var cost_label: Label = %CostLabel
@onready var upgrade_label: Label = %UpgradeLabel
@onready var upgrade_description: RichTextLabel = %UpgradeDescription
@onready var buy_button: Button = %BuyButton
@onready var cancel_button: Button = %CancelButton


func _ready() -> void:
	if not ProjectSettings.get_setting("custom/unlock_all_upgrades"):
		return
	for path: String in DirAccess.get_files_at("res://upgrades"):
		var upgrade: Upgrade = load("res://upgrades/" + path) as Upgrade
		if upgrade:
			instantiate_button(upgrade)


func _unhandled_input(event: InputEvent) -> void:
	if not ProjectSettings.get_setting("custom/enable_debug_keybinds"):
		return
	if event.is_action_pressed("DEBUG_increment_sands"):
		instantiate_button(load("res://upgrades/second_hand.tres"))


func instantiate_button(upgrade: Upgrade) -> void:
	var new_upgrade_button: UpgradeButton = UpgradeButtonScene.instantiate() as UpgradeButton
	new_upgrade_button.upgrade = upgrade
	new_upgrade_button.pressed.connect(_on_upgrade_button_pressed.bind(new_upgrade_button))
	upgrade_button_grid.add_child(new_upgrade_button)


func toggle_grid_inputs(on: bool) -> void:
	for button in upgrade_button_grid.get_children():
		button.disabled = not on
	scroll_container.mouse_filter = Control.MOUSE_FILTER_PASS if on else Control.MOUSE_FILTER_IGNORE


func toggle_prompt_inputs(on: bool) -> void:
	buy_button.disabled = not on
	cancel_button.disabled = not on


func restore_grid(return_upgrade: bool = false) -> void:
	toggle_prompt_inputs(false)
	if _tween:
		_tween.kill()

	_tween = create_tween().set_trans(Tween.TRANS_QUART).set_parallel()

	if return_upgrade:
		_tween.tween_property(_selected_button, "position", _return_pos, tween_duration)
		_tween.tween_property(_selected_button, "scale", return_scale * Vector2.ONE, tween_duration)
	for button in upgrade_button_grid.get_children():
		var opacity := 1.0
		if button == _selected_button and not return_upgrade:
			opacity = 0.0
		_tween.tween_property(button, "modulate:a", opacity, tween_duration)
	_tween.tween_property(scroll_container.get_v_scroll_bar(), "modulate:a", 1.0, tween_duration)
	_tween.tween_property(buy_prompt, "modulate:a", 0.0, tween_duration).from(1.0)
	await _tween.finished
	if not return_upgrade:
		_selected_button.queue_free()
	else:
		_selected_button = null
	toggle_grid_inputs(true)
	buy_prompt.hide()


func _on_upgrade_button_pressed(upgrade_button: UpgradeButton) -> void:
	_selected_button = upgrade_button
	var scaled_size := tween_scale * upgrade_button.size
	var tween_pos := (displayed_slot.size - scaled_size) / 2
	tween_pos.y += scroll_container.scroll_vertical
	_return_pos = upgrade_button.position

	var selected_upgrade := upgrade_button.upgrade
	cost_label.text = "%d" % selected_upgrade.cost
	upgrade_label.text = selected_upgrade.name
	upgrade_description.text = selected_upgrade.description
	buy_prompt.show()
	toggle_prompt_inputs(false)

	if _tween:
		_tween.kill()

	_tween = create_tween().set_trans(Tween.TRANS_QUART).set_parallel()

	toggle_grid_inputs(false)
	for button in upgrade_button_grid.get_children():
		if button == upgrade_button:
			_tween.tween_property(button, "position", tween_pos, tween_duration)
			_tween.tween_property(button, "scale", tween_scale * Vector2.ONE, tween_duration)
		else:
			_tween.tween_property(button, "modulate:a", 0.0, tween_duration)
	_tween.tween_property(scroll_container.get_v_scroll_bar(), "modulate:a", 0.0, tween_duration)
	_tween.tween_property(buy_prompt, "modulate:a", 1.0, tween_duration).from(0.0)
	await _tween.finished
	toggle_prompt_inputs(true)


# undo previous tweens
func _on_cancel_button_pressed() -> void:
	restore_grid(true)


func _on_buy_button_pressed() -> void:
	if _selected_button == null:
		return
	var bought_upgrade: Upgrade = _selected_button.upgrade
	if game_state.sands < bought_upgrade.cost:
		# TODO: disable buy button while not affordable
		return
	game_state.sands -= bought_upgrade.cost
	game_state.add_upgrade(bought_upgrade)
	# TODO: fancy confirm animation
	_selected_button.reparent(displayed_slot)
	restore_grid(false)
