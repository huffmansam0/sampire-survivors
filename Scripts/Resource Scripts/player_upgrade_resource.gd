extends UpgradeResource
class_name PlayerUpgradeResource

@export var speed: float
@export var speed_mult: float
@export var max_hp: int
@export var experience_box_mult: float

func apply():
	UpgradeManager.apply_player_upgrade(self)
