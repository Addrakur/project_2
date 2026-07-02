extends Node2D

@export var object: Node2D
@export var rotation_speed: float

func physics_process(delta: float) -> void:
    object.rotation += rotation_speed * delta