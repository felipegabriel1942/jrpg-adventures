extends Node2D
class_name BaseCharacter

signal selected(char)

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
@onready var selection_indicator = $SelectionIndicator

@export var character_name: String
@export var stats: Stats
@export var health_component: HealthComponent

var is_selected: bool
var can_select: bool

func _on_died():
	is_selected = false
	can_select = false
	animated_sprite_2d.play("death")
	
func _physics_process(delta):
	selection_indicator.visible = is_selected
	
	if is_selected:
		animation_player.play("pointer")

func _animation_finished():
	if animated_sprite_2d.animation == "death":
		if name != "Player":
			visible = false
	else:
		animated_sprite_2d.play("idle")

func _on_hurt():
	animation_player.play("damaged")

func _on_area_2d_input_event(viewport, event, shape_idx):	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if can_select:
			is_selected = !is_selected
			selected.emit(self)
