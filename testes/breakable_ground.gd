class_name BreakableGround
extends StaticBody2D

@export var max_speed: float
var player_speed: float
@onready var break_time: Timer = $break_time

func _on_area_2d_body_entered(body: Node2D) -> void:
	player_speed = body.velocity.y
	print(player_speed)
	if player_speed > max_speed:
		break_time.start()

func _on_break_time_timeout() -> void:
	queue_free()
