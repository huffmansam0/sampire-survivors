extends AttackUpgradeResource
class_name SnailJuiceAttackUpgradeResource

@export var size: float
@export var size_mult: float

func apply():
	#map to SnailJuiceAttack
	var attack = SnailJuiceAttack.new()
	attack.size = size
	attack.size_mult = size_mult
	attack.interval = interval
	attack.interval_mult = interval_mult
	attack.duration = duration
	attack.duration_mult = duration_mult
	attack.tick_rate = tick_rate
	attack.tick_rate_mult = tick_rate_mult
	attack.position_offset = Vector2(position_offset_x, position_offset_y)
	attack.effects = effects
	
	AttackManager.update_attack(attack)
