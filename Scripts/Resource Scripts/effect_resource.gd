extends Resource
class_name EffectResource

@export var type: String

@export var amount: float
@export var amount_mult: float
@export var duration: float
@export var duration_mult: float

static func create_empty():
	return EffectResource.new()

func initialize(type: String, amount: float, amount_mult: float, duration: float, duration_mult: float):
	self.type = type
	self.amount = amount
	self.amount_mult = amount_mult
	self.duration = duration
	self.duration_mult = duration_mult
