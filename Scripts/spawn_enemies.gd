extends Node2D

@export var shroom_warrior_scene = preload("res://Scenes/Shroom_Warrior.tscn")
@export var mycellium_mage_scene = preload("res://Scenes/Mycellium_Mage.tscn")
@export var sporecap_sprinter_scene = preload("res://Scenes/Sporecap_Sprinter.tscn")
@export var spawn_rate: float = 1
@onready var player = $Player

var spawn_timer: float = 0.0

func _process(delta):
	spawn_timer += delta
	if spawn_timer >= 1.0 / spawn_rate:
		spawn_enemy()
		spawn_timer = 0.0

func spawn_enemy():
	randomize()
	var enemies = [shroom_warrior_scene, mycellium_mage_scene, sporecap_sprinter_scene]
	var enemy = enemies[randi() % enemies.size()].instantiate()
	enemy.global_position = get_spawn_position()
	enemy.set_player(player)
	add_child(enemy)

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
		0: spawn_pos = Vector2(randf_range(top_left.x, bottom_right.x), bottom_right.y + 50)
		1: spawn_pos = Vector2(bottom_right.x + 50, randf_range(top_left.y, bottom_right.y))
		2: spawn_pos = Vector2(randf_range(top_left.x, bottom_right.x), top_left.y - 50)
		3: spawn_pos = Vector2(top_left.x - 50, randf_range(top_left.y, bottom_right.y))
	
	return spawn_pos
