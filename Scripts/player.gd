extends CharacterBody2D
class_name Player

signal player_position_changed(new_position: Vector2)

#upgradable stats
var speed: float = 1200.0
var speed_mult: float = 0
var max_hp: int = 6
var experience_box_mult: int = 0

@onready var experience_box = $ExperienceBox
@onready var label = $Label
@onready var hurt_audios = [$SnailDamagedTake1, $SnailDamagedTake2, $SnailDamagedTake3, $"ShittySadTrombone1"]
@onready var player_sprite = $PlayerSprite
@onready var kyle_sad_trumpet = preload("res://Audio/sad_trumpy_kyle.wav")

signal health_changed(new_health)

var current_hp: int

var damage_cooldown: float = 1
var damage_amount: int = 1
var damage_boosting: bool = false

func _ready():
	current_hp = max_hp
	player_position_changed.connect(func(new_position: Vector2): print(new_position))

func _physics_process(delta: float):
	if ($Hurtbox_Area2D.has_overlapping_areas() && !damage_boosting):
		take_damage(damage_amount)

	handle_movement(delta)
	move_and_slide()
	player_position_changed.emit(global_position)

func handle_movement(delta: float):
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * speed
	
	if input_direction.x != 0:
		player_sprite.flip_h = input_direction.x >= 0
	
func take_damage(amount: int):
	if damage_boosting:
		return
	current_hp -= amount
	damage_boosting = true
	get_tree().create_timer(damage_cooldown).timeout.connect(func(): damage_boosting = false)
	
	health_changed.emit(current_hp)
	
	#TODO: how are audio sources usually handled? this probably needs to be cleaned up
	#var temp_audio = AudioStreamPlayer.new()
	#temp_audio.stream = hurt_audios[randi() % hurt_audios.size()].stream
	#add_child(temp_audio)
	#temp_audio.play()
	#
	#temp_audio.finished.connect(func(): temp_audio.queue_free())
	
	if (current_hp <= 0):
		die()
		
func die():
	if speed > 0:
		label.text = "You Died.\nYou Suck.\nFuck You."
		
	#	Can't play music here, probably because we're pausing right after we start the clip.
		var temp_audio = AudioStreamPlayer.new()
		temp_audio.stream = kyle_sad_trumpet  # Copy the audio clip
		add_child(temp_audio)
		temp_audio.play()
		
		temp_audio.finished.connect(func(): temp_audio.queue_free())
		
		speed = 0
