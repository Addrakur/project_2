extends Line2D

var path_node: Node

func _ready() -> void:
	path_node = get_parent()
	if not path_node is Path2D:
		print(path_node.name + " is not a Path2D node")
	else:
		points = path_node.curve.get_baked_points()
