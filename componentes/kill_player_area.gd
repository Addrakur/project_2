extends Area2D

@export var screen_manager: ScreenManager

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.velocity = Vector2.ZERO
		body.position = screen_manager.current_checkpoint.position
		body.fuel = body.max_fuel
