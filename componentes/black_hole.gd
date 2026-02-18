extends Area2D

@export var max_pull_force: float
@export var pull_area: CollisionShape2D

var pull_force: float
var player_inside_area: bool = false
var player_ref: Player

var player_pull_direction: float

func _physics_process(delta: float) -> void:
	if player_inside_area:
		set_pull_force()
		player_pull_direction = get_angle_to(player_ref.position)
		player_ref.velocity.x -= cos(player_pull_direction) * pull_force * delta
		player_ref.velocity.y -= sin(player_pull_direction) * pull_force * delta
		

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_ref = body
		player_inside_area = true

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_inside_area = false

func set_pull_force():
	pull_force = max_pull_force / (global_position.distance_to(player_ref.global_position) / pull_area.shape.radius)
