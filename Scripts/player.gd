extends CharacterBody2D
class_name Player

@export var slime_scene = preload("res://Scenes/Slime.tscn")
@export var speed: float = 600.0
@export var max_hp: int = 6
@export var slime_spawn_time = 0.25

@onready var label = $Label
@onready var hurt_audios = [$SnailDamagedTake1, $SnailDamagedTake2, $SnailDamagedTake3, $"ShittySadTrombone1"]
@onready var slime_timer = $Slime_Timer
@onready var player_sprite = $PlayerSprite
@onready var slime_manager = get_node("../SlimeManager")

signal health_changed(new_health)

var current_hp: int

var damage_timer: Timer
var damage_cooldown: float = 1
var damage_amount: int = 1
var damage_boosting: bool = false

func _ready():
	process_mode = Node.PROCESS_MODE_PAUSABLE
	current_hp = max_hp
	slime_timer.wait_time = slime_spawn_time
	slime_timer.timeout.connect(spawn_slime)
	slime_timer.start()

func _physics_process(delta):
	if ($Hurtbox_Area2D.has_overlapping_areas() && !damage_boosting):
		take_damage(damage_amount)

	handle_movement()
	move_and_collide(velocity * delta)

func handle_movement():
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
	label.text = "You Died.\nYou Suck.\nFuck You."
	
#	Can't play music here, probably because we're pausing right after we start the clip.
	#var temp_audio = AudioStreamPlayer.new()
	#temp_audio.stream = $"Vm1k2Prpti-sad-trombone-sfx-1".stream  # Copy the audio clip
	#add_child(temp_audio)
	#temp_audio.play()
	#
	#temp_audio.finished.connect(func(): temp_audio.queue_free())
	
	get_tree().paused = true
	
func spawn_slime():
	slime_manager.spawn_puddle(global_position)
