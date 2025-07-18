extends Control


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("open_menu"):
		await get_tree().create_timer(0.1).timeout
		get_tree().paused = false
		visible = false
		
