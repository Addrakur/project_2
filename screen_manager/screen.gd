class_name Screen
extends Node2D

@export var camera: PhantomCamera2D
@export var default_checkpoint: Marker2D
@export var moving_plats: Array[AnimationPlayer]

var active: bool = false

func activate():
	active = true
	camera.priority = 1
	for plat in moving_plats:
		plat.play("1")

func deactivate():
	active = false
	camera.priority = 0
	for plat in moving_plats:
		plat.stop()
