extends MarginContainer
class_name ExperienceUI

@onready var progress_bar: ProgressBar = $ExperienceProgressBar
@onready var label: Label = $ExperienceLabel
@onready var experience_manager: ExperienceManager = $"../../../../ExperienceManager" #TODO: fix this and don't do this any more

func _ready():
	experience_manager.experience_changed.connect(_on_experience_changed)
	experience_manager.level_changed.connect(_on_level_changed)
	progress_bar.min_value = 0

func _on_experience_changed(current_experience, experience_to_next_level):
	progress_bar.max_value = experience_to_next_level
	progress_bar.value = current_experience
	
func _on_level_changed(current_level):
	label.text = "Level %d" % current_level
