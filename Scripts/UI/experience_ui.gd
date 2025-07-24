extends MarginContainer
class_name ExperienceUI

@onready var progress_bar: ProgressBar = $ExperienceProgressBar
@onready var label: Label = $ExperienceLabel

func _ready():
	ExperienceManager.experience_changed.connect(_on_experience_changed)
	ExperienceManager.level_changed.connect(_on_level_changed)
	progress_bar.min_value = 0

func _on_experience_changed(current_experience, experience_to_next_level):
	progress_bar.max_value = experience_to_next_level
	progress_bar.value = current_experience
	
func _on_level_changed(current_level):
	label.text = "Level %d" % current_level
