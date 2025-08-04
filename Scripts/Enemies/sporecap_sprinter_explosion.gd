extends Enemy
class_name SporecapSprinterExplosion

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_sheet: Sprite2D = $SpriteSheet
@onready var hitbox: Area2D = $Hitbox

func _ready():
	animation_player.animation_finished.connect(func(__): queue_free())
