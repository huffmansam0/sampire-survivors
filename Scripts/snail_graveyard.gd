extends Node

func _ready():
	PauseManager.enable_pause()
	SignalBus.game_started.emit()

func _exit_tree():
	PauseManager.disable_pause()
