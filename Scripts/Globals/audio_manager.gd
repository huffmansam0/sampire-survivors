extends Node

@onready var player: Player = GameManager.get_player()
@onready var kyle_sad_trumpet = preload("res://Audio/sad_trumpy_kyle.wav")
@onready var pain_squeak = preload("res://Audio/pain_squeak.wav")
@onready var hurt_audios = [$SnailDamagedTake1, $SnailDamagedTake2, $SnailDamagedTake3,]

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	player.health_changed.connect(_on_player_health_changed)
	player.died.connect(_on_player_died)

func _on_player_health_changed(old_health: int, new_health: int):
	if old_health > new_health:
		var temp_audio = AudioStreamPlayer.new()
		temp_audio.stream = pain_squeak
		add_child(temp_audio)
		temp_audio.play()
		
		temp_audio.finished.connect(func(): temp_audio.queue_free())

func _on_player_died():
	var temp_audio = AudioStreamPlayer.new()
	temp_audio.stream = kyle_sad_trumpet
	add_child(temp_audio)
	temp_audio.play()
	
	temp_audio.finished.connect(func(): temp_audio.queue_free())
