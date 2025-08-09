extends Node2D
class_name DeathAnimation

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	animation_player.animation_finished.connect(func(__): queue_free())
