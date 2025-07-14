extends Node
class_name SlimeManager

@export var slime_scene = preload("res://Scenes/Slime.tscn")
@export var damage_per_tick: float = 15.0
@export var damage_interval: float = 0.01

var active_puddles: Array[Node2D] = []
var enemies_in_slime: Dictionary = {}  # enemy -> reference_count
var damage_timers: Dictionary = {}     # enemy -> Timer

func spawn_puddle(position: Vector2):
	var slime = slime_scene.instantiate()
	slime.global_position = position
	slime.setup(self)
	get_parent().add_child(slime)
	# Create puddle, add to scene, manage max count
	
func enemy_entered_puddle(enemy):
	var enemyId = enemy.get_instance_id()
	if (!enemies_in_slime.has(enemyId)):
		enemies_in_slime[enemyId] = enemy
		var damage_timer = get_tree().create_timer(damage_interval).timeout.connect(func(): enemy.take_damage(damage_per_tick))
		damage_timers[enemyId] = damage_timer
	
func enemy_exited_puddle(enemy):
	var enemyId = enemy.get_instance_id()
	if (enemies_in_slime.has(enemyId)):
		enemies_in_slime.erase(enemyId)
		damage_timers.erase(enemyId)
