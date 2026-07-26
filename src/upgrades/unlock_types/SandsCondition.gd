class_name SandsCondition
extends UnlockCondition

@export var sand_threshold: int


func is_condition_cleared(game_state: GameState):
	return sand_threshold <= game_state.sands
