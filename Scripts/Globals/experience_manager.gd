extends Node

signal experience_changed(current_experience, experience_to_next_level)
signal level_changed(current_level)

const despawn_distance: float = 12000
const experience_to_next_level_mult: float = 1.5

@export var experience_scene = preload("res://Scenes/Experience.tscn")

#Base stats
var base_experience_per_pickup: float = 1.0

#Upgradeable stats
var additional_experience_per_pickup: float = 0.0
var experience_per_pickup_mult: float = 0.0

#Actual stats
var experience_per_pickup = base_experience_per_pickup
var player: Player
var current_experience: float = 0.0
var current_level: int = 1
var experience_to_next_level: float = 6.0

func _ready():
	SignalBus.game_started.connect(_start_game)
	SignalBus.game_ended.connect(_end_game)
	SignalBus.enemy_died.connect(_on_enemy_killed)
	SignalBus.experience_upgrade_acquired.connect(_on_experience_upgrade_acquired)
	
func _start_game():
	player = GameManager.get_player()
	
func _end_game():
	get_tree().call_group("Experience", "free")
	current_level = 1
	experience_to_next_level = 10
	current_experience = 0
	
func gain_experience():
	current_experience += experience_per_pickup
	experience_changed.emit(current_experience, experience_to_next_level)
	if (current_experience >= experience_to_next_level):
		level_up()

func level_up():
	if GameManager.state == GameManager.states.defeat or GameManager.state == GameManager.states.victory:
		return
	current_level += 1
	
	current_experience = current_experience - experience_to_next_level
	experience_to_next_level += current_level * experience_to_next_level_mult
	
	experience_changed.emit(current_experience, experience_to_next_level)
	level_changed.emit(current_level)
	
	PauseManager.toggle_pause("level_up")

func _on_enemy_killed(enemy: Enemy):
	var experience: Experience = experience_scene.instantiate()
	experience.global_position = enemy.global_position
	experience.experience_collected.connect(gain_experience)
	experience.distance_to_player_changed.connect(_on_distance_to_player_changed)
	call_deferred("add_child", experience)
	
func _on_distance_to_player_changed(experience: Experience, distance: float):
	if distance > despawn_distance:
		experience.queue_free()

func _on_experience_upgrade_acquired(upgrade: UpgradeResource):
	for component in upgrade.components:
		if component.type == Globals.UpgradeTypes.EXPERIENCE:
			var experience_component: ExperienceUpgradeComponent = component
			
			additional_experience_per_pickup = experience_component.experience
			experience_per_pickup_mult += experience_component.experience_mult
			
			experience_per_pickup = (base_experience_per_pickup + additional_experience_per_pickup) + (1 * experience_per_pickup_mult)
