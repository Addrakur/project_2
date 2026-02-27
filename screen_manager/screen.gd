class_name Screen
extends Node2D

@export var camera: PhantomCamera2D
@export var default_checkpoint: Marker2D
@export var moving_objs_animation: Array[AnimationPlayer]

var active: bool = false

func activate():
	active = true
	camera.priority = 1
	for item in moving_objs_animation:
		item.play("1")

func deactivate():
	active = false
	camera.priority = 0
	for item in moving_objs_animation:
		item.stop()
