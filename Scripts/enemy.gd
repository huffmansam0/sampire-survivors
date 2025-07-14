extends CharacterBody2D
class_name Enemy

@export var max_hp: int

@onready var health_bar = $HealthBar

#TODO: define dims of hitbox/hurtbox here?

var current_hp: int

var damage_timer: float = 0.0
var damage_interval: float = 0.25

var player: CharacterBody2D = null

func _ready():
	process_mode = Node.PROCESS_MODE_PAUSABLE
	current_hp = max_hp
	health_bar.value = current_hp

func set_player(player_node):
	player = player_node

func take_damage(amount: int):
	current_hp -= amount
	
	if (current_hp <= 0):
		die()

func die():
	queue_free()
