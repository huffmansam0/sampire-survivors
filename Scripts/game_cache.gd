extends Node

var player: CharacterBody2D

func _ready():
	player = get_tree().get_first_node_in_group("Player")

func get_player() -> CharacterBody2D:
	if not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("Player")
	return player
