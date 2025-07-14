extends State
class_name EnemyTiredState

@export var enemy: CharacterBody2D
@export var rest_time: float

var rest_timer: Timer

func Enter():
	enemy.get_tree().create_timer(rest_time).timeout.connect(func(): Transitioned.emit(self, "EnemyExplodeState"))
