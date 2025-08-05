extends BaseCharacter
class_name Player

signal has_gained_level(old_level: int, old_health: int, old_attack: int, old_defense: int)

const experience_per_level = {
	1:0,
	2:500,
	3:1500,
	4:3000,
	5:6000
}

func gain_experience(experience: int) -> void:
	stats.experience += experience
	
	if _has_experience_to_level_up():
		_level_up()

func _level_up() -> void:
	var old_level = stats.level
	var old_health = stats.health
	var old_attack = stats.attack
	var old_defense = stats.defense
	
	stats.level += 1
	stats.health += 5
	stats.attack += 2
	stats.defense += 1
	
	health_component.set_current_health(stats.health)
	
	has_gained_level.emit(old_level, old_health, old_attack, old_defense)

func _has_experience_to_level_up() -> bool:
	var next_level = stats.level + 1;
	
	if experience_per_level.has(next_level):
		return stats.experience >= experience_per_level[next_level];
	else:
		return false

func get_experience_to_next_level() -> int:
	var next_level = stats.level + 1;
	
	if experience_per_level.has(next_level):
		return experience_per_level[next_level] - stats.experience;
	else:
		return 0
