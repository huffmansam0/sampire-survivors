extends Control

@onready var time_label: Label = $GameTimerUILabel
@onready var game_timer: Timer = GameManager.get_game_timer()
@onready var current_game_time = game_timer.time_left

func _ready():
	pass
	
func _process(delta: float) -> void:
	var time_left = GameManager.game_timer.time_left
	
	if time_left < 0:
		time_left = 0
		
	var minutes = int(time_left) / 60
	var seconds = int(time_left) % 60
	
	time_label.text = "%2d:%02d" % [minutes, seconds]
