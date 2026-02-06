class_name Portal
extends Area2D

@export var portal_par: Portal
@export_enum("horizontal","vertical","diagonal") var direction: String
@export var exit_direction: Vector2

@onready var exit_point: Marker2D = $exit_point

var enter_velocity: float
var player_can_enter: bool = false
var player_vel: Vector2

func _on_body_entered(body: Node2D) -> void:
	if body is Player and player_can_enter:
		body.velocity = Vector2.ZERO
		body.global_position = portal_par.exit_point.global_position
		match direction:
			"horizontal":
				enter_velocity = player_vel.x
			"vertical":
				enter_velocity = player_vel.y
			"diagonal":
				if player_vel.x > player_vel.y:
					enter_velocity = player_vel.x
				else:
					enter_velocity = player_vel.y
		
		match portal_par.direction:
			"horizontal":
				body.velocity = Vector2(enter_velocity * portal_par.exit_direction.x,0)
			"vertical":
				body.velocity = Vector2(0,enter_velocity * portal_par.exit_direction.y)
			"diagonal":
				body.velocity = Vector2(enter_velocity * portal_par.exit_direction.x,-enter_velocity * portal_par.exit_direction.y)

func _on_player_can_go_through_body_entered(body: Node2D) -> void:
	if body is Player:
		player_can_enter = true
		player_vel = body.velocity

func _on_player_can_go_through_body_exited(body: Node2D) -> void:
	if body is Player:
		player_can_enter = false
