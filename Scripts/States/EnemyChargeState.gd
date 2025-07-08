extends State
class_name EnemyChargeState

@export var enemy: CharacterBody2D
@export var move_speed := 100.0

var target : CharacterBody2D
var move_direction : Vector2
var destination : Vector2
var distance_to_destination : float

func Enter():
	target = get_tree().get_first_node_in_group("Player")
	destination = target.global_position

func Physics_Update(delta: float):
	move_direction = enemy.global_position.direction_to(destination)
	distance_to_destination = enemy.global_position.distance_to(destination)
	enemy.velocity = move_direction * move_speed
	
	if distance_to_destination < 100.0:
		Transitioned.emit(self, "EnemyApproachState")
