extends Node

enum GameMode {
	WORLD,
	BATTLE
}

var current_game_mode: GameMode 
var player_position: Vector2
var player_is_moving: bool = false
var enemies: Array[BaseCharacter] = []
var added_initial_inventory = false

func _ready() -> void:
	_add_initial_inventory()

func _add_initial_inventory() -> void:
	if !added_initial_inventory:
		PlayerInventory.add_item("potion", 2)
		PlayerInventory.add_item("granade", 1)
		PlayerInventory.add_item("throwing_knife", 1)
		added_initial_inventory = true
