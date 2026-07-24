class_name ShopPanel
extends PanelContainer

@onready var upgrade_button_grid: FlowContainer = %UpgradeButtonGrid
@onready var UpgradeButtonScene = preload("uid://dl2qapeg023np")
var game_state: GameState
var tween: Tween
var cur_selected_button: UpgradeButton
var is_viewing_upgrade := false
var tween_duration := 0.5
var tween_scale := 1.5
var return_scale := 1.0
var tween_pos := Vector2(100, 100)
var return_pos: Vector2


func _unhandled_input(event: InputEvent) -> void:
	if not OS.is_debug_build():
		return
	if event.is_action_pressed("DEBUG_increment_sands"):
		instantiate_button(load("res://upgrades/second_hand.tres"))
	#if event.is_action_pressed("DEBUG_decrement_sands"):
	#game_state.sands -= 100


func instantiate_button(upgrade: Upgrade) -> void:
	var new_upgrade_button: UpgradeButton = UpgradeButtonScene.instantiate() as UpgradeButton
	new_upgrade_button.upgrade = upgrade
	upgrade_button_grid.add_child(new_upgrade_button)
	new_upgrade_button.pressed.connect(_on_upgrade_button_pressed.bind(new_upgrade_button))

	new_upgrade_button.offset_transform_enabled = true


func _on_upgrade_button_pressed(upgrade_button: UpgradeButton) -> void:
	is_viewing_upgrade = true
	cur_selected_button = upgrade_button
	var grid_size := upgrade_button_grid.size
	var width := upgrade_button.size.x * tween_scale
	var height := upgrade_button.size.y * tween_scale
	tween_pos = Vector2(grid_size.x - width, grid_size.y - height) / 2
	return_pos = upgrade_button.position

	if tween:
		tween.kill()

	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_IN_OUT)

	# selected Upgradebutton
	tween.tween_property(upgrade_button, "position", tween_pos, tween_duration)
	tween.parallel().tween_property(
		upgrade_button, "scale", Vector2(tween_scale, tween_scale), tween_duration
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
		cur_selected_button, "scale", Vector2(return_scale, return_scale), tween_duration
	)
	# everything else
	var all_buttons := upgrade_button_grid.get_children()
	for button in all_buttons:
		if button != cur_selected_button:
			tween.parallel().tween_property(button, "modulate:a", 1.0, tween_duration)
	await tween.finished
	for button in all_buttons:
		button.disabled = false
	cur_selected_button = null


func _on_buy_button_pressed() -> void:
	if cur_selected_button == null or game_state.sands < cur_selected_button.upgrade.cost:
		return
	game_state.sands -= cur_selected_button.upgrade.cost
	game_state.purchased_upgrades.append(cur_selected_button.upgrade)
	for upgrade_effect: UpgradeEffect in cur_selected_button.upgrade.effects:
		game_state.active_effects.append(upgrade_effect)
	game_state.update_attributes()
