extends Attack
class_name SnailJuiceAttack

#Could also define things like colors or sprites here, considering that those might change

#TODO: organize these by whether they're AttackManager concerns or instance concerns
const base_interval: float = 0.02
const base_interval_mult: float = 0.0
const base_duration: float = 2.5
const base_duration_mult: float = 0.0
const base_tick_rate: float = 0.1
const base_tick_rate_mult: float = 0.0
const base_position_offset: Vector2 = Vector2(0, 80)
const base_size: float = 0.0
const base_size_mult: float = 0.0
const base_damage_amount: float = 5.0

static func get_base() -> SnailJuiceAttack:
	var snail_juice_attack_base = SnailJuiceAttack.new()
	snail_juice_attack_base.interval = base_interval
	snail_juice_attack_base.interval_mult = base_interval_mult
	snail_juice_attack_base.duration = base_duration
	snail_juice_attack_base.duration_mult = base_duration_mult
	snail_juice_attack_base.tick_rate = base_tick_rate
	snail_juice_attack_base.tick_rate_mult = base_tick_rate_mult
	snail_juice_attack_base.position_offset = base_position_offset
	snail_juice_attack_base.size = base_size
	snail_juice_attack_base.size_mult = base_size_mult
	var damage_effect: EffectComponent = EffectComponent.new()
	damage_effect.initialize(Globals.EffectTypes.DAMAGE, base_damage_amount, 0, 0, 0)
	snail_juice_attack_base.effects = {Globals.EffectTypes.DAMAGE: damage_effect}
	return snail_juice_attack_base
