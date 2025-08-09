extends CharacterBody2D
class_name Experience

signal experience_collected
signal distance_to_player_changed(experience: Experience, distance: float)

const UPDATE_DISTANCE_TO_PLAYER_INTERVAL: float = 3.0
const APPROACH_TOP_SPEED: float = 50.0
const APPROACH_ACCEL_RATE: float = 200.0
const RETREAT_SPEED: float = 10.0

var collect_requested: bool = false
var approach_requested: bool = false
var move_direction: Vector2
var accel_mult: float = 1.0

@onready var collection_hitbox: Area2D = $CollectionHitbox
@onready var final_collection_hitbox: Area2D = $FinalCollectionHitbox
@onready var grounded_sprite: Sprite2D = $GroundedSprite
@onready var collected_sprite: Sprite2D = $CollectedSprite
@onready var player = GameManager.get_player()


func _ready() -> void:
	var update_distance_to_player_timer = Timer.new()
	update_distance_to_player_timer.wait_time = UPDATE_DISTANCE_TO_PLAYER_INTERVAL
	update_distance_to_player_timer.one_shot = false
	update_distance_to_player_timer.timeout.connect(_update_distance_to_player)
	add_child(update_distance_to_player_timer)
	
	update_distance_to_player_timer.start()

func _update_distance_to_player():
	var distance = global_position.distance_to(player.global_position)
	distance_to_player_changed.emit(self, distance)

func approach(delta: float):
	move_direction = global_position.direction_to(player.global_position) * APPROACH_TOP_SPEED
	velocity = velocity.move_toward(move_direction, APPROACH_ACCEL_RATE * delta)
	move_and_collide(velocity)
	
func retreat(delta: float):
	#set initial velocity
	move_direction = global_position.direction_to(player.global_position) * -1
	velocity = move_direction * RETREAT_SPEED
	move_and_collide(velocity)
	
func enter_ground_state():
	collection_hitbox.area_entered.connect(func(_area): collect_requested = true)
	grounded_sprite.visible = true
	collected_sprite.visible = false

func enter_collect_state():
	grounded_sprite.visible = false
	collected_sprite.visible = true
	
	var timer = Timer.new()
	timer.wait_time = 0.2
	timer.autostart = true
	timer.one_shot = true
	timer.timeout.connect(func(): approach_requested = true)
	add_child(timer)
	
func enter_approach_state():
	#set up listener for collection
	final_collection_hitbox.area_entered.connect(collect)
	
func collect(__):
	experience_collected.emit()
	queue_free()

func reset_requests():
	collect_requested = false
