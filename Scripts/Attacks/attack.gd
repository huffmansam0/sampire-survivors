extends Node
class_name Attack

var type: String

var interval: float
var interval_mult: float = 0
var duration: float
var duration_mult: float = 0
var tick_rate: float
var tick_rate_mult: float = 0
var position_offset: Vector2 = Vector2.ZERO
var effects: Dictionary[String, EffectResource]

func apply_upgrade(instance):
	pass
