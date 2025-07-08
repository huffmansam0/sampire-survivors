extends "res://Scripts/enemy.gd"

@onready var hp_bar = $HealthBar

func _ready():
	max_hp = 1000
	hp_bar.max_value = max_hp
	hp_bar.min_value = 0
	hp_bar.value = current_hp
	super._ready()

func take_damage(amount: int):
	super.take_damage(amount)
	hp_bar.value = current_hp
