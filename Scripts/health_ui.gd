extends Control

@export var heart_texture: Texture2D  # Drag your full heart sprite here
@export var empty_heart_texture: Texture2D  # Drag your empty heart sprite here
@export var heart_spacing: int = 5  # Space between hearts
@export var hearts_per_row: int = 10  # Max hearts per row before wrapping

var max_health: int = 0
var current_health: int = 0
var heart_containers: Array[TextureRect] = []

func _ready():
	var player = GameCache.get_player()
	if player:
		player.health_changed.connect(_on_health_changed)
		max_health = player.max_hp
		current_health = player.current_hp
		update_hearts()

func _on_health_changed(health: int):
	if health < current_health:
		animate_damage()
	if health > current_health:
		animate_heal()
	current_health = health
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
	for i in range(max_health):
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
		if i < current_health:
			heart.texture = heart_texture  # Full heart
		else:
			heart.texture = empty_heart_texture  # Empty heart

func set_health(health: int, max_hp: int):
	max_health = max_hp
	_on_health_changed(health)

func animate_damage():
	var tween = create_tween()
	tween.tween_property(self, "position", position + Vector2(50, 0), 0.05)
	tween.tween_property(self, "position", position - Vector2(50, 0), 0.05)
	tween.tween_property(self, "position", position, 0.05)

func animate_heal():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.1)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)
