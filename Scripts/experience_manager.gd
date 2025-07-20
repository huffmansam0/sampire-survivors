extends Node
class_name ExperienceManager

signal experience_changed(current_experience, experience_to_next_level)
signal level_changed(current_level)

@export var experience_scene = preload("res://Scenes/Experience.tscn")

@onready var enemy_manager: EnemyManager = $"../EnemyManager"
@onready var player = GameManager.get_player()

var current_experience: int = 0
var current_level: int = 1
var experience_to_next_level: int = 10

func _ready():
	enemy_manager.enemy_died.connect(_on_enemy_killed)
	experience_changed.emit(current_experience, experience_to_next_level)
	level_changed.emit(current_level)
	
func gain_experience():
	current_experience += 1
	print ("XP: %d" % current_experience)
	experience_changed.emit(current_experience, experience_to_next_level)
	if (current_experience >= experience_to_next_level):
		current_level += 1
		current_experience = current_experience - experience_to_next_level
		experience_to_next_level = experience_to_next_level + current_level * 2
		
		experience_changed.emit(current_experience, experience_to_next_level)
		level_changed.emit(current_level)
		
		print("You have reached level %d!" % current_level)
	

func _on_enemy_killed(enemy: Enemy):
	var experience: Experience = experience_scene.instantiate()
	experience.global_position = enemy.global_position
	experience.experience_collected.connect(gain_experience)
	add_child(experience)
