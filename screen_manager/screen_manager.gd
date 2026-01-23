class_name ScreenManager
extends Node2D

@export var player: Player
@export var screens: Array[Screen]
@export var current_checkpoint: Marker2D

var starting_screen_index: float = 16

func _ready() -> void:
	if starting_screen_index == null:
		starting_screen_index = 0
	var starting_screen: Screen = screens[screens.find(screens[starting_screen_index])]
	starting_screen.activate()
	for screen in screens:
		if screen != starting_screen:
			screen.deactivate()
		print(screen.name + ": " + str(screen.active))
	current_checkpoint = starting_screen.default_checkpoint
	player.position = current_checkpoint.position
