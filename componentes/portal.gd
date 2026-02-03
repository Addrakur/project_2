class_name Portal
extends Area2D

@export var portal_par: Portal
@export_enum("horizontal","vertical","diagonal") var direction: String
@export var exit_direction: Vector2

@onready var exit_point: Marker2D = $exit_point

var enter_velocity: float

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.global_position = portal_par.exit_point.global_position
		match direction:
			"horizontal":
				enter_velocity = body.velocity.x
			"vertical":
				enter_velocity = body.velocity.y
			"diagonal":
				if body.velocity.x > body.velocity.y:
					enter_velocity = body.velocity.x
				else:
					enter_velocity = body.velocity.y
		
		match portal_par.direction:
			"horizontal":
				body.velocity = Vector2(enter_velocity * portal_par.exit_direction.x,0)
			"vertical":
				body.velocity = Vector2(0,-enter_velocity * portal_par.exit_direction.y)
			"diagonal":
				body.velocity = Vector2(enter_velocity * portal_par.exit_direction.x,-enter_velocity * portal_par.exit_direction.y)
