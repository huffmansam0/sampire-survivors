extends VBoxContainer
class_name UpgradeUI

@onready var upgrade_button_1: Button = $UpgradeHBoxContainer/UpgradeButton
@onready var upgrade_button_2: Button = $UpgradeHBoxContainer/UpgradeButton2
@onready var upgrade_button_3: Button = $UpgradeHBoxContainer/UpgradeButton3
@onready var confirm_button: Button = $ConfirmButton
@onready var upgrade_panel: UpgradePanel = $UpgradePanel

var upgrades: Array[UpgradeResource] = []

var selected_upgrade: UpgradeResource : set = _on_selected_upgrade_changed
var double_click_timer: Timer
var double_click_previous_button_index: int

func _ready():
	double_click_timer = Timer.new()
	double_click_timer.wait_time = 5
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	
	ExperienceManager.level_changed.connect(_on_level_changed)
	upgrade_button_1.button_down.connect(_on_upgrade_button_pressed.bind(0))
	upgrade_button_2.button_down.connect(_on_upgrade_button_pressed.bind(1))
	upgrade_button_3.button_down.connect(_on_upgrade_button_pressed.bind(2))
	confirm_button.button_down.connect(_on_confirmed)

func _on_confirmed():
	visible = false
	PauseManager.toggle_pause("level_up")
	UpgradeManager.upgrade_acquired(selected_upgrade)

func _on_upgrade_button_pressed(upgrade_index: int):
	selected_upgrade = upgrades[upgrade_index]
	
	if double_click_timer.time_left > 0 and upgrade_index == double_click_previous_button_index:
		_on_confirmed()
	
	double_click_previous_button_index = upgrade_index
	add_child(double_click_timer)
	double_click_timer.start()

func _on_level_changed(current_level):
	_update_upgrades()
	visible = true
	
func _update_upgrades():
	upgrades = UpgradeManager.get_upgrades()
	upgrade_button_1.icon = upgrades[0].icon
	upgrade_button_2.icon = upgrades[1].icon
	upgrade_button_3.icon = upgrades[2].icon
	selected_upgrade = upgrades[0]
	upgrade_button_1.grab_focus()
	
func _on_selected_upgrade_changed(upgrade: UpgradeResource):
	selected_upgrade = upgrade
	if upgrade:
		upgrade_panel.set_upgrade(upgrade.name, upgrade.description)
