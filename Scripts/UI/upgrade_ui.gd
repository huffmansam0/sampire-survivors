extends VBoxContainer
class_name UpgradeUI

@onready var upgrade_button_1: Button = $UpgradeHBoxContainer/UpgradeButton
@onready var upgrade_button_2: Button = $UpgradeHBoxContainer/UpgradeButton2
@onready var upgrade_button_3: Button = $UpgradeHBoxContainer/UpgradeButton3
@onready var confirm_button: Button = $ConfirmButton
@onready var upgrade_panel: UpgradePanel = $UpgradePanel

var upgrades: Array[UpgradeResource] = []

var selected_upgrade: UpgradeResource : set = _on_selected_upgrade_changed

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	confirm_button.disabled = true
	
	ExperienceManager.level_changed.connect(_on_level_changed)
	upgrade_button_1.button_up.connect(_on_upgrade_button_pressed.bind(0))
	upgrade_button_2.button_up.connect(_on_upgrade_button_pressed.bind(1))
	upgrade_button_3.button_up.connect(_on_upgrade_button_pressed.bind(2))
	confirm_button.button_up.connect(_on_confirm_button_pressed)

func _on_confirm_button_pressed():
	visible = false
	PauseManager.toggle_pause("level_up")
	UpgradeManager.upgrade_acquired(selected_upgrade)

func _on_upgrade_button_pressed(upgrade_index: int):
	confirm_button.disabled = false
	selected_upgrade = upgrades[upgrade_index]

func _on_level_changed(current_level):
	_update_upgrades()
	upgrade_panel.set_upgrade("Level Up!", "Select an upgrade. Choose wisely...")
	confirm_button.disabled = true
	visible = true
	
func _update_upgrades():
	upgrades = UpgradeManager.get_upgrades()
	upgrade_button_1.icon = upgrades[0].icon
	upgrade_button_2.icon = upgrades[1].icon
	upgrade_button_3.icon = upgrades[2].icon

func _on_selected_upgrade_changed(upgrade: UpgradeResource):
	selected_upgrade = upgrade
	if upgrade:
		upgrade_panel.set_upgrade(upgrade.name, upgrade.description)
