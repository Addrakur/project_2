class_name DoorManager
extends Node2D

@export var animation_player: AnimationPlayer
@export var interactables: Array[InteractableItem]

func check_interactables():
	for item in interactables:
		if not item.interacted:
			return
	
	animation_player.play("open")
