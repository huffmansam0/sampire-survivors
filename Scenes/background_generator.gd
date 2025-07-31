extends Node

@export var map_size := Vector2i(50, 50)  # Tiles to generate
@export var noise_scale := 0.1
@export var tile_source_id := 0  # Usually 0 for first tileset

@onready var tile_map: TileMapLayer = $TileMapLayer

var noise: FastNoiseLite

func _ready():
	setup_noise()
	generate_background()
	print("TileMapLayer scale: ", tile_map.scale)

func setup_noise():
	noise = FastNoiseLite.new()
	noise.seed = randi()
	noise.frequency = noise_scale
	noise.noise_type = FastNoiseLite.TYPE_PERLIN

func generate_background():
	for x in range(-map_size.x/2, map_size.x/2):
		for y in range(-map_size.y/2, map_size.y/2):
			tile_map.set_cell(Vector2i(x, y), 0, Vector2i(7, 4))

func get_tile_from_noise(noise_value: float) -> int:
	# Map noise values (-1 to 1) to tile IDs
	if noise_value < -0.3:
		return 0  # Grass tile
	elif noise_value < 0.1:
		return 1  # Stone tile
	elif noise_value < 0.4:
		return 2  # Dirt tile
	else:
		return 0  # Default to grass
