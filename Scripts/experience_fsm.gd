extends StateMachine

func _ready():
	add_state("ground")
	add_state("collect")
	add_state("approach")
	call_deferred("set_state", states.ground)
	
func _state_logic(delta: float):
	match state:
		states.ground:
			pass
		states.collect:
			parent.retreat(delta)
		states.approach:
			parent.approach(delta)
			
func _get_transition(delta: float):
	var new_state = null
	
	match state:
		states.ground:
			if parent.collect_requested:
				new_state = states.collect
		states.collect:
			if parent.approach_requested:
				new_state = states.approach
			pass
			
	parent.reset_requests()
	
	return new_state
	
func _enter_state(new_state, old_state):
	match state:
		states.ground:
			parent.enter_ground_state()
		states.collect:
			parent.enter_collect_state()
		states.approach:
			parent.enter_approach_state()
