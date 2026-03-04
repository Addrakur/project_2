extends Area2D

@export var screen_manager: ScreenManager

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		screen_manager.player_die()
