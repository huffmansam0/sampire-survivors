extends Area2D

@export var base_damage: int = 1
@export var base_size: int = 10 #TODO: idk if this needs a radius, area, or what. update name and value when you know
@export var base_duration: float = 2.5

@onready var despawn_timer = $Despawn_Timer

var slime_spawner: SlimeSpawner

var current_damage: int
var current_size: int
var current_duration: int

var damage_timer: Timer
var damage_cooldown: float = 0.1

var enemies = []

func setup(spawner: SlimeSpawner):
	slime_spawner = spawner
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _ready():
	despawn_timer.wait_time = base_duration
	despawn_timer.timeout.connect(die)
	despawn_timer.start()

func _on_area_entered(area):
	var enemy = area.get_parent()
	if enemy.is_in_group("Enemies"):
		slime_spawner.enemy_entered_puddle(enemy)
		
func _on_area_exited(area):
	var enemy = area.get_parent()
	if enemy.is_in_group("Enemies"):
		slime_spawner.enemy_exited_puddle(enemy)

func die():
	queue_free()
