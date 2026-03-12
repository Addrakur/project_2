class_name InteractableItem
extends Area2D

@export var manager: DoorManager
@export var color: Color
@onready var animation: AnimationPlayer = $animation
@onready var texture: Sprite2D = $texture
var interacted: bool = false

func _on_body_entered(body: Node2D) -> void:
	if body is Player and not interacted:
		animation.play("interacted")
		interacted = true
		manager.check_interactables()

func set_reset_color():
	texture.modulate = color
