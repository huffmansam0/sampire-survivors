extends Label

func _ready() -> void:
	visible = false

func _process(delta):
	var fps = Engine.get_frames_per_second()
	text = "FPS: " + str(fps)

func _input(event):
	if event.is_action_pressed("ui_fps"):
		get_viewport().set_input_as_handled()
		visible = !visible
