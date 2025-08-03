# placeholder_map_name.gd
extends Node

#var pause_menu_scene = preload("res://ui/PauseMenu.tscn")
var pause_menu_instance

func _ready():
	PauseManager.enable_pause()
	SignalBus.game_started.emit()

func _exit_tree():
	PauseManager.disable_pause()
