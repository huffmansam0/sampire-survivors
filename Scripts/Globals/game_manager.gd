extends StateMachine

signal game_time_elapsed(seconds: int)
signal game_time_expired

const background_tiles: Array[int] = [5, 6, 7, 8, 9, 10]
const background_tile_weights: Array[int] = [1000, 30, 300, 1000, 600, 1]

var player: CharacterBody2D
var game_timer: Timer
var game_timer_duration := 600
var prev_elapsed_game_time: int

func _ready():
	add_state("title_screen")
	add_state("in_game")
	add_state("defeated")
	
	call_deferred("set_state", states.title_screen)
	
	SignalBus.scene_transition_requested.connect(_on_scene_transition_requested)
	SignalBus.game_started.connect(_start_game)
	SignalBus.defeat.connect(_on_defeat)
	
func _input(event):
	if state and event.is_action_pressed("ui_restart"):
		SignalBus.game_ended.emit()
		get_tree().call_deferred("reload_current_scene")
	
func _start_game():
	player = get_tree().get_first_node_in_group("Player")
	game_timer = get_tree().get_first_node_in_group("GameTimer")
	
	game_timer.timeout.connect(func(): SignalBus.victory.emit())
	game_timer.start()
	
func _on_defeat():
	call_deferred("set_state", states.defeated)
	
func _on_scene_transition_requested(path: String):
	if (path == "res://Scenes/Snail_Graveyard.tscn"):
		call_deferred("set_state", states.in_game)
	
func _process(delta: float) -> void:
	pass

func _state_logic(delta: float):
	match state:
		states.in_game:
			if game_timer:
				var elapsed_game_time = int(game_timer_duration - game_timer.time_left)
				if elapsed_game_time > prev_elapsed_game_time:
					prev_elapsed_game_time = elapsed_game_time
					game_time_elapsed.emit(elapsed_game_time)

func _get_transition(delta: float):
	match state:
		pass
		
func _enter_state(new_state, old_state):
	match new_state:
		states.title_screen:
			get_tree().change_scene_to_file("res://Scenes/TitleScreen.tscn")
		states.in_game:
			get_tree().change_scene_to_file("res://Scenes/Snail_Graveyard.tscn")
			
		
func _exit_state(new_state, old_state):
	match old_state:
		pass

func get_player() -> CharacterBody2D:
	if not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("Player")
	return player
	
func get_game_timer() -> Timer:
	if not is_instance_valid(game_timer):
		game_timer = get_tree().get_first_node_in_group("GameTimer")
	return game_timer
	
func get_background_tiles() -> Array[int]:
	return background_tiles
	
func get_background_tile_weights() -> Array[int]:
	return background_tile_weights
