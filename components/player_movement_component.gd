extends Node2D

var speed: float = 150.0

func _physics_process(delta: float) -> void:
	if Global.current_game_mode == Global.GameMode.WORLD:
		var direction = _get_input_direction()
		get_parent().velocity = direction * speed
		
		Global.player_is_moving = direction.x != 0 or direction.y != 0
		
		match direction:
			Vector2.UP: 
				get_parent().animated_sprite_2d.play("move_up")
			Vector2.LEFT:
				get_parent().animated_sprite_2d.flip_h = true
				get_parent().animated_sprite_2d.play("move_side")
			Vector2.RIGHT: 
				get_parent().animated_sprite_2d.flip_h = false 
				get_parent().animated_sprite_2d.play("move_side")
			Vector2.DOWN:
				get_parent().animated_sprite_2d.play("move_down")
			_:
				get_parent().animated_sprite_2d.play("idle")

		get_parent().move_and_slide()

func _get_input_direction() -> Vector2:
	var direction = Vector2.ZERO
	direction.y -= Input.get_action_strength("move_up")
	direction.y += Input.get_action_strength("move_down")
	direction.x -= Input.get_action_strength("move_left")
	direction.x += Input.get_action_strength("move_rigth")
	return direction.normalized()
