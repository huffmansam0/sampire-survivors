extends Control

@export var full_heart_texture: Texture2D
@export var half_heart_texture: Texture2D
@export var empty_heart_texture: Texture2D
@export var heart_spacing: int = 5
@export var hearts_per_row: int = 10

var max_health: int = 0
var current_health: int = 0
var heart_containers: Array[TextureRect] = []

func _ready():
	SignalBus.game_started.connect(_start_game)
	SignalBus.game_ended.connect(_end_game)

func _exit_tree() -> void:	
	if SignalBus.game_started.is_connected(_start_game):
		SignalBus.game_started.disconnect(_start_game)
		
	if SignalBus.game_ended.is_connected(_end_game):
		SignalBus.game_ended.disconnect(_end_game)

func _start_game():
	var player = GameManager.player
	player.health_changed.connect(_on_health_changed)
	max_health = player.max_hp
	current_health = player.current_hp
	update_hearts()

func _end_game():
	max_health = 0
	current_health = 0


func _on_health_changed(old_hp: int, new_hp: int):
	if new_hp < current_health:
		animate_damage()
	if new_hp > current_health:
		animate_heal()
	current_health = new_hp
	update_hearts()

func update_hearts():
	clear_hearts()
	
	create_heart_containers()

	update_heart_visuals()

func clear_hearts():
	for heart in heart_containers:
		heart.queue_free()
	heart_containers.clear()

func create_heart_containers():
	for i in range(max_health / 2):
		var heart = TextureRect.new()
		heart.texture = empty_heart_texture
		heart.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		heart.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		
		var row = i / hearts_per_row
		var col = i % hearts_per_row
		
		var heart_size = Vector2(64, 64)
		heart.custom_minimum_size = heart_size
		heart.size = heart_size
		
		heart.position = Vector2(
			col * (heart_size.x + heart_spacing),
			row * (heart_size.y + heart_spacing)
		)
		
		add_child(heart)
		heart_containers.append(heart)

func update_heart_visuals():
	for i in range(heart_containers.size()):
		var heart = heart_containers[i]
		if current_health == (i + 1) * 2 - 1:
			heart.texture = half_heart_texture
		elif current_health >= (i + 1) * 2:
			heart.texture = full_heart_texture
		else:
			heart.texture = empty_heart_texture

func set_health(health: int, max_hp: int):
	max_health = max_hp
	_on_health_changed(-1, health)

func animate_damage():
	var tween = create_tween()
	tween.tween_property(self, "position", position + Vector2(50, 0), 0.05)
	tween.tween_property(self, "position", position - Vector2(50, 0), 0.05)
	tween.tween_property(self, "position", position, 0.05)

func animate_heal():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.1)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)
