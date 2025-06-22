extends RigidBody2D

@export var speed: float
@export var max_hp: int

#TODO: define dims of hitbox/hurtbox here?

var current_hp: int

var damage_timer: float = 0.0
var damage_interval: float = 0.25

var player: Node2D = null

func _ready():
	process_mode = Node.PROCESS_MODE_PAUSABLE
	current_hp = max_hp

func _physics_process(delta):
	handle_movement()

func handle_movement():
	var direction = global_position.direction_to(player.global_position)
	var force = direction * speed * mass
	apply_central_force(force)

func set_player(player_node):
	player = player_node

func take_damage(amount: int):
	current_hp -= amount
	
	if (current_hp <= 0):
		die()

func die():
	queue_free()
