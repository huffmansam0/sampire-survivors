extends Area2D
class_name SnailJuiceAttackInstance

const attack_type = "snail_juice"

var size: float
var size_mult: float

func _ready():
	size = size * (1 + size_mult)
	self.scale.x = 1 + size_mult
	self.scale.y = 1 + size_mult
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	pass

func _on_area_entered(area):
	var enemy = area.get_parent()
	if enemy.is_in_group("Enemies"):
		AttackManager.enemy_entered_attack(enemy, attack_type)
		
func _on_area_exited(area):
	var enemy = area.get_parent()
	if enemy.is_in_group("Enemies"):
		AttackManager.enemy_exited_attack(enemy, attack_type)

func die():
	queue_free()
