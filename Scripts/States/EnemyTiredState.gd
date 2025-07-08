extends State
class_name EnemyTiredState

@export var enemy: CharacterBody2D
@export var rest_time: float

var rest_timer: Timer

func Enter():
	rest_timer = Timer.new()
	rest_timer.wait_time = rest_time
	rest_timer.one_shot = true
	rest_timer.timeout.connect(func(): Transitioned.emit(self, "EnemyApproachState"))
	enemy.add_child(rest_timer)
	rest_timer.start()
