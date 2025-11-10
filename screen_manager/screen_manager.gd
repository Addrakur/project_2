class_name ScreenManager
extends Node2D

@export var player: Player
@export var screens: Array[Screen]
@export var current_checkpoint: Marker2D

var starting_screen: float

func _ready() -> void:
	if starting_screen != null:
		starting_screen = 0
