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
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal()) * 0.8

func take_damage(amount: float):
	super.take_damage(amount)
	hp_bar.value = current_hp
