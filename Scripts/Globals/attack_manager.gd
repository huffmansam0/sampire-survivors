extends Node

var player: Player
var attack_container: Node2D

#register new attack scenes here for instantiation
var snail_juice_scene: PackedScene = preload("res://Scenes/Snail_Juice.tscn")

#update mapping for attack scenes here
var attack_scene_mapping: Dictionary[Globals.AttackTypes, PackedScene] = {
	Globals.AttackTypes.SNAILJUICE: snail_juice_scene,
}

#Key - attack type
#Value - reference to the blueprint for the attack
var active_attacks: Dictionary[Globals.AttackTypes, Attack] = {}

#Key - attack type
#Value - reference to the interval timer for the attack
var active_attack_interval_timers: Dictionary[Globals.AttackTypes, Timer] = {}

var attack_despawn_timers: Dictionary[int, Timer] = {}

#Outer:
#	Key: string - attack type being tracked
#	Value: dictionary - enemies currently in the attack
#Inner:
#	Key: int - id of enemy
#	Value: # of instances of the attack that enemy is currently in
var enemies_in_attacks: Dictionary[Globals.AttackTypes, EnemiesInAttack] = {}

#Outer:
#	Key: string - attack type being tracked
#	Value: dictionary - dictionary of timers triggering attack's effects on each affected enemy
#Inner:
#	Key: int - id of enemy
#	Value: timer triggering attack's effects on affected enemy
var enemy_attack_timers: Dictionary[Globals.AttackTypes, EnemyAttackTimers] = {}

func _ready() -> void:
	attack_container = Node2D.new()
	attack_container.name = "AttackContainer"
	add_child(attack_container)
	
	SignalBus.game_started.connect(_start_game)
	SignalBus.game_ended.connect(_end_game)
	
	SignalBus.attack_upgrade_acquired.connect(_on_attack_upgrade_acquired)
	
func _end_game():
	get_tree().call_group("Attacks", "free")
	
	for child in attack_container.get_children():
		child.queue_free()
	
	for attack in active_attacks.values():
		attack.queue_free()
	active_attacks.clear()
	
	for timer in active_attack_interval_timers.values():
		timer.queue_free()
	active_attack_interval_timers.clear()
	
	for timer in attack_despawn_timers.values():
		timer.queue_free()
	attack_despawn_timers.clear()
	
	enemies_in_attacks.clear()
	
	for timer in enemy_attack_timers.values():
		timer.queue_free()
	enemy_attack_timers.clear()
	
func _start_game():
	player = GameManager.get_player()
	var snail_juice_attack = SnailJuiceAttack.get_base()
	add_attack(snail_juice_attack)

func _on_attack_upgrade_acquired(upgrade: UpgradeResource):
	for component in upgrade.components:
		if component.type == Globals.UpgradeTypes.ATTACK:
			var attack_component: AttackUpgradeComponent = component
			if active_attacks.has(attack_component.attack_type):
				var attack_blueprint = active_attacks[attack_component.attack_type]
				
				#update all properties
				attack_blueprint.interval += attack_component.interval
				attack_blueprint.interval_mult += attack_component.interval_mult
				attack_blueprint.duration += attack_component.duration
				attack_blueprint.duration_mult += attack_component.duration_mult
				attack_blueprint.tick_rate += attack_component.tick_rate
				attack_blueprint.tick_rate_mult += attack_component.tick_rate_mult
				attack_blueprint.position_offset += attack_component.position_offset
				attack_blueprint.size += attack_component.size
				attack_blueprint.size_mult += attack_component.size_mult
				
				#update all effects
				for effect in attack_component.effects:
					var attack_blueprint_effect: EffectComponent = attack_blueprint.effects[effect.type]
					attack_blueprint_effect.amount += effect.amount
					attack_blueprint_effect.amount_mult += effect.amount_mult
					attack_blueprint_effect.duration += effect.duration
					attack_blueprint_effect.duration_mult += effect.duration_mult
				
				#update interval timer
				active_attack_interval_timers[attack_component.attack_type].wait_time = attack_blueprint.interval * (1 + attack_blueprint.interval_mult)
			else:
				#BETA: here's where we'd add new attacks. get their base and add it I imagine
				pass
	
func add_attack(attack: Attack):
	active_attacks[attack.type] = attack
	
	var interval_timer: Timer = active_attack_interval_timers.get_or_add(attack.type, Timer.new())

	interval_timer.wait_time = attack.interval
	interval_timer.one_shot = false
	interval_timer.autostart = false
	add_child(interval_timer)
	interval_timer.timeout.connect(spawn_attack.bind(attack.type))
	interval_timer.start()

func spawn_attack(attack_type: Globals.AttackTypes):
	var attack = active_attacks[attack_type]
	
	#spawn the attack
	var attack_instance: SnailJuiceAttackInstance = attack_scene_mapping[attack.type].instantiate()
	attack_instance.setup(attack)
	
	##set the timer to delete it
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
	attack_instance.global_position = player.global_position + attack.position_offset
	attack_container.add_child(attack_instance)
	
func enemy_entered_attack(enemy: Enemy, attack_type: Globals.AttackTypes):
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

func _attack_enemy(attack_type: Globals.AttackTypes, enemy: Enemy):
	var attack = active_attacks[attack_type]
	
	if is_instance_valid(enemy):
		#Register new effects here
		for effect in attack.effects.values():
			match effect.type:
				Globals.EffectTypes.DAMAGE:
					enemy.take_damage(effect.amount * (1 + effect.amount_mult))

func enemy_exited_attack(enemy: Enemy, attack_type: Globals.AttackTypes):
	var enemyId = enemy.get_instance_id()
	var enemies_in_attack: EnemiesInAttack = enemies_in_attacks.get_or_add(attack_type, EnemiesInAttack.new())
	
	if !enemies_in_attack.dict.has(enemyId):
		return
	
	enemies_in_attack.dict[enemyId] -= 1
	if enemies_in_attack.dict[enemyId] <= 0:
		_remove_enemy(enemyId, attack_type)
	
func _remove_enemy(enemyId: int, attack_type: Globals.AttackTypes):
	var enemies_in_attack = enemies_in_attacks.get_or_add(attack_type, EnemiesInAttack.new())
	var attack_timers = enemy_attack_timers.get_or_add(attack_type, EnemyAttackTimers.new())
	
	enemies_in_attack.dict.erase(enemyId)
	attack_timers.dict[enemyId].queue_free()
	attack_timers.dict.erase(enemyId)
