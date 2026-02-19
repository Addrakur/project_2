class_name Portal
extends Area2D

@export var portal_par: Node2D

@onready var exit_point: Marker2D = $exit_point

var enter_velocity: float
var player_can_enter: bool = false
var player_vel: float

func _on_body_entered(body: Node2D) -> void:
	if body is Player and player_can_enter:
		if portal_par is Portal:
			player_vel = abs(body.velocity.x * cos(deg_to_rad(exit_point.global_rotation_degrees))) + abs(body.velocity.y * sin(deg_to_rad(exit_point.global_rotation_degrees)))
			body.velocity = Vector2.ZERO
			body.global_position = portal_par.exit_point.global_position
			body.velocity = Vector2(player_vel * -cos(deg_to_rad(portal_par.exit_point.global_rotation_degrees)), -player_vel * sin(deg_to_rad(portal_par.exit_point.global_rotation_degrees)))
		elif portal_par is OmniPortal:
			portal_par.portal_cooldown.start()
			body.global_position = portal_par.exit_point.global_position

func _on_player_can_go_through_body_entered(body: Node2D) -> void:
	if body is Player:
		player_can_enter = true

func _on_player_can_go_through_body_exited(body: Node2D) -> void:
	if body is Player:
		player_can_enter = false
