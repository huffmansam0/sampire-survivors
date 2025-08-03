extends Attack
class_name SnailJuiceAttack

#Could also define things like colors or sprites here, considering that those might change

#const base_position_offset: Vector2 = Vector2(0, 80)

var size: float = 10
var size_mult: float = 0

func _init() -> void:
	type = "snail_juice"
	interval = 0.02
	tick_rate = 0.1
	duration = 2.5
	#Upgrades specify their effect types, look up/add that effect and edit/set its values
	var damage_effect = EffectResource.new()
	damage_effect.initialize("damage", 10, 0, 0, 0)
	effects = {
		"damage": damage_effect,
	}
	position_offset = Vector2(0, 80)

func apply_upgrade(instance: SnailJuiceAttackInstance):
	instance.size = size
	instance.size_mult = size_mult
	instance.duration = duration
	instance.duration_mult = duration_mult
	instance.position_offset = position_offset
