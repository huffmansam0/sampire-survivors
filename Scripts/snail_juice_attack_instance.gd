extends Area2D
class_name SnailJuiceAttackInstance

const attack_type = "snail_juice"

@onready var slime_puddle: Sprite2D = $SlimePuddle

var size: float
var size_mult: float
var duration: float
var duration_mult: float
var position_offset: Vector2

var base_scale: Vector2 = Vector2(0.25, 0.25)

func _ready():
	#not currently using size for anything...if we wanted to do an upgrade that increases base size, we'd want to use this
	size = size * (1 + size_mult)
	var x = self.scale.x
	var y = self.scale.y
	x = x * (1 + size_mult)
	y = y * (1 + size_mult)
	
	duration = duration * (1 + duration_mult)
	
	_setup_scale_up()
	_setup_fade_out(duration)
	
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	pass
	
func _setup_scale_up():
	var scale_tween: Tween = create_tween()
	slime_puddle.scale = Vector2(0.15, 0.15)
	scale_tween.tween_property(slime_puddle, "scale", base_scale, 0.5)
	
func _setup_fade_out(duration: float):
	var fade_tween: Tween = create_tween()
	fade_tween.tween_property(slime_puddle, "modulate", Color("e4a672"), 0)
	fade_tween.tween_property(slime_puddle, "modulate", Color("181425"), duration)
	#fade_tween.tween_property(slime_puddle, "modulate:a", 0.0, duration)
	
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
