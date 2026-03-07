class_name ScreenManager
extends Node2D

@export var player: Player
@export var screens: Array[Screen]
@export var current_checkpoint: Marker2D

var starting_screen_index: float = 1
var current_screen: float

func _ready() -> void:
	if starting_screen_index == null:
		starting_screen_index = 0
	var starting_screen: Screen = screens[screens.find(screens[starting_screen_index])]
	starting_screen.activate()
	for screen in screens:
		if screen != starting_screen:
			screen.deactivate()
	current_checkpoint = starting_screen.default_checkpoint
	player.position = current_checkpoint.position

func player_die():
	player.velocity = Vector2.ZERO
	player.position = current_checkpoint.position
	player.fuel = player.max_fuel
	for item in screens[current_screen].all_animation_players:
		item.play("RESET")
	for door in screens[current_screen].doors:
		for item in door.interactables:
			item.interacted = false
			item.animation.play("RESET")
