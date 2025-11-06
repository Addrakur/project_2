extends RigidBody2D

@export var speed_x: float
@export var speed_y: float

@export var ground_speed_x: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	rotation_degrees = 0
	

func _physics_process(_delta: float) -> void:
	var direction_y = Input.get_axis("up","down")
	var direction_x = Input.get_axis("left","right")
	
	apply_force(Vector2(speed_x * direction_x, speed_y * direction_y), Vector2(0,0))
	apply_force(-linear_velocity)
	#print(linear_velocity)
