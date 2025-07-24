extends Node

signal game_time_elapsed(seconds: int)
signal game_time_expired

var player: CharacterBody2D
var game_timer: Timer
var game_timer_duration := 600
var prev_elapsed_game_time: int

func _ready():
	set_process(true)
	player = get_tree().get_first_node_in_group("Player")
	game_timer = get_tree().get_first_node_in_group("GameTimer")
	
	game_timer.timeout.connect(func(): game_time_expired.emit())
	game_timer.start(600)
	

func _process(delta: float) -> void:
	var elapsed_game_time = int(game_timer_duration - game_timer.time_left)
	if elapsed_game_time > prev_elapsed_game_time:
		prev_elapsed_game_time = elapsed_game_time
		game_time_elapsed.emit(elapsed_game_time)

func get_player() -> CharacterBody2D:
	if not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("Player")
	return player
	
func get_game_timer() -> Timer:
	if not is_instance_valid(game_timer):
		game_timer = get_tree().get_first_node_in_group("GameTimer")
	return game_timer
