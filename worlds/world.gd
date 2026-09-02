class_name World
extends Node2D

@export var player: Player
@export var map_limit: TileMapLayer

var gravity: float = 120

func _ready() -> void:
	player.gravity = gravity
	map_limit.visible = false
