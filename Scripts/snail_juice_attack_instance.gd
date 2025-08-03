extends Area2D
class_name SnailJuiceAttackInstance

const attack_type = "snail_juice"

var slime_puddle: Sprite2D
var hitbox: CollisionShape2D

var size: float
var size_mult: float
var duration: float
var duration_mult: float
var position_offset: Vector2

var base_scale: Vector2 = Vector2(0.33, 0.33)

func _enter_tree() -> void:
	slime_puddle = $SlimePuddle
	hitbox = $Hitbox_CollisionShape2D
	
	base_scale *= (1 + size_mult)
	duration *= (1 + duration_mult)
	slime_puddle.scale = Vector2(0.15, 0.15)
	hitbox.scale = Vector2(0.15, 0.15)

func _ready():
	_setup_scale_up()
	_setup_hitbox_scale_up()
	_setup_fade_out(duration)
	
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	
	#not currently using size for anything...if we wanted to do an upgrade that increases base size, we'd want to use this
	#size = size * (1 + size_mult)
		
func _process(delta: float) -> void:
	pass

func _setup_scale_up():
	var scale_tween: Tween = create_tween()
	scale_tween.tween_property(slime_puddle, "scale", base_scale, 0.5)

func _setup_hitbox_scale_up():
	var scale_tween: Tween = create_tween()
	scale_tween.tween_property(hitbox, "scale", base_scale, 0.5)
	
func _setup_fade_out(duration: float):
	var fade_tween: Tween = create_tween()
	slime_puddle.modulate = Color("e4a672")
	fade_tween.tween_property(slime_puddle, "modulate", Color("181425"), duration)
	
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
