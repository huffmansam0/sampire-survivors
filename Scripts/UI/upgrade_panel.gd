extends Control
class_name UpgradePanel

@onready var title_label = $Background/MarginContainer/VBoxContainer/Title
@onready var description_label = $Background/MarginContainer/VBoxContainer/Description

func set_upgrade(upgrade_title: String, upgrade_description: String):
	title_label.text = upgrade_title
	description_label.text = upgrade_description

func _ready():
	pass
