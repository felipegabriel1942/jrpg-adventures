extends Control

@onready var player: Player = $"../../Player"
@onready var player_health_label: Label = $HBoxContainer/MenuContentPanel/PlayerHealthLabel
@onready var player_level_label: Label = $HBoxContainer/MenuContentPanel/PlayerLevelLabel
@onready var player_next_level_label: Label = $HBoxContainer/MenuContentPanel/PlayerNextLevelLabel
@onready var player_attack_label: Label = $HBoxContainer/MenuContentPanel/PlayerAttackLabel
@onready var player_defense_label: Label = $HBoxContainer/MenuContentPanel/PlayerDefenseLabel

func _ready() -> void:
	_update_labels_values()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("open_menu"):
		_update_labels_values()
		
		await get_tree().create_timer(0.1).timeout
		get_tree().paused = false
		visible = false

func _update_labels_values() -> void:
	_set_health_label_value()
	_set_level_label_value()
	_set_next_level_label_value()
	_set_attack_label_value()
	_set_defense_label_value()
	
func _set_health_label_value() -> void:
	player_health_label.text = "PV " + "%02d" % player.health_component.get_current_health() + "/" + "%02d" % player.stats.health

func _set_level_label_value() -> void:
	player_level_label.text = "NVL " + "%01d" % player.stats.level

func _set_next_level_label_value() -> void:
	player_next_level_label.text = "Próximo " + str(player.get_experience_to_next_level())

func _set_attack_label_value() -> void:
	player_attack_label.text = "Ataque " + str(player.stats.attack)

func _set_defense_label_value() -> void:
	player_defense_label.text = "Defesa " + str(player.stats.defense)
