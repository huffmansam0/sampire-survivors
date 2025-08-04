extends Node

#Bus for global signals

signal scene_transition_requested(scene_path: String)
signal game_started
signal game_ended
signal victory
signal defeat
signal enemy_died(enemy: Enemy)
signal game_time_elapsed(seconds: int)
