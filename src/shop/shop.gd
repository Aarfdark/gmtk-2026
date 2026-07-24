class_name ShopPanel
extends PanelContainer

const UpgradeButtonScene = preload("uid://dl2qapeg023np")

var game_state: GameState
var tween: Tween
var cur_selected_button: UpgradeButton
var is_viewing_upgrade := false
var tween_duration := 0.5
var tween_scale := 1.5
var return_scale := 1.0
var return_pos: Vector2

@onready var upgrade_button_grid: FlowContainer = %UpgradeButtonGrid
@onready var scroll_container: ScrollContainer = %ScrollContainer


func _unhandled_input(event: InputEvent) -> void:
	if not OS.is_debug_build():
		return
	if event.is_action_pressed("DEBUG_increment_sands"):
		instantiate_button(load("res://upgrades/second_hand.tres"))


func instantiate_button(upgrade: Upgrade) -> void:
	var new_upgrade_button: UpgradeButton = UpgradeButtonScene.instantiate() as UpgradeButton
	new_upgrade_button.upgrade = upgrade
	new_upgrade_button.pressed.connect(_on_upgrade_button_pressed.bind(new_upgrade_button))
	upgrade_button_grid.add_child(new_upgrade_button)


func _on_upgrade_button_pressed(upgrade_button: UpgradeButton) -> void:
	is_viewing_upgrade = true
	cur_selected_button = upgrade_button
	var grid_size := upgrade_button_grid.size
	var width := upgrade_button.size.x * tween_scale
	var height := upgrade_button.size.y * tween_scale
	var tween_pos := Vector2(grid_size.x - width, grid_size.y - height) / 2
	return_pos = upgrade_button.position

	scroll_container.mouse_filter = Control.MOUSE_FILTER_IGNORE

	if tween:
		tween.kill()

	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_IN_OUT)

	# selected Upgradebutton
	tween.tween_property(upgrade_button, "position", tween_pos, tween_duration)
	tween.parallel().tween_property(
		upgrade_button, "scale", tween_scale * Vector2.ONE, tween_duration
	)
	# everything else
	for button in upgrade_button_grid.get_children():
		button.disabled = true
		if button != upgrade_button:
			tween.parallel().tween_property(button, "modulate:a", 0.0, tween_duration)


# undo previous tweens
func _on_back_button_pressed() -> void:
	if !is_viewing_upgrade:
		return
	is_viewing_upgrade = false

	if tween:
		tween.kill()

	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_IN_OUT)

	# selected Upgradebutton
	tween.tween_property(cur_selected_button, "position", return_pos, tween_duration)
	tween.parallel().tween_property(
		cur_selected_button, "scale", return_scale * Vector2.ONE, tween_duration
	)
	# everything else
	var all_buttons := upgrade_button_grid.get_children()
	for button in all_buttons:
		if button != cur_selected_button:
			tween.parallel().tween_property(button, "modulate:a", 1.0, tween_duration)
	await tween.finished
	for button in all_buttons:
		button.disabled = false
	scroll_container.mouse_filter = Control.MOUSE_FILTER_PASS
	cur_selected_button = null


func _on_buy_button_pressed() -> void:
	if cur_selected_button == null:
		return
	var bought_upgrade: Upgrade = cur_selected_button.upgrade
	if game_state.sands < bought_upgrade.cost:
		# TODO: disable buy button while not affordable
		return
	game_state.sands -= bought_upgrade.cost
	game_state.add_upgrade(bought_upgrade)
