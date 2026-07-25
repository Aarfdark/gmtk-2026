class_name PriorUpgradeCondition
extends UnlockCondition

@export var priorUpgrade: Upgrade

func is_condition_cleared(game_state: GameState):
	return priorUpgrade in game_state.purchased_upgrades
