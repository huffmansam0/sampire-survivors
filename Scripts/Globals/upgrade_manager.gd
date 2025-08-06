extends Node

#Key - upgrade name
var available_upgrades: Dictionary[String, UpgradeResource]

#Key - upgrade name
var acquired_upgrades: Dictionary[String, UpgradeResource]

var starting_upgrade_filepaths: Dictionary[String, String] = {
	"Acidic Slime": "res://Upgrades/acidic_slime.tres",
	"Firebreathing": "res://Upgrades/firebreathing.tres",
	"Stalwart Shell": "res://Upgrades/stalwart_shell.tres",
	"Psionic Snail": "res://Upgrades/psionic_snail.tres",
	"Love Dart": "res://Upgrades/love_dart.tres",
}

var player: Player

const base_num_upgrade_choices: int = 3
var num_upgrade_choices: int = base_num_upgrade_choices

@export var upgrades_array = []

func _ready():
	SignalBus.game_started.connect(_start_game)
	SignalBus.game_ended.connect(_end_game)
	
	SignalBus.upgrade_upgrade_acquired.connect(_on_upgrade_upgrade_acquired)

func _exit_tree() -> void:
	pass

func _start_game():
	player = GameManager.get_player()
	available_upgrades = {}
	acquired_upgrades = {}
	num_upgrade_choices = base_num_upgrade_choices
	_load_upgrades()
	
func _end_game():
	pass

func _load_upgrades():
	for upgrade_name in starting_upgrade_filepaths:
		var path = starting_upgrade_filepaths[upgrade_name]
		var resource = load(path)
		available_upgrades[upgrade_name] = resource

func upgrade_acquired(upgrade: UpgradeResource):
	for _upgrade in upgrade.unlocks:
		if _upgrade.name not in acquired_upgrades:
			available_upgrades.get_or_add(_upgrade.name, _upgrade)

	acquired_upgrades.get_or_add(upgrade.name, upgrade)
	available_upgrades.erase(upgrade.name)

	#emit a signal for each type
	for type in upgrade.types:
		match type:
			Globals.UpgradeType.EXPERIENCE:
				SignalBus.experience_upgrade_acquired.emit(upgrade)
			Globals.UpgradeType.PLAYER:
				SignalBus.player_upgrade_acquired.emit(upgrade)
			Globals.UpgradeType.FIRE:
				SignalBus.fire_upgrade_acquired.emit(upgrade)
			Globals.UpgradeType.ATTACK:
				SignalBus.attack_upgrade_acquired.emit(upgrade)
			Globals.UpgradeType.SNAILJUICE:
				SignalBus.snail_juice_upgrade_acquired.emit(upgrade)
			Globals.UpgradeType.UPGRADE:
				SignalBus.upgrade_upgrade_acquired.emit(upgrade)

func get_upgrades() -> Array[UpgradeResource]:
	var temp_collection = available_upgrades.keys()
	var selected: Array[UpgradeResource] = []
	for i in num_upgrade_choices:
		var item = temp_collection.pick_random()
		selected.append(available_upgrades[item])
		temp_collection.erase(item)
	return selected

#func apply_player_upgrade(upgrade: PlayerUpgradeResource):
	#player.experience_box_mult += upgrade.experience_box_mult
	#player.experience_box.scale.x = 1 + upgrade.experience_box_mult
	#player.experience_box.scale.y = 1 + upgrade.experience_box_mult
	#
	#player.speed += upgrade.speed
	#player.speed_mult += upgrade.speed_mult
	#player.speed = player.speed * (1 + player.speed_mult)
	#
	#player.max_hp += upgrade.max_hp
	#
func _on_upgrade_upgrade_acquired(upgrade: UpgradeResource):
	num_upgrade_choices += upgrade.num_upgrade_choices
