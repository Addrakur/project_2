class_name StateMachine
extends Node

@export var state: State

func _ready() -> void:
	change_state(state)

func change_state(new_state: State):
	state.exit_state()
	new_state.enter_state()
	state = new_state
