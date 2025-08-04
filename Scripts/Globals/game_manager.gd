extends StateMachine

signal game_time_expired

const background_tiles: Array[int] = [5, 6, 7, 8, 9, 10]
const background_tile_weights: Array[int] = [1000, 30, 300, 1000, 600, 1]

var player: CharacterBody2D
var game_timer: Timer
var game_timer_duration := 600
var prev_elapsed_game_time: int

#do these in a collection?
var victory_requested: bool = false
var restart_requested: bool = false
var defeat_requested: bool = false
var in_game_requested: bool = false

func _ready():
	add_state("title_screen")
	add_state("in_game")
	add_state("defeat")
	add_state("victory")
	add_state("restarting")
	
	call_deferred("set_state", states.title_screen)
	
	SignalBus.scene_transition_requested.connect(_on_scene_transition_requested)
	SignalBus.game_started.connect(_start_game)
	SignalBus.game_ended.connect(_end_game)
	SignalBus.defeat.connect(_on_defeat)
	
func _input(event):
	if state and event.is_action_pressed("ui_restart"):
		restart_requested = true

	
func _start_game():
	player = get_tree().get_first_node_in_group("Player")
	game_timer = get_tree().get_first_node_in_group("GameTimer")
	
	game_timer.wait_time = game_timer_duration
	game_timer.timeout.connect(func(): 
		victory_requested = true
	)
	game_timer.start()
	
func _end_game():
	player = null
	
func _on_defeat():
	defeat_requested = true
	
func _on_scene_transition_requested(path: String):
	if (path == "res://Scenes/Snail_Graveyard.tscn"):
		in_game_requested = true

func _reset_requests():
	victory_requested = false
	restart_requested = false
	defeat_requested = false
	in_game_requested = false

func _state_logic(delta: float):
	match state:
		states.in_game:
			if game_timer:
				var elapsed_game_time = int(game_timer_duration - game_timer.time_left)
				if elapsed_game_time > prev_elapsed_game_time:
					prev_elapsed_game_time = elapsed_game_time
					SignalBus.game_time_elapsed.emit(elapsed_game_time)

func _get_transition(delta: float):
	var new_state
	
	match state:
		states.title_screen:
			if in_game_requested:
				new_state = states.in_game
		states.in_game:
			if restart_requested:
				new_state = states.restarting
			if victory_requested:
				new_state = states.victory
			if defeat_requested:
				new_state = states.defeat
		states.defeat:
			if restart_requested:
				new_state = states.restarting
		states.victory:
			if restart_requested:
				new_state = states.restarting
		states.restarting:
			if in_game_requested:
				new_state = states.in_game
	
	_reset_requests()
	return new_state
		
func _enter_state(new_state, old_state):
	match new_state:
		states.title_screen:
			get_tree().change_scene_to_file("res://Scenes/TitleScreen.tscn")
		states.in_game:
			get_tree().change_scene_to_file("res://Scenes/Snail_Graveyard.tscn")
		states.victory:
			SignalBus.victory.emit()
		states.restarting:
			SignalBus.game_ended.emit()
			get_tree().reload_current_scene()
			in_game_requested = true
		
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
