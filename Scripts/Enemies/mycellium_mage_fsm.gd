#MycelliumMage StateMachine
extends StateMachine

func _ready():
	parent = get_parent()
	add_state("approach")
	add_state("shoot")
	call_deferred("set_state", states.approach)
	
func _state_logic(delta: float):
	match state:
		states.approach:
			parent.approach(delta)
		states.shoot:
			parent.shoot()
			
func _get_transition(delta: float):
	match state:
		states.approach:
			if parent.should_shoot():
				return states.shoot
		states.shoot:
			if parent.should_approach():
				return states.approach
	return null
	
func _enter_state(new_state, old_state):
	match states[new_state]:
		states.approach:
			#parent.animation_player.play("Walk")
			pass
		states.shoot:
			pass
