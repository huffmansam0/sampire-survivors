extends Node
class_name BackgroundGenerator

@export var starting_size := Vector2i(8, 6)

@onready var tile_map: TileMapLayer = $TileMapLayer
@onready var player: Player = GameManager.get_player()

@onready var tile_indexes: Array[int] = GameManager.get_background_tiles()
@onready var tile_index_weights: Array[int] = GameManager.get_background_tile_weights()

const tile_map_row = 4
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
@onready var tile_position_label = get_tree().get_first_node_in_group("TilePosition")

#state
var current_tile: Vector2i = Vector2i(0, 0)

func _ready():
	await get_tree().process_frame
	tile_position_label.set_tile(current_tile)
	generate_starting_background()
	player.position_changed.connect(_on_player_position_changed)

func generate_starting_background():
	for x in range(-starting_size.x/2, starting_size.x/2 + 1):
		for y in range(-starting_size.y/2, starting_size.y/2 + 1):
			var flip_transform = TileSetAtlasSource.TRANSFORM_FLIP_H if rng.randf() < 0.5 else 0
			tile_map.set_cell(Vector2i(x, y), 0, Vector2i(_get_random_tile(), tile_map_row), flip_transform)
			
func _on_player_position_changed(player_position: Vector2):
	var player_tile: Vector2i = _convert_player_position_to_tile_coords(player_position)
	
	if player_tile == current_tile:
		return

	# Calculate the direction of movement
	var tile_offset: Vector2i = player_tile - current_tile
	
	current_tile = player_tile
	tile_position_label.set_tile(player_tile)

	var radius_x = starting_size.x / 2
	var radius_y = starting_size.y / 2
	
	# Horizontal painting
	if tile_offset.x > 0: # Moved RIGHT, so paint the new right column
		var x = player_tile.x + radius_x
		for y in range(player_tile.y - radius_y, player_tile.y + radius_y + 1):
			var flip_transform = TileSetAtlasSource.TRANSFORM_FLIP_H if rng.randf() < 0.5 else 0
			tile_map.set_cell(Vector2i(x, y), 0, Vector2i(_get_random_tile(), tile_map_row), flip_transform)
	elif tile_offset.x < 0: # Moved LEFT, so paint the new left column
		var x = player_tile.x - radius_x
		for y in range(player_tile.y - radius_y, player_tile.y + radius_y + 1):
			var flip_transform = TileSetAtlasSource.TRANSFORM_FLIP_H if rng.randf() < 0.5 else 0
			tile_map.set_cell(Vector2i(x, y), 0, Vector2i(_get_random_tile(), tile_map_row), flip_transform)

	# Vertical painting
	if tile_offset.y > 0: # Moved DOWN, so paint the new bottom row
		var y = player_tile.y + radius_y
		for x in range(player_tile.x - radius_x, player_tile.x + radius_x + 1):
			var flip_transform = TileSetAtlasSource.TRANSFORM_FLIP_H if rng.randf() < 0.5 else 0
			tile_map.set_cell(Vector2i(x, y), 0, Vector2i(_get_random_tile(), tile_map_row), flip_transform)
	elif tile_offset.y < 0: # Moved UP, so paint the new top row
		var y = player_tile.y - radius_y
		for x in range(player_tile.x - radius_x, player_tile.x + radius_x + 1):
			var flip_transform = TileSetAtlasSource.TRANSFORM_FLIP_H if rng.randf() < 0.5 else 0
			tile_map.set_cell(Vector2i(x, y), 0, Vector2i(_get_random_tile(), tile_map_row), flip_transform)

func _convert_player_position_to_tile_coords(player_position: Vector2) -> Vector2i:
	return Vector2i(floori(player_position.x / 1000.0), floori(player_position.y / 1000.0))

func _get_random_tile() -> int:
	randomize()
	return tile_indexes[rng.rand_weighted(tile_index_weights)]
