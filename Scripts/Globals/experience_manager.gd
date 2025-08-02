extends Node

signal experience_changed(current_experience, experience_to_next_level)
signal level_changed(current_level)

const despawn_distance: float = 12000

@export var experience_scene = preload("res://Scenes/Experience.tscn")

@onready var enemy_spawner: EnemySpawner
var player: Player
var current_experience: int = 0
var current_level: int = 1
var experience_to_next_level: int = 10

func _ready():
	set_process(false)
	SignalBus.game_started.connect(_start_game)
	
func _start_game():
	player = GameManager.get_player()
	
	experience_changed.emit(current_experience, experience_to_next_level)
	level_changed.emit(current_level)
	
	set_process(true)
	
func register_enemy_spawner(spawner: EnemySpawner):
	enemy_spawner = spawner
	enemy_spawner.enemy_died.connect(_on_enemy_killed)
	
func gain_experience():
	current_experience += 1
	experience_changed.emit(current_experience, experience_to_next_level)
	if (current_experience >= experience_to_next_level):
		level_up()

func level_up():
	current_level += 1
	
	current_experience = current_experience - experience_to_next_level
	experience_to_next_level = experience_to_next_level + current_level * 2
	
	experience_changed.emit(current_experience, experience_to_next_level)
	level_changed.emit(current_level)
	
	PauseManager.toggle_pause("level_up")

func _on_enemy_killed(enemy: Enemy):
	var experience: Experience = experience_scene.instantiate()
	experience.global_position = enemy.global_position
	experience.experience_collected.connect(gain_experience)
	experience.distance_to_player_changed.connect(_on_distance_to_player_changed)
	add_child(experience)
	
func _on_distance_to_player_changed(experience: Experience, distance: float):
	if distance > despawn_distance:
		experience.queue_free()
