extends CharacterBody2D
class_name SporecapSprinterExplosion

const FRIENDLY_FIRE_DAMAGE: float = 100.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hitbox: Area2D = $HitboxArea

func _ready():
	animation_player.animation_finished.connect(func(__): queue_free())
	hitbox.area_entered.connect(damage_enemies)

func damage_enemies(area: Area2D):
	var enemy: Enemy = area.get_parent()
	if enemy.is_in_group("Enemies"):
		enemy.take_damage(FRIENDLY_FIRE_DAMAGE)
