extends Node2D

@export var door1: StaticBody2D
@export var door2: StaticBody2D
@export var animation: AnimationPlayer
@export var open_door_1_area: Area2D
@export var open_door_2_area: Area2D
@export var player: Player

func _on_open_door_1_area_body_entered(body: Node2D) -> void:
	if body is Player:
		animation.play("open_door_1")


func _on_open_door_2_area_body_entered(body: Node2D) -> void:
	if body is Player:
		player.can_move = false
		animation.play("close_door_1")

func _on_door_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "close_door_1":
		animation.play("open_door_2")
	elif anim_name == "open_door_2":
		player.can_move = true
