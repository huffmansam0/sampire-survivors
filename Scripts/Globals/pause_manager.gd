extends Node

var pause_reasons = {}
var is_paused = false
var pause_enabled = false

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func _input(event):
	if pause_enabled and event.is_action_pressed("ui_escape"):
		get_viewport().set_input_as_handled()
		toggle_pause("pause_menu")

func toggle_pause(reason: String):
	if reason in pause_reasons:
		pause_reasons.erase(reason)
	else:
		pause_reasons[reason] = true
	_update_pause_state()
	
func enable_pause():
	pause_enabled = true
	
func disable_pause():
	pause_enabled = false

func _update_pause_state():
	var should_be_paused = pause_reasons.size() > 0
	
	if should_be_paused != is_paused:
		is_paused = should_be_paused
		get_tree().paused = is_paused
		
		pause_changed.emit(is_paused)

signal pause_changed(paused: bool)

func is_game_paused() -> bool:
	return is_paused
