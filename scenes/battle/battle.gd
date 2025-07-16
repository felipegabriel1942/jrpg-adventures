extends Node2D

@onready var player = $Player
@onready var battle_log = $HUD/BattleLogPanel/Label
@onready var attack_button = $HUD/BattlePanel/PanelsContainer/ActionsPanel/VBoxContainer/AttackButton
@onready var item_button = $HUD/BattlePanel/PanelsContainer/ActionsPanel/VBoxContainer/ItemButton
@onready var player_life_label = $HUD/BattlePanel/PanelsContainer/PlayerPanel/VBoxContainer/PlayerLifeLabel
@onready var itens_panel = $HUD/BattlePanel/PanelsContainer/ItensPanel
@onready var actions_panel = $HUD/BattlePanel/PanelsContainer/ActionsPanel
@onready var itens_container = $HUD/BattlePanel/PanelsContainer/ItensPanel/VBoxContainer2/ItensContainer
@onready var enemies_positions: Node2D = $EnemiesPositions

var slime = preload("res://characters/slime/slime.tscn")

const WAIT_TIME_AFTER_ATTACK := 2.0

enum BattleState {
	IDLE,
	PLAYER_ACTION,
	ENEMY_ACTION,
	END
}

enum PlayerAction {
	ATTACK,
	ITEM
}

var state: BattleState
var player_action: PlayerAction
var selected_item: ItemResource
var enemies: Array[BaseCharacter] = []
var selected_enemy: BaseCharacter

func _ready():
	randomize()
	Global.current_game_mode = Global.GameMode.BATTLE
	state = BattleState.IDLE
	_generate_enemies()

func _physics_process(delta):
	_update_actions_disabled_status()
	_update_battle_log()
	_update_player_life_label()
	
func _generate_enemies() -> void:
	var number_of_enemies = randi_range(1, 3)
	
	var positions = enemies_positions.get_children()
	
	for i in range(number_of_enemies):
		var enemy = slime.instantiate();
		enemies.append(enemy)
		enemy.selected.connect(Callable(self, "_on_enemy_selected"))
		enemy.position = positions[i].position
		add_child(enemy)

func _on_attack_button_down() -> void:
	player_action = PlayerAction.ATTACK
	
	for enemy in enemies:
		enemy.can_select = true
		
	var first = enemies.filter(func(enemy): return enemy.visible).front()
	
	first.is_selected = true

func _on_item_button_down() -> void:
	itens_panel.visible = true
	actions_panel.visible = false
	
	for enemy in enemies:
		enemy.can_select = false
		enemy.is_selected = false
	
	for child in itens_container.get_children():
		child.queue_free()
	
	for item_id in PlayerInventory.get_all_items():
		var item = ItemDatabase.itens.get(item_id) as ItemResource
		var quantity = PlayerInventory.get_quantity(item_id)
		
		var button = Button.new()
		button.text = item.name
		
		var label = Label.new()
		label.text = str(quantity)
		
		var hbox = HBoxContainer.new()
		
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.alignment = 0
		button.flat = true
		button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		button.button_down.connect(_on_item_selected.bind(item))
		
		hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		hbox.add_child(button)
		hbox.add_child(label)

		itens_container.add_child(hbox)

func _on_item_selected(item: ItemResource) -> void:
	player_action = PlayerAction.ITEM
		
	selected_item = item
	
	var effect_type = item.effect_type
	var target_scope = item.target_scope
	
	match effect_type:
		ItemResource.EffectType.DAMAGE:
			player.can_select = false
			player.is_selected = false
			
			match target_scope:
				ItemResource.TargetScope.SINGLE:
					for enemy in enemies:
						enemy.is_selected = false
						enemy.can_select = true
					
					var first = enemies.filter(func(enemy): return enemy.visible).front()
					
					first.is_selected = true
				
				ItemResource.TargetScope.MULTIPLE:
					for enemy in enemies:
						enemy.can_select = true
						enemy.is_selected = true

		ItemResource.EffectType.HEAL: 
			player.can_select = true
			player.is_selected = true

			for enemy in enemies:
				enemy.can_select = false
				enemy.is_selected = false

func _execute_turn() -> void:
	player.can_select = false
	
	for enemy in enemies:
		enemy.can_select = false
	
	itens_panel.visible = false
	actions_panel.visible = true
	
	if player.health_component.is_alive():
		state = BattleState.PLAYER_ACTION
		
		match player_action:
			PlayerAction.ITEM: _use_item()
			PlayerAction.ATTACK: _attack(player, selected_enemy)
			
		await get_tree().create_timer(WAIT_TIME_AFTER_ATTACK).timeout
	
	for enemy in enemies:
		if enemy.health_component.is_alive():
			state = BattleState.ENEMY_ACTION
			_attack(enemy, player)
			await get_tree().create_timer(WAIT_TIME_AFTER_ATTACK).timeout

	var is_enemies_alive = _are_enemies_alive()

	if !is_enemies_alive or !player.health_component.is_alive():
		state = BattleState.END
		
		if !is_enemies_alive:
			get_tree().change_scene_to_file("res://scenes/world/world.tscn")
	else:
		state = BattleState.IDLE

	selected_enemy = null
	selected_item = null

func _calculate_damage(attack: int, defense: int) -> int:
	var base_damage = attack * (100.0 / (100 + defense))
	var variance = randf_range(0.85, 1.15)
	var final_damage = int(base_damage * variance)
	return max(final_damage, 1)

func _attack(attacker: BaseCharacter, defensor: BaseCharacter) -> void:
	if not attacker.health_component.is_alive() or not defensor.health_component.is_alive():
		return
	
	attacker.animated_sprite_2d.play("attack")
	var damage = _calculate_damage(attacker.stats.attack, defensor.stats.defense)
	battle_log.text = attacker.name + " causou " + str(damage) + " de dano ao " + defensor.name
	defensor.health_component.take_damage(damage)

func _update_player_life_label() -> void:
	player_life_label.text = "Player " + "%02d" % player.health_component.get_current_health() + "/" + "%02d" % player.stats.health

func _update_battle_log() -> void:
	var is_enemies_alive = _are_enemies_alive()
	
	if !is_enemies_alive and player.health_component.is_alive():
		battle_log.text = "Inimigos derrotados!"
	elif is_enemies_alive and !player.health_component.is_alive():
		battle_log.text = "Fim de Jogo"
	elif is_enemies_alive and player.health_component.is_alive() and state == BattleState.IDLE:
		battle_log.text = "O que deseja fazer?"

func _are_enemies_alive() -> bool:
	var is_enemies_alive = false
	
	for enemy in enemies:
		if enemy.health_component.is_alive():
			is_enemies_alive = true
			
	return is_enemies_alive

func _update_actions_disabled_status() -> void:
	var disabled = state == BattleState.PLAYER_ACTION or state == BattleState.ENEMY_ACTION
	
	attack_button.disabled = disabled
	item_button.disabled = disabled

func _on_item_back_button_down() -> void:
	itens_panel.visible = false
	actions_panel.visible = true
	player.is_selected = false
	
	for enemy in enemies:
		enemy.is_selected = false

func _use_item() -> void:
	match selected_item.effect_type:
		ItemResource.EffectType.HEAL: selected_item.use([player])
		ItemResource.EffectType.DAMAGE:
			match selected_item.target_scope:
				ItemResource.TargetScope.SINGLE: selected_item.use([selected_enemy])
				ItemResource.TargetScope.MULTIPLE: selected_item.use(enemies)

func _on_enemy_selected(selected_enemy: BaseCharacter):
	self.selected_enemy = selected_enemy
	
	for enemy in enemies:
		if enemy != selected_enemy:
			enemy.is_selected = false
	
	if !selected_enemy.is_selected:
		_execute_turn()

func _on_player_selected(player: BaseCharacter):
	if !player.is_selected:
		_execute_turn()
