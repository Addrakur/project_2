class_name ScreenManager
extends Node2D

@export var player: Player
@export var screens: Array[Screen]
@export var current_checkpoint: Marker2D

var starting_screen_index: float = 0
var current_screen: float

func _ready() -> void:
	var starting_screen: Screen = screens[screens.find(screens[starting_screen_index])]
	starting_screen.activate()
	for screen in screens:
		if screen != starting_screen:
			screen.deactivate()
	current_checkpoint = starting_screen.default_checkpoint
	player.position = current_checkpoint.position
	_initialize_cameras(starting_screen.camera)

func _initialize_cameras(starting_camera: PhantomCamera2D) -> void:
	# The player must already be at the checkpoint before resolving follow paths.
	for screen in screens:
		var phantom_camera: PhantomCamera2D = screen.camera
		var damping_enabled: bool = phantom_camera.follow_damping
		phantom_camera.follow_damping = false
		if phantom_camera.is_following():
			phantom_camera.teleport_position()
		# Resolve limits, axis locks and fixed cameras without an initial glide.
		phantom_camera.process_logic(0.0)
		phantom_camera.follow_damping = damping_enabled

	# Position the real camera before the host's first frame, preserving damping.
	var scene_camera: Camera2D = get_viewport().get_camera_2d()
	if is_instance_valid(scene_camera):
		scene_camera.global_transform = starting_camera.get_transform_output()
		scene_camera.zoom = starting_camera.zoom
		scene_camera.reset_physics_interpolation()
		scene_camera.force_update_scroll()

func player_die():
	player.velocity = Vector2.ZERO
	player.position = current_checkpoint.position
	player.fuel = player.max_fuel
	for item in screens[current_screen].start_on_touch_plats:
		item.reset_platform()
	for item in screens[current_screen].moving_objs_animation:
		item.play("RESET")
		item.play("1")
	for door in screens[current_screen].doors:
		door.animation_player.play("RESET")
		for item in door.interactables:
			item.interacted = false
			item.animation.play("RESET")
