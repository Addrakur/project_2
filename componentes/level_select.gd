extends CanvasLayer

@export var panel: Panel

func _on_visibility_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		panel.visible = true
	else:
		panel.visible = false
