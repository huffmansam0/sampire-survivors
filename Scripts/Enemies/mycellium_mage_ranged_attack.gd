extends CharacterBody2D
class_name MycelliumMageRangedAttack

@export var move_speed := 700.0
@export var base_damage := 1

var life_time := 5.0

var target: Player = GameManager.player
var move_direction: Vector2

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_sheet: Sprite2D = $SpriteSheet
@onready var timeout: Timer = $Timeout
@onready var hitbox: Area2D = $Hitbox

func _ready():
	timeout.timeout.connect(queue_free)
	timeout.start(life_time)
	hitbox.area_entered.connect(func(area): hit_player())
	
	move_direction = global_position.direction_to(target.global_position)
	velocity = move_direction * move_speed
	sprite_sheet.rotation = velocity.angle() + PI
	
func _physics_process(delta: float) -> void:
	move_and_collide(velocity * delta)
	
func hit_player():
	target.take_damage(base_damage)
	queue_free()
