extends Node

var upgrades: Dictionary[String, UpgradeResource] = {}
var upgrade_paths: Dictionary[String, String] = {
	"slime_preservatives": "res://Upgrades/slime_preservatives.tres",
	"acidic_slime": "res://Upgrades/acidic_slime.tres",
	"abundant_secretions": "res://Upgrades/abundant_secretions.tres",
	"juice_lubricant": "res://Upgrades/juice_lubricant.tres",
}

@onready var player: Player = GameManager.get_player()

@export var upgrades_array = []

func _ready():
	_load_upgrades()
	
func _load_upgrades():
	for upgrade_name in upgrade_paths:
		var path = upgrade_paths[upgrade_name]
		var resource = load(path)
		upgrades[upgrade_name] = resource

func upgrade_acquired(upgrade: UpgradeResource):
	upgrade.apply()

func get_upgrades() -> Array[UpgradeResource]:
	var temp_collection = upgrades.keys()
	var selected: Array[UpgradeResource] = []
	for i in 3:
		var item = temp_collection.pick_random()
		selected.append(upgrades[item])
		temp_collection.erase(item)
	return selected

func apply_player_upgrade(upgrade: PlayerUpgradeResource):
	player.experience_box_mult += upgrade.experience_box_mult
	player.experience_box.scale.x = 1 + upgrade.experience_box_mult
	player.experience_box.scale.y = 1 + upgrade.experience_box_mult
	
	player.speed += upgrade.speed
	player.speed_mult += upgrade.speed_mult
	player.speed = player.speed * (1 + player.speed_mult)
	
	player.max_hp += upgrade.max_hp
	
