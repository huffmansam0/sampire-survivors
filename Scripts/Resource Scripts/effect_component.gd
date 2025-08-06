extends Resource
class_name EffectComponent

@export var type: Globals.EffectType

@export var amount: float
@export var amount_mult: float
@export var duration: float
@export var duration_mult: float

#TODO is this stuff needed?
static func create_empty():
	return EffectComponent.new()

func initialize(type: Globals.EffectType, amount: float, amount_mult: float, duration: float, duration_mult: float):
	self.type = type
	self.amount = amount
	self.amount_mult = amount_mult
	self.duration = duration
	self.duration_mult = duration_mult
