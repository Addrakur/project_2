extends Area2D

@export var screen_manager: ScreenManager

func _on_body_entered(body: Node2D) -> void:
	body.position = screen_manager.current_checkpoint.position
