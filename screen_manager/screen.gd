class_name Screen
extends Node2D

@export var camera: PhantomCamera2D
@export var default_checkpoint: Marker2D
@export var moving_objs_animation: Array[AnimationPlayer]
@export var doors: Array[DoorManager]

var active: bool = false

func activate():
	var screen_manager: ScreenManager = get_parent()
	active = true
	camera.priority = 1
	screen_manager.current_screen = float(name.erase(0,7))
	for item in moving_objs_animation:
		item.play("1")

func deactivate():
	active = false
	camera.priority = 0
	for item in moving_objs_animation:
		item.stop()
