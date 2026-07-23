class_name Utils
extends Object


static func exp_decay(a: float, b: float, delta: float, decay: float = 16) -> float:
	return b + (a - b) * exp(-decay * delta)
