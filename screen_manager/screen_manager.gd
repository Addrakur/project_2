class_name ScreenManager
extends Node2D

@export var player: Player
@export var screens: Array[Screen]
@export var current_checkpoint: Marker2D

var starting_screen: float = 0

func _ready() -> void:
	if starting_screen == null:
		starting_screen = 0
	screens[screens.find(screens[starting_screen])].camera.priority = 2
	current_checkpoint = screens[screens.find(screens[starting_screen])].default_checkpoint
	player.position = current_checkpoint.position
