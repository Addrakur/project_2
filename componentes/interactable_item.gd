class_name InteractableItem
extends Area2D

@export var manager: Node2D
@onready var animation: AnimationPlayer = $animation
var interacted: bool = false


func _on_body_entered(body: Node2D) -> void:
	if body is Player and not interacted:
		animation.play("interacted")
		interacted = true
		manager.check_interactables()
