extends Label

@onready var player: Player = GameManager.get_player()

func _ready() -> void:
	pass

func set_tile(tile: Vector2i):
	text = "Tile: " + str(tile) + " | Coordinates: " + str(player.global_position)
