extends Node2D

@export var door1: StaticBody2D
@export var door2: StaticBody2D
@export var animation_door_1: AnimationPlayer
@export var animation_door_2: AnimationPlayer
@export var open_door_1_area: Area2D
@export var open_door_2_area: Area2D
@export var player: Player

var player_inside_door_1: bool = false
var player_inside_door_2: bool = false

func _on_open_door_1_area_body_entered(body: Node2D) -> void:
	if body is Player:
		player_inside_door_1 = true
		if not animation_door_1.is_playing():
			animation_door_1.play("open_door_1")

func _on_open_door_2_area_body_entered(body: Node2D) -> void:
	if body is Player:
		player_inside_door_2 = true
		if not animation_door_2.is_playing():
			animation_door_2.play("open_door_2")

func _on_open_door_1_area_body_exited(body: Node2D) -> void:
	if body is Player:
		player_inside_door_1 = false
		if not animation_door_1.current_animation == "open_door_1":
			animation_door_1.play("close_door_1")

func _on_open_door_2_area_body_exited(body: Node2D) -> void:
	if body is Player:
		player_inside_door_2 = false
		if not animation_door_2.current_animation == "open_door_2":
			animation_door_2.play("close_door_2")

func _on_door_1_animation_animation_finished(anim_name: StringName) -> void:
	if player_inside_door_1 and anim_name == "close_door_1":
		animation_door_1.play("open_door_1")
	elif not player_inside_door_1 and anim_name == "open_door_1":
		animation_door_1.play("close_door_1")


func _on_door_2_animation_animation_finished(anim_name: StringName) -> void:
	if player_inside_door_2 and anim_name == "close_door_2":
		animation_door_2.play("open_door_2")
	elif not player_inside_door_2 and anim_name == "open_door_2":
		animation_door_2.play("close_door_2")