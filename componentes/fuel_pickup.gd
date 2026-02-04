extends Area2D

var active: bool = true
@onready var animation: AnimationPlayer = $animation

var player_inside_area: bool = false
var player_ref: Player

func _process(_delta: float) -> void:
	if player_inside_area and active:
		player_ref.fuel = player_ref.max_fuel
		active = false
		animation.play("inactive")

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_ref = body
		player_inside_area = true

func _on_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "inactive":
		active = true
		animation.play("active")

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_inside_area = false
