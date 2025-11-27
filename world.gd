class_name World
extends Node2D

@export var player: Player
@export var gravity: float

func _ready() -> void:
	player.gravity = gravity
