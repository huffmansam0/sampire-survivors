extends CharacterBody2D
class_name Enemy

signal died(enemy: Enemy)
signal distance_to_target_changed(enemy: Enemy, new_distance: float)

@export var max_hp: float
@export var move_speed: float

@onready var health_bar = $HealthBar
@onready var player = GameManager.get_player()

var current_hp: float

var damage_timer: float = 0.0
var damage_interval: float = 0.25

var update_move_direction_interval: float = 0.3
var move_direction: Vector2

var update_distance_to_target_interval: float = 0.2
var distance_to_target: float

var death_animation: PackedScene = preload("res://Scenes/Enemies/Death_Animation.tscn")

func _ready():
	current_hp = max_hp
	health_bar.value = current_hp
	
	#Set move_direction and distance_to_target
	_update_move_direction()
	_update_distance_to_target()
	
	#Set up timer to update these
	var update_move_direction_timer = Timer.new()
	update_move_direction_timer.wait_time = update_move_direction_interval
	update_move_direction_timer.one_shot = false
	update_move_direction_timer.timeout.connect(_update_move_direction)
	add_child(update_move_direction_timer)
	
	var update_distance_to_target_timer = Timer.new()
	update_distance_to_target_timer.wait_time = update_distance_to_target_interval
	update_distance_to_target_timer.one_shot = false
	update_distance_to_target_timer.timeout.connect(_update_distance_to_target)
	add_child(update_distance_to_target_timer)
	
	update_move_direction_timer.start()
	update_distance_to_target_timer.start()
	
func _update_move_direction():
	move_direction = global_position.direction_to(player.global_position)
	velocity = move_direction * move_speed

func _update_distance_to_target():
	distance_to_target = global_position.distance_to(player.global_position)
	distance_to_target_changed.emit(self, distance_to_target)

func take_damage(amount: float):
	current_hp -= amount
	
	if (current_hp <= 0):
		die()

func die():
	var death_animation_instance = death_animation.instantiate()
	death_animation_instance.global_position = global_position
	get_tree().current_scene.add_child(death_animation_instance)
	died.emit(self)
	queue_free()
