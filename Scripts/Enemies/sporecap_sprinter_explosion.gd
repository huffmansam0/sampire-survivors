extends CharacterBody2D
class_name SporecapSprinterExplosion

@onready var animation_player: AnimationPlayer = $AnimationPlayers

func _ready():
	animation_player.animation_finished.connect(func(__): queue_free())
