extends Node
class_name EnemyAttackTimers

#	Key: int - id of enemy being tracked
#	Value: Timer - Timer triggering the effect on the tracked enemy
var dict: Dictionary[int, Timer]
