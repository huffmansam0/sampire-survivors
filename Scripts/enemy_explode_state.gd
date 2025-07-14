extends State
class_name EnemyExplodeState

@export var enemy: CharacterBody2D
#could expose editor vars here like: explosion radius, explosion animation/sprite(s), etc. but skipping for now

func Enter():
	enemy.explode()
