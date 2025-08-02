extends Control
class_name TitleScreen

@onready var title: Sprite2D = $Title
@onready var snail: Sprite2D = $Snail
@onready var start_game: Sprite2D = $StartGame

var game_ready: bool = false

func _ready() -> void:
	await _play_intro_animation()
	_play_blinking_animation()
	
func _input(event: InputEvent):
	#if game_ready:
		if event is InputEventKey and event.pressed:
			SignalBus.scene_transition_requested.emit("res://Scenes/Snail_Graveyard.tscn")
		elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			SignalBus.scene_transition_requested.emit("res://Scenes/Snail_Graveyard.tscn")
		
func _play_intro_animation() -> void:
	var intro_tween: Tween = create_tween()
	
	intro_tween.tween_interval(2)
	intro_tween.tween_property(title, "position", title.position + Vector2(0, -600), 2)
	intro_tween.tween_interval(0.3)
	intro_tween.tween_property(snail, "flip_h", true, 0.0)
	intro_tween.tween_interval(0.9)
	intro_tween.tween_property(snail, "position", Vector2(0, 0), 1.5)
	intro_tween.tween_interval(0.3)
	intro_tween.tween_property(snail, "flip_h", false, 0.0)
	intro_tween.tween_interval(1)
	
	await intro_tween.finished

func _play_blinking_animation() -> void:
	start_game.visible = true
	game_ready = true
	
	var blink_tween: Tween = create_tween()
	
	blink_tween.set_loops() 
	
	blink_tween.tween_property(start_game, "visible", false, 0.0).set_delay(1)
	blink_tween.tween_property(start_game, "visible", true, 0.0).set_delay(1)
