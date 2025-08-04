extends Node
class_name EnemySpawner

@export var shroom_warrior_scene = preload("res://Scenes/Shroom_Warrior.tscn")
@export var mycellium_mage_scene = preload("res://Scenes/Mycellium_Mage.tscn")
@export var sporecap_sprinter_scene = preload("res://Scenes/Sporecap_Sprinter.tscn")

@onready var player = GameManager.get_player()
@onready var game_timer = GameManager.get_game_timer()

var rng = RandomNumberGenerator.new()

#== STARTING SPAWN WEIGHTS ===#
var shroom_warrior_weight := 5
var mycellium_mage_weight := 0
var sporecap_sprinter_weight := 0

var spawn_timer: float = 0.0

var spawn_rate: float = 3
var active_enemy_cap: int = 500
var active_enemy_count: int = 0
var despawn_distance: float = 6000

func _ready() -> void:
	SignalBus.game_started.connect(_start_game)

func _exit_tree() -> void:
	if SignalBus.victory.is_connected(_on_victory):
		SignalBus.victory.disconnect(_on_victory)
	
	if SignalBus.game_started.is_connected(_start_game):
		SignalBus.game_started.disconnect(_start_game)
		
	if SignalBus.game_time_elapsed.is_connected(_on_game_time_elapsed):
		SignalBus.game_time_elapsed.disconnect(_on_game_time_elapsed)

func _start_game():
	SignalBus.game_time_elapsed.connect(_on_game_time_elapsed)
	SignalBus.victory.connect(_on_victory)
	
func _on_victory():
	get_tree().call_group("Enemies", "die")
	spawn_rate = 0

func _process(delta):
	spawn_timer += delta
	if spawn_timer >= 1.0 / spawn_rate:
		if active_enemy_count < active_enemy_cap:
			spawn_enemy()
		spawn_timer = 0.0

func spawn_enemy():
	var enemies = [shroom_warrior_scene, sporecap_sprinter_scene, mycellium_mage_scene]
	var weights = [shroom_warrior_weight, sporecap_sprinter_weight, mycellium_mage_weight]
	
	randomize()
	var enemy = enemies[rng.rand_weighted(weights)].instantiate()
	enemy.global_position = get_spawn_position()
	add_child(enemy)
	active_enemy_count += 1
	enemy.distance_to_target_changed.connect(_check_enemy_distance)
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

func _check_enemy_distance(enemy: Enemy, distance: float):
	if active_enemy_count == active_enemy_cap && distance > despawn_distance:
		enemy.queue_free()
		active_enemy_count -= 1

func _on_enemy_died(enemy: Enemy):
	active_enemy_count -= 1
	SignalBus.enemy_died.emit(enemy)

func _on_game_time_elapsed(seconds: int):
	match seconds:
		#useful testing stuff
		1:
			#spawn_rate = 0.01
			#sporecap_sprinter_weight = 1
			#mycellium_mage_weight = 1
			pass
		5:
			spawn_rate *= 1.1
		10:
			spawn_rate *= 1.1
		15:
			spawn_rate *= 1.1
		60:
			sporecap_sprinter_weight = 1
		120:
			mycellium_mage_weight = 1
		90:
			spawn_rate *= 2
			
	
func _on_game_time_expired():
	pass
