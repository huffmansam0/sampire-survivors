extends State
class_name EnemyApproachState

@export var enemy: CharacterBody2D
@export var striking_distance_state: Node
@export var move_speed := 100.0
@export var striking_distance := 100.0

var target : CharacterBody2D
var move_direction : Vector2
var distance_to_target : float

func Enter():
	target = get_tree().get_first_node_in_group("Player")

func Physics_Update(delta: float):
	move_direction = enemy.global_position.direction_to(target.global_position)
	distance_to_target = enemy.global_position.distance_to(target.global_position)
	enemy.velocity = move_direction * move_speed
	
	if distance_to_target <= striking_distance:
		if striking_distance_state:
			Transitioned.emit(self, striking_distance_state.name)
	
	enemy.move_and_slide()
