extends Area2D

@export var base_damage: int = 1
@export var base_size: int = 10 #TODO: idk if this needs a radius, area, or what. update name and value when you know
@export var base_duration: float = 2.5

@onready var despawn_timer = $Despawn_Timer

var current_damage: int
var current_size: int
var current_duration: int

var damage_timer: float = 0.0
var damage_interval: float = 0.1

func _ready():
	current_damage = base_damage
	current_size = base_size
	despawn_timer.wait_time = base_duration
	despawn_timer.timeout.connect(die)
	despawn_timer.start()
	

func _physics_process(delta: float):
	#TODO migrate enemies and this collision checking to use groups instead of layers/masks only
	var enemies = get_overlapping_areas()

	if (enemies.size() >= 1):
		damage_timer += delta
	else:
		damage_timer = 0.0

	if (damage_timer > damage_interval):
		for enemy in enemies:
			enemy = enemy.get_parent()
			enemy.take_damage(current_damage)
			
func die():
	queue_free()
