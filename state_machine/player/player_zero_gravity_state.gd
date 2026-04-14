extends State

@export var player: Player

func _ready() -> void:
	set_physics_process(false)

func enter_state():
	set_physics_process(true)
	#print("entrou " + name)

func exit_state():
	set_physics_process(false)
	#print("saiu " + name)

func _physics_process(delta: float) -> void:
	#print(name)
	if not player.no_gravity:
		player.state_machine.change_state(player.ground_state)
	
	if not Input.is_action_pressed("jetpack") and player.fuel < player.max_fuel and not player.rocket_no_recharge:
		player.fuel += player.fuel_zero_gravity_restore * delta
	player.move_side_logic(delta,player.no_gravity_directional_force,player.max_speed_zero_gravity)
	player.move_up_down_logic(delta,player.no_gravity_directional_force, player.max_speed_zero_gravity)
	player.velocity.y += player.up_down_velocity
