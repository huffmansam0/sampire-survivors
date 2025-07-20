extends Control
class_name ExperienceUI

@onready var progress_bar: ProgressBar = $ExperienceProgressBar
@onready var label: Label = $ExperienceLabel
@onready var experience_manager: ExperienceManager = $"../../ExperienceManager"

func _ready():
	experience_manager.experience_changed.connect(_on_experience_changed)
	progress_bar.min_value = 0

func _on_experience_changed(current_experience, experience_to_next_level):
	progress_bar.max_value = experience_to_next_level
	progress_bar.value = current_experience
	label.text = "%d / %d" % [current_experience, experience_to_next_level]
