extends Area2D

@export var screen_manager: ScreenManager
@export var new_screen: Screen
@export var old_screen: Screen
@export var door_shape: Polygon2D
@export var checkpoint: Marker2D

@onready var collision: CollisionPolygon2D = $collision

func _ready() -> void:
	collision.polygon = door_shape.polygon

func _on_body_entered(_body: Node2D) -> void:
	if old_screen.active:
		old_screen.deactivate()
		new_screen.activate()
		screen_manager.current_checkpoint = checkpoint
		screen_manager.player.fuel = screen_manager.player.max_fuel
		
		for screen in screen_manager.screens:
			print(screen.name + ": " + str(screen.active))
