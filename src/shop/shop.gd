extends PanelContainer

@onready var upgrade_button_grid: FlowContainer = %UpgradeButtonGrid
@onready var UpgradeButtonScene = preload("uid://dl2qapeg023np")
@onready var main_hud: MainHUD = $"../../.."
@onready var game_state = main_hud.game_state
var tween: Tween
var cur_selected_button: UpgradeButton
var is_viewing_upgrade := false
var tween_duration: float = 0.5
var tween_scale := Vector2(1.5, 1.5)
var return_scale := Vector2(1, 1)
var tween_pos := Vector2(100, 100)
var return_pos := Vector2(0, 0)

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
	
	if tween: tween.kill()
	
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	# selected Upgradebutton
	tween.tween_property(upgrade_button, "offset_transform_position", tween_pos, tween_duration)
	tween.parallel().tween_property(upgrade_button, "scale", tween_scale, tween_duration)
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
	
	if tween: tween.kill()
	
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	# selected Upgradebutton
	tween.tween_property(cur_selected_button, "offset_transform_position", return_pos, tween_duration)
	tween.parallel().tween_property(cur_selected_button, "scale", return_scale, tween_duration)
	# everything else
	var all_buttons := upgrade_button_grid.get_children()
	for button in all_buttons:
		if button != cur_selected_button:
			tween.parallel().tween_property(button, "modulate:a", 1.0, tween_duration)
	await tween.finished
	for button in all_buttons:
		button.disabled = false
	cur_selected_button = null

func _on_buy_button_pressed() ->  void:
	if cur_selected_button == null or game_state.sands < cur_selected_button.upgrade.cost:
		return
	game_state.sands -= cur_selected_button.upgrade.cost
	game_state.purchased_upgrades.append(cur_selected_button.upgrade)
	for upgrade_effect: UpgradeEffect in cur_selected_button.upgrade.effects:
		game_state.active_effects.append(upgrade_effect)
	game_state.update_attributes()
