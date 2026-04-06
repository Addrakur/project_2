class_name Screen
extends Node2D

@export var camera: PhantomCamera2D
@export var default_checkpoint: Marker2D
@export var moving_objs_animation: Array[AnimationPlayer]
@export var doors: Array[DoorManager]
var all_animation_players: Array[AnimationPlayer]

var active: bool = false
var number: float

func _ready() -> void:
	number = float(name.erase(0,7))
	var children = get_children()
	for child in children:
		if child is AnimationPlayer:
			all_animation_players.append(child)

func activate():
	var screen_manager: ScreenManager = get_parent()
	active = true
	camera.priority = 1
	screen_manager.current_screen = number
	for item in moving_objs_animation:
		item.play("1")
	print(number)

func deactivate():
	active = false
	camera.priority = 0
	for item in moving_objs_animation:
		item.stop()
