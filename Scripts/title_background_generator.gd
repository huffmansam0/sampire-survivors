extends Node
class_name TitleBackgroundGenerator

@export var starting_size := Vector2i(8, 6)

@onready var tile_map: TileMapLayer = $TileMapLayer

@onready var tile_indexes: Array[int] = GameManager.get_background_tiles()
@onready var tile_index_weights: Array[int] = GameManager.get_background_tile_weights()

const tile_map_row = 4
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
@onready var tile_position_label = get_tree().get_first_node_in_group("TilePosition")

#state
var current_tile: Vector2i = Vector2i(0, 0)

func _ready():
	await get_tree().process_frame
	generate_starting_background()

func generate_starting_background():
	for x in range(-starting_size.x/2, starting_size.x/2 + 1):
		for y in range(-starting_size.y/2, starting_size.y/2 + 1):
			var flip_transform = TileSetAtlasSource.TRANSFORM_FLIP_H if rng.randf() < 0.5 else 0
			tile_map.set_cell(Vector2i(x, y), 0, Vector2i(_get_random_tile(), tile_map_row), flip_transform)

func _get_random_tile() -> int:
	randomize()
	return tile_indexes[rng.rand_weighted(tile_index_weights)]
