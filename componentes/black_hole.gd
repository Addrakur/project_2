extends Area2D

@export var pull_force: float

var player_inside_area: bool = false
var player_ref: Player

func _physics_process(delta: float) -> void:
	if player_inside_area:
		move_toward(player_ref.global_position.x, global_position.x, pull_force * delta)
		move_toward(player_ref.global_position.y, global_position.y, pull_force * delta)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_ref = body
		player_inside_area = true

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_inside_area = false
