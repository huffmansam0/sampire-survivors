extends Node
class_name EnemySpawner

signal enemy_died(enemy: Enemy)

@export var shroom_warrior_scene = preload("res://Scenes/Shroom_Warrior.tscn")
@export var mycellium_mage_scene = preload("res://Scenes/Mycellium_Mage.tscn")
@export var sporecap_sprinter_scene = preload("res://Scenes/Sporecap_Sprinter.tscn")
@export var spawn_rate: float = 1.5

@onready var player = GameManager.get_player()
@onready var game_timer = GameManager.get_game_timer()

var rng = RandomNumberGenerator.new()

var shroom_warrior_weight := 5
var mycellium_mage_weight := 0
var sporecap_sprinter_weight := 0

var enabled_enemies := [shroom_warrior_scene]

var spawn_timer: float = 0.0

func _ready():
	GameManager.game_time_elapsed.connect(_on_game_time_elapsed)
	GameManager.game_time_expired.connect(_on_game_time_expired)
	
	ExperienceManager.register_enemy_spawner(self)

func _process(delta):
	spawn_timer += delta
	if spawn_timer >= 1.0 / spawn_rate:
		spawn_enemy()
		spawn_timer = 0.0

func spawn_enemy():
	var enemies = [shroom_warrior_scene, sporecap_sprinter_scene, mycellium_mage_scene]
	var weights = [shroom_warrior_weight, sporecap_sprinter_weight, mycellium_mage_weight]
	
	randomize()
	#var enemies = [preload("res://Scenes/Mycellium_Mage_Ranged_Attack.tscn")]
	var enemy = enemies[rng.rand_weighted(weights)].instantiate()
	enemy.global_position = get_spawn_position()
	add_child(enemy)
	enemy.died.connect(_on_enemy_died)

func get_spawn_position() -> Vector2:
	var camera = get_viewport().get_camera_2d()
	var viewport_rect = get_viewport().get_visible_rect()
	var screen_size = viewport_rect.size / camera.zoom
	var edge = randi() % 4
	
	var camera_pos = camera.global_position
	
	var half_screen = screen_size / 2
	var top_left = camera_pos - half_screen
	var bottom_right = camera_pos + half_screen
	
	var spawn_pos = Vector2()
	
	match edge:
		0: spawn_pos = Vector2(randf_range(top_left.x, bottom_right.x), bottom_right.y + 100)
		1: spawn_pos = Vector2(bottom_right.x + 100, randf_range(top_left.y, bottom_right.y))
		2: spawn_pos = Vector2(randf_range(top_left.x, bottom_right.x), top_left.y - 100)
		3: spawn_pos = Vector2(top_left.x - 100, randf_range(top_left.y, bottom_right.y))
	
	return spawn_pos

func _on_enemy_died(enemy: Enemy):
	enemy_died.emit(enemy)

func _on_game_time_elapsed(seconds: int):
	match seconds:
		#useful testing stuff
		#1:
			#sporecap_sprinter_weight = 1
			#mycellium_mage_weight = 1
		5:
			spawn_rate *= 1.1
		10:
			spawn_rate *= 1.1
		15:
			spawn_rate *= 1.1
		30:
			sporecap_sprinter_weight = 1
		60:
			mycellium_mage_weight = 1
		90:
			spawn_rate *= 2
			
	
func _on_game_time_expired():
	pass
