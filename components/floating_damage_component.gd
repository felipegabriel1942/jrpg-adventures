extends Node2D

@onready var label = $Label

func _ready():
	label.visible = false

func show_damage(damage: int, type = "damage") -> void:
	label.text = str(damage)

	var texture = get_parent().get_parent().animated_sprite_2d.sprite_frames.get_frame_texture("idle", 0)
	global_position =  get_parent().get_parent().global_position + Vector2(0, texture.get_size().y)
	
	label.visible = true
	
	if type == "heal":
		_change_text_color(Color(0, 1, 0))
	else:
		_change_text_color(Color(1, 1, 1))
	
	await get_tree().create_timer(2).timeout
	
	label.visible = false

func _change_text_color(color):
	var settings = LabelSettings.new()
	settings.font_color = color
	settings.font_size = 10
	label.label_settings = settings
