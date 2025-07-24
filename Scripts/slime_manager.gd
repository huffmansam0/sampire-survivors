extends Node
class_name SlimeSpawner

@export var slime_scene = preload("res://Scenes/Slime.tscn")
@export var damage_per_tick: float = 1.0
@export var damage_interval: float = 0.01

var active_puddles: Array[Node2D] = []
var enemies_in_slime: Dictionary = {}
var damage_timers: Dictionary = {}

func spawn_puddle(position: Vector2):
	var slime = slime_scene.instantiate()
	slime.global_position = position
	slime.setup(self)
	get_tree().current_scene.add_child(slime)
	
func enemy_entered_puddle(enemy: Enemy):
	var enemyId = enemy.get_instance_id()
	var enemyEntry = enemies_in_slime.get_or_add(enemyId, 0)
	enemies_in_slime[enemyId] += 1
	if enemies_in_slime[enemyId] == 1:
		var damage_timer = Timer.new()
		damage_timer.wait_time = damage_interval
		damage_timer.timeout.connect(_damage_enemy.bind(enemy))
		damage_timer.autostart = true
		add_child(damage_timer)
		damage_timers[enemyId] = damage_timer

func enemy_exited_puddle(enemy: Enemy):
	var enemyId = enemy.get_instance_id()
	enemies_in_slime[enemyId] -= 1
	if enemies_in_slime[enemyId] <= 0:
		_remove_enemy(enemyId)
		
func _damage_enemy(enemy: Enemy):
	if is_instance_valid(enemy):
		enemy.take_damage(damage_per_tick)
	
func _remove_enemy(enemyId):
	enemies_in_slime.erase(enemyId)
	damage_timers[enemyId].queue_free()
	damage_timers.erase(enemyId)
