extends CanvasLayer

@onready var SKILL: TextureRect = $SKILL
@onready var ISSUE: TextureRect = $ISSUE
@onready var go_again: TextureRect = $GoAgain

func _ready() -> void:
	SignalBus.defeat.connect(_on_defeat)
	
func _on_defeat():
	await _skill_issue()
	_blink_go_again()
	
func _skill_issue():
	var tween = create_tween()
	
	SKILL.visible = true
	tween.tween_property(SKILL, "scale", Vector2(0.4, 0.4), 0.25)
	tween.tween_callback(func(): ISSUE.visible = true)
	tween.tween_property(ISSUE, "scale", Vector2(0.4, 0.4), 0.25)
	
	await tween.finished
	
func _blink_go_again():
	var blink_tween = create_tween()
	
	blink_tween.set_loops() 
	
	blink_tween.tween_property(go_again, "visible", false, 0.0).set_delay(0.7)
	blink_tween.tween_property(go_again, "visible", true, 0.0).set_delay(1)
