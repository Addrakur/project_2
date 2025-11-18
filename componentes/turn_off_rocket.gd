extends Area2D

@export var collision_polygon: CollisionPolygon2D
@onready var polygon: Polygon2D = $polygon

func _ready() -> void:
	polygon.polygon = collision_polygon.polygon

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.rocket_active = false

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		body.rocket_active = true
