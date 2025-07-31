extends Node
class_name StateMachine

var state = null : set = set_state
var previous_state = null
var states = {}

@onready var parent = get_parent()

func _physics_process(delta: float):
	if state:
		_state_logic(delta)
		var transition = _get_transition(delta)
		if transition:
			set_state(transition)

func _state_logic(delta: float):
	pass
	
func _get_transition(delta: float):
	return null
	
func _enter_state(new_state, old_state):
	pass

func _exit_state(new_state, old_state):
	pass
	
func set_state(new_state):
	previous_state = state
	state = new_state
	
	if previous_state:
		_exit_state(new_state, previous_state)
	if new_state:
		_enter_state(new_state, previous_state)
		
func add_state(state_name):
	states[state_name] = states.size() + 1
