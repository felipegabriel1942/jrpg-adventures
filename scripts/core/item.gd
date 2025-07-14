extends Resource
class_name Item

enum EffectType { HEAL, DAMAGE }
enum TargetScope { SINGLE, MULTIPLE }

var id: String
var name: String
var points: int
var effect_type: EffectType
var target_scope: TargetScope

func _init(_id: String, _name: String, _points: int, _effect_type: EffectType, _target_scope: TargetScope) -> void:
	self.id = _id
	self.name = _name
	self.points = _points
	self.effect_type = _effect_type
	self.target_scope = _target_scope

func use(targets: Array) -> void:
	pass
