extends Enemy
class_name ShroomWarrior

@onready var hp_bar = $HealthBar
@onready var state_machine = $StateMachine
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	max_hp = 150
	move_speed = 200.0
	hp_bar.max_value = max_hp
	hp_bar.min_value = 0
	hp_bar.value = current_hp
	super._ready()
	
func approach(delta: float):
	move_and_slide()

func take_damage(amount: int):
	super.take_damage(amount)
	hp_bar.value = current_hp
