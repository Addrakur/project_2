extends CanvasLayer

func _on_tutorial_pressed() -> void:
	get_tree().change_scene_to_file("res://worlds/tutorial.tscn")


func _on_world_1_pressed() -> void:
	get_tree().change_scene_to_file("res://worlds/world_1.tscn")


func _on_testes_pressed() -> void:
	get_tree().change_scene_to_file("res://testes/loop_basico.tscn")
