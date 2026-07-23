extends PanelContainer

@onready var upgrade_button_grid: FlowContainer = %UpgradeButtonGrid
var tween: Tween

var cur_selected_button: UpgradeButton
var is_viewing_upgrade := false

func _on_main_hud_trigger_shop_tween(upgrade_button: UpgradeButton) -> void:
	is_viewing_upgrade = true
	cur_selected_button = upgrade_button
	
	if tween: tween.kill()
	
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(upgrade_button, "position:y", 100, 1.0)
	for button in upgrade_button_grid.get_children():
		button.disabled = true
		if button != upgrade_button:
			tween.parallel().tween_property(button, "modulate:a", 0.0, 1.0)

# undo previous tween
func _on_back_button_pressed() -> void:
	if !is_viewing_upgrade:
		return
	is_viewing_upgrade = false
	
	if tween: tween.kill()
	
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(cur_selected_button, "position:y", 0, 1.0)
	var all_buttons := upgrade_button_grid.get_children()
	for button in all_buttons:
		if button != cur_selected_button:
			tween.parallel().tween_property(button, "modulate:a", 1.0, 1.0)
	await tween.finished
	for button in all_buttons:
		button.disabled = false
