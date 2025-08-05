extends Node2D
class_name HealthComponent

signal died()
signal hurt()

@export var stats: Stats

@onready var floating_damage_component = $FloatingDamageComponent

var _current_health: int

func _exit_tree() -> void:
	if get_parent().name == "Player":
		Global.player_current_health = _current_health

func _ready():
	if get_parent().name == "Player":
		_current_health = Global.player_current_health
	else:
		_current_health = stats.health

func take_damage(damage: int):
	_current_health = _current_health - damage
	floating_damage_component.show_damage(damage)
	
	if (_current_health <= 0):
		_current_health = 0
		
		died.emit()
	else:
		hurt.emit()

func heal(amount: int):
	_current_health = _current_health + amount
	floating_damage_component.show_damage(amount, "heal")
	if _current_health > stats.health:
		_current_health = stats.health

func get_current_health():
	return _current_health

func is_alive():
	return _current_health > 0

func set_current_health(current_health: int) -> void:
	_current_health = current_health
