extends Node

enum UpgradeTypes {
	ATTACK,
	PLAYER,
	SNAILJUICE,
	LOVEDART,
	FIRE,
	EXPERIENCE,
	UPGRADE,
	PSIONICSNAIL,
	DEFENSE,
	ONKILL,
}

enum EffectTypes {
	DAMAGE,
	SLOW,
	BURN,
}

enum AttackTypes {
	SNAILJUICE,
}

#README: Layers Reference
var layers: Dictionary[String, int] = {
	"Enemy Hurtbox": 2
}

#README: Masks Reference
var masks: Dictionary[String, int] = {
	"": 1
}
