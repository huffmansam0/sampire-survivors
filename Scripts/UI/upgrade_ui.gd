extends VBoxContainer
class_name UpgradeUI

const UpgradeButton = preload("res://Scenes/UI/Upgrade_Button.tscn")

@onready var upgrade_container: HBoxContainer = $UpgradeHBoxContainer
@onready var confirm_button: Button = $ConfirmButton
@onready var upgrade_panel: UpgradePanel = $UpgradePanel

var upgrades: Array[UpgradeResource] = []
var upgrade_buttons: Array[Button] = []

var selected_upgrade: UpgradeResource : set = _on_selected_upgrade_changed
var double_click_timer: Timer
var double_click_previous_button_index: int

func _ready():
	double_click_timer = Timer.new()
	double_click_timer.wait_time = 0.3
	double_click_timer.one_shot = true
	add_child(double_click_timer)
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	
	ExperienceManager.level_changed.connect(_on_level_changed)
	
	confirm_button.button_down.connect(_on_confirmed)

func _on_confirmed():
	visible = false
	upgrades.clear()
	upgrade_buttons.clear()
	
	for child in upgrade_container.get_children():
		child.queue_free()
	
	PauseManager.toggle_pause("level_up")
	UpgradeManager.upgrade_acquired(selected_upgrade)

func _on_upgrade_button_pressed(upgrade_index: int):
	selected_upgrade = upgrades[upgrade_index]
	
	if double_click_timer.time_left > 0 and upgrade_index == double_click_previous_button_index:
		_on_confirmed()
	
	double_click_previous_button_index = upgrade_index
	double_click_timer.start()

func _on_level_changed(current_level):
	_update_upgrades()
	visible = true
	
func _update_upgrades():
	
	upgrades = UpgradeManager.get_upgrades()
	
	for i in range(upgrades.size()):
		var upgrade_button_instance = UpgradeButton.instantiate()
		upgrade_container.add_child(upgrade_button_instance)
		upgrade_button_instance.button_down.connect(_on_upgrade_button_pressed.bind(i))
		upgrade_button_instance.icon = upgrades[i].icon
		upgrade_buttons.append(upgrade_button_instance)

	selected_upgrade = upgrades[0]
	upgrade_buttons[0].grab_focus()
	
func _on_selected_upgrade_changed(upgrade: UpgradeResource):
	selected_upgrade = upgrade
	if upgrade:
		upgrade_panel.set_upgrade(upgrade.name, upgrade.description)
