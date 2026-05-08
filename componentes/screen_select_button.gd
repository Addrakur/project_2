extends Button

@export var screen_manager: ScreenManager
@export var new_screen: Screen
var old_screen: Screen

func _ready() -> void:
	pass

func _on_pressed() -> void:
	old_screen = screen_manager.screens[screen_manager.current_screen]
	if old_screen.active:
		old_screen.deactivate()
		new_screen.activate()
		screen_manager.current_checkpoint = new_screen.default_checkpoint
		screen_manager.player.fuel = screen_manager.player.max_fuel
		screen_manager.player.global_position = new_screen.default_checkpoint.global_position
