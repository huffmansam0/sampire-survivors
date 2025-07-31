#Sporecap Sprinter
extends Enemy
class_name SporecapSprinter

@export var charge_speed := 900.0
@export var charge_target_proximity := 500.0
@export var charge_destination_proximity := 20.0

var charge_destination: Vector2
var distance_to_charge_destination: float

@onready var hp_bar = $HealthBar
@onready var state_machine = $StateMachine
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hitbox: Area2D = $Hitbox_Area2D

func _ready():
	move_speed = 350.0
	max_hp = 100
	hp_bar.max_value = max_hp
	hp_bar.min_value = 0
	hp_bar.value = current_hp
	
	super._ready()
	
func approach(delta: float):
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal()) * 1
	
func charge(delta: float):
	move_direction = global_position.direction_to(charge_destination)
	distance_to_charge_destination = global_position.distance_to(charge_destination)
	velocity = move_direction * charge_speed
	move_and_collide(velocity * delta)
	
func fix_to_bust():
	pass
	
func explode():
	die()
	
func should_charge():
	return distance_to_target <= charge_target_proximity
	
func should_fix_to_bust():
	return distance_to_charge_destination <= charge_destination_proximity
	
func should_explode():
	return true


func take_damage(amount: int):
	super.take_damage(amount)
	hp_bar.value = current_hp
