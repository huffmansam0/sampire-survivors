extends Node2D
class_name Experience

signal experience_collected

@onready var collection_hitbox: Area2D = $CollectionHitbox
@onready var player = GameManager.get_player()


func _ready() -> void:
	collection_hitbox.area_entered.connect(func(_area): collect())

func collect():
	experience_collected.emit()
	queue_free()
