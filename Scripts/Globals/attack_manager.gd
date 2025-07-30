extends Node

@onready var player: Player = GameManager.get_player()

#register new attack scenes here for instantiation
var snail_juice_scene: PackedScene = preload("res://Scenes/Snail_Juice.tscn")

#update mapping for attack scenes here
var attack_scene_mapping: Dictionary[String, PackedScene] = {
	"snail_juice": snail_juice_scene,
}

var active_attacks: Dictionary[String, Attack] = {}
var active_attack_interval_timers: Dictionary[String, Timer] = {}
var attack_despawn_timers: Dictionary[int, Timer] = {}

#Outer:
#	Key: string - attack type being tracked
#	Value: dictionary - enemies currently in the attack
#Inner:
#	Key: int - id of enemy
#	Value: # of instances of the attack that enemy is currently in
var enemies_in_attacks: Dictionary[String, EnemiesInAttack] = {}

#Outer:
#	Key: string - attack type being tracked
#	Value: dictionary - dictionary of timers triggering attack's effects on each affected enemy
#Inner:
#	Key: int - id of enemy
#	Value: timer triggering attack's effects on affected enemy
var enemy_attack_timers: Dictionary[String, EnemyAttackTimers] = {}

func _ready() -> void:
	#add your starting attack!
	var snail_juice_attack = SnailJuiceAttack.new()
	add_attack(snail_juice_attack)

func add_attack(attack: Attack):
	active_attacks[attack.type] = attack
	
	var interval_timer = active_attack_interval_timers.get_or_add(attack.type, Timer.new())

	interval_timer.wait_time = attack.interval
	interval_timer.one_shot = false
	interval_timer.autostart = false
	add_child(interval_timer)
	interval_timer.timeout.connect(spawn_attack.bind(attack))
	interval_timer.start()

func update_attack(new_attack: Attack):
	var attack: Attack = active_attacks[new_attack.type]
	
	update_effects(attack.effects, new_attack.effects)
	var properties = new_attack.get_script().get_script_property_list()

	for property in properties:
		var prop_name = property.name

		#register non-additive properties here
		if prop_name.ends_with(".gd") or prop_name in [
			"type",
			"effects",
		]:
			continue

		var new_value = new_attack.get(prop_name)
		var current_value = attack.get(prop_name)
		attack.set(prop_name, (current_value if current_value != null else 0.0) + (new_value if new_value != null else 0))

	active_attacks[new_attack.type] = attack
	
	#update interval timer
	active_attack_interval_timers[attack.type].wait_time = attack.interval * (1 + attack.interval_mult)

func update_effects(current_effects: Dictionary[String, EffectResource], new_effects: Dictionary[String, EffectResource]):
	for effect: EffectResource in new_effects.values():
		var current_effect: EffectResource = current_effects.get(effect.type, EffectResource.create_empty())
		current_effect.type = effect.type
		
		var properties = effect.get_script().get_script_property_list()
		
		for property in properties:
			var prop_name = property.name
			
			#register non-additive properties here
			if prop_name.ends_with(".gd") or prop_name in [
				"type",
			]:
				continue
				
			var new_value = effect.get(prop_name)
			var current_value = current_effect.get(prop_name)
			current_effect.set(prop_name, (current_value if current_value != null else 0.0) + (new_value if new_value != null else 0))
			
		current_effects[effect.type] = current_effect

func spawn_attack(attack: Attack):
	#spawn the attack
	var attack_instance = attack_scene_mapping[attack.type].instantiate()
	attack_instance.global_position = player.global_position
	attack.apply_upgrade(attack_instance)
	
	#set the timer to delete it
	var despawn_timer = Timer.new()
	var despawn_timer_id = despawn_timer.get_instance_id()
	
	despawn_timer.wait_time = attack.duration * (1 + attack.duration_mult)
	despawn_timer.one_shot = true
	despawn_timer.autostart = false
	add_child(despawn_timer)
	
	attack_despawn_timers[despawn_timer_id] = despawn_timer
	
	despawn_timer.timeout.connect(func():
		attack_instance.queue_free()
		attack_despawn_timers.erase(despawn_timer_id)
	)
	
	despawn_timer.start()
	
	#add child
	get_tree().current_scene.add_child(attack_instance)

func spawn_puddle(position: Vector2):
	var slime = snail_juice_scene.instantiate()
	slime.global_position = position
	get_tree().current_scene.add_child(slime)
	
func enemy_entered_attack(enemy: Enemy, attack_type: String):
	var enemyId = enemy.get_instance_id()
	var enemies_in_attack = enemies_in_attacks.get_or_add(attack_type, EnemiesInAttack.new())
	var attack_timers = enemy_attack_timers.get_or_add(attack_type, EnemyAttackTimers.new())
	var enemyEntry = enemies_in_attack.dict.get_or_add(enemyId, 0)
	var attack = active_attacks[attack_type]
	enemies_in_attack.dict[enemyId] += 1
	
	if enemies_in_attack.dict[enemyId] == 1:
		#set up attack timer(s)
		var attack_timer = Timer.new()
		var tick_rate_mult = attack.tick_rate_mult if attack.tick_rate_mult > 0 else 1
		attack_timer.wait_time = attack.tick_rate * tick_rate_mult
		attack_timer.timeout.connect(_attack_enemy.bind(attack_type, enemy))
		attack_timer.autostart = true
		add_child(attack_timer)
		attack_timers.dict[enemyId] = attack_timer

func _attack_enemy(attack_type: String, enemy: Enemy):
	var attack = active_attacks[attack_type]
	
	if is_instance_valid(enemy):
		#Register new effects here
		for effect in attack.effects.values():
			match effect.type:
				"damage":
					enemy.take_damage(effect.amount * (1 + effect.amount_mult))

func enemy_exited_attack(enemy: Enemy, attack_type: String):
	var enemyId = enemy.get_instance_id()
	var enemies_in_attack = enemies_in_attacks.get_or_add(attack_type, EnemiesInAttack.new())
	
	enemies_in_attack.dict[enemyId] -= 1
	if enemies_in_attack.dict[enemyId] <= 0:
		_remove_enemy(enemyId, attack_type)
	
func _remove_enemy(enemyId: int, attack_type: String):
	var enemies_in_attack = enemies_in_attacks.get_or_add(attack_type, EnemiesInAttack.new())
	var attack_timers = enemy_attack_timers.get_or_add(attack_type, EnemyAttackTimers.new())
	
	enemies_in_attack.dict.erase(enemyId)
	attack_timers.dict[enemyId].queue_free()
	attack_timers.dict.erase(enemyId)
