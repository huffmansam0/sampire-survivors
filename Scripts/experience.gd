extends Node2D
class_name Experience

signal experience_collected
signal distance_to_player_changed(experience: Experience, distance: float)

const update_distance_to_player_interval: float = 3

@onready var collection_hitbox: Area2D = $CollectionHitbox
@onready var player = GameManager.get_player()


func _ready() -> void:
	collection_hitbox.area_entered.connect(func(_area): collect())
	var update_distance_to_player_timer = Timer.new()
	update_distance_to_player_timer.wait_time = update_distance_to_player_interval
	update_distance_to_player_timer.one_shot = false
	update_distance_to_player_timer.timeout.connect(_update_distance_to_player)
	add_child(update_distance_to_player_timer)
	
	update_distance_to_player_timer.start()

func _update_distance_to_player():
	var distance = global_position.distance_to(player.global_position)
	distance_to_player_changed.emit(self, distance)

func collect():
	experience_collected.emit()
	queue_free()
