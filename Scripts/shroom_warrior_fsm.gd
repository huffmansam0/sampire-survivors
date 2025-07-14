#ShroomWarrior StateMachine
extends StateMachine

func _ready():
	parent = get_parent()
	add_state("approach")
	call_deferred("set_state", states.approach)
	
func _state_logic(delta):
	match state:
		states.approach:
			parent.approach()
			
func _get_transition(delta):
	match state:
		states.approach:
			pass
	return null
	
func _enter_state(new_state, old_state):
	match new_state:
		states.approach:
			#parent.animation_player.play("Walk")
			pass
