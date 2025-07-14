extends Resource
class_name ItemResource

enum EffectType { HEAL, DAMAGE }
enum TargetScope { SINGLE, MULTIPLE }

@export var id: String
@export var name: String
@export var points: int
@export var effect_type: EffectType
@export var target_scope: TargetScope

func use(targets: Array[BaseCharacter] = []) -> void:
	pass
