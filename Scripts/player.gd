extends CharacterBody2D
class_name Player

signal health_changed(old_health: int, new_health: int)
signal position_changed(new_position: Vector2)
signal died()

#flags
var dead: bool = false

#upgradable stats
var speed: float = 600.0
var speed_mult: float = 0
var max_hp: int = 6
var experience_box_mult: int = 0

@onready var experience_box = $ExperienceBox
@onready var label = $Label
@onready var player_sprite = $PlayerSprite

var current_hp: int

var damage_cooldown: float = 1
var damage_amount: int = 1
var damage_boosting: bool = false

func _ready():
	current_hp = max_hp

func _physics_process(delta: float):
	if ($Hurtbox_Area2D.has_overlapping_areas() && !damage_boosting):
		take_damage(damage_amount)

	handle_movement(delta)
	move_and_collide(velocity * delta)
	position_changed.emit(global_position)

func handle_movement(delta: float):
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * speed
	
	if input_direction.x != 0:
		player_sprite.flip_h = input_direction.x >= 0
	
func take_damage(amount: int):
	if damage_boosting or dead:
		return
	var previous_hp = current_hp
	current_hp -= amount
	damage_boosting = true
	get_tree().create_timer(damage_cooldown).timeout.connect(func(): damage_boosting = false)
	
	health_changed.emit(previous_hp, current_hp)
	
	if (current_hp <= 0 && !dead):
		die()
		
func die():
	dead = true
	died.emit()
	
	label.text = "You Died.\nYou Suck.\nFuck You."
	
	speed = 0
