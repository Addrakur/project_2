extends Area2D

@export var gravity_mult: float

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.gravity_mult = gravity_mult

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		body.gravity_mult = -gravity_mult
