extends Node2D

@onready var area_2d: Area2D = $Area2D
@onready var player: BaseCharacter = $Player
@onready var menu_panel: Panel = $HUD/MenuPanel

var CHANCE_OF_ENCOUNTER: float = 0.005
var is_in_monster_area: bool = false

func _ready() -> void:
	Global.current_game_mode = Global.GameMode.WORLD
	
	# TODO: Talvez possa criar bugs no futuro
	if Global.player_position != Vector2.ZERO:
		player.global_position = Global.player_position
		
func _process(delta: float) -> void:
	if _should_encounter_monster():
		Global.player_position = player.global_position
		get_tree().change_scene_to_file("res://scenes/battle/battle.tscn")
		
	if Input.is_action_just_pressed("open_menu"):
		menu_panel.visible = !menu_panel.visible
		
	get_tree().paused = menu_panel.visible

func _on_monster_area_entered(body: Node2D) -> void:
	is_in_monster_area = true

func _on_monster_area_exited(body: Node2D) -> void:
	is_in_monster_area = false

func _should_encounter_monster() -> bool:
	return Global.player_is_moving and is_in_monster_area and randf() < CHANCE_OF_ENCOUNTER
