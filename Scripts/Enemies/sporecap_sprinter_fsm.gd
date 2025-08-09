#SporecapSprinter StateMachine
extends StateMachine

func _enter_tree() -> void:
	pass

func _ready():
	add_state("approach")
	add_state("charge")
	add_state("fixin_to_bust")
	add_state("explode")
	call_deferred("set_state", states.approach)
	
func _state_logic(delta: float):
	match state:
		states.approach:
			parent.approach(delta)
		states.charge:
			parent.charge(delta)
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
			get_node("../Collision_Area2D").disabled = true
			var target_position = parent.player.global_position
			parent.charge_destination = target_position + (parent.global_position.direction_to(target_position) * 500.0)
			pass
		states.fixin_to_bust:
			#stop walking animation
			#start fixin' to bust animation
			pass
		states.explode:
			parent.explode()
