#SporecapSprinter StateMachine
extends StateMachine

func _ready():
	parent = get_parent()
	add_state("approach")
	add_state("charge")
	add_state("fixin_to_bust")
	add_state("explode")
	call_deferred("set_state", states.approach)
	
func _state_logic(delta):
	match state:
		states.approach:
			parent.approach()
		states.charge:
			parent.charge()
		states.fixin_to_bust:
			parent.fix_to_bust()
		states.explode:
			pass
			#parent.explode()
			
func _get_transition(delta):
	match state:
		states.approach:
			if parent.should_charge():
				return states.charge
		states.charge:
			if parent.should_fix_to_bust():
				return states.fixin_to_bust
		states.fixin_to_bust:
			if parent.should_explode():
				return states.explode
		states.explode:
			return null
	return null
	
func _enter_state(new_state, old_state):
	match new_state:
		states.approach:
			parent.animation_player.play("Walk")
			pass
		states.charge:
			var target_position = parent.target.global_position
			parent.charge_destination = target_position + (parent.global_position.direction_to(target_position) * 500.0)
			pass
		states.fixin_to_bust:
			#stop walking animation
			#start fixin' to bust animation
			pass
		states.explode:
			parent.animation_player.animation_finished.connect(func(new_name): parent.queue_free())
			get_node("../HealthBar").visible = false
			parent.animation_player.play("Explode")
