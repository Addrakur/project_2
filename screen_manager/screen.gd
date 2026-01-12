class_name Screen
extends Node2D

@export var camera: PhantomCamera2D
@export var default_checkpoint: Marker2D

var active: bool = false

func activate():
	active = true
	camera.priority = 1

func deactivate():
	active = false
	camera.priority = 0
