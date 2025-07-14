extends Enemy

@export var move_speed := 200.0

var target = GameCache.get_player()
var move_direction: Vector2
var distance_to_target: float

@onready var hp_bar = $HealthBar
@onready var state_machine = $StateMachine
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	max_hp = 300
	hp_bar.max_value = max_hp
	hp_bar.min_value = 0
	hp_bar.value = current_hp
	super._ready()
	
func approach():
	move_direction = global_position.direction_to(target.global_position)
	distance_to_target = global_position.distance_to(target.global_position)
	velocity = move_direction * move_speed
	move_and_slide()

func take_damage(amount: int):
	super.take_damage(amount)
	hp_bar.value = current_hp
