extends Node

#Bus for global signals

signal scene_transition_requested(scene_path: String)
signal game_started
signal game_ended
signal victory
signal defeat
signal enemy_died(enemy: Enemy)
signal game_time_elapsed(seconds: int)

#upgrade acquired signals
signal attack_upgrade_acquired(upgrade: UpgradeResource)
signal snail_juice_upgrade_acquired(upgrade: UpgradeResource)
signal fire_upgrade_acquired(upgrade: UpgradeResource)
signal player_upgrade_acquired(upgrade: UpgradeResource)
signal upgrade_upgrade_acquired(upgrade: UpgradeResource)
signal experience_upgrade_acquired(upgrade: UpgradeResource)
