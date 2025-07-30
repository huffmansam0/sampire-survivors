extends Enemy
class_name MycelliumMage

@export var shoot_target_proximity := 800.0
@export var shoot_interval := 3.0

var shot_ready := true
var ranged_attack: PackedScene = preload("res://Scenes/Mycellium_Mage_Ranged_Attack.tscn")

@onready var hp_bar = $HealthBar
@onready var state_machine = $StateMachine
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shot_timer: Timer = $ShotTimer

func _ready():
	max_hp = 150
	move_speed = 200.0
	hp_bar.max_value = max_hp
	hp_bar.min_value = 0
	hp_bar.value = current_hp
	
	shot_timer.one_shot = false
	shot_timer.timeout.connect(func(): shot_ready = true)
	shot_timer.start(shoot_interval)
	
	super._ready()
	
func approach():
	move_and_slide()
	
#TODO: make this more efficient if we get more lag
func shoot():
	distance_to_target = global_position.distance_to(player.global_position)
	
	if shot_ready:
		shot_ready = false
		shot_timer.start(shoot_interval)
		var instance = ranged_attack.instantiate()
		instance.global_position = global_position
		get_tree().current_scene.add_child(instance)
	
func should_approach():
	return distance_to_target > shoot_target_proximity

func should_shoot():
	return distance_to_target <= shoot_target_proximity

func take_damage(amount: int):
	super.take_damage(amount)
	hp_bar.value = current_hp
