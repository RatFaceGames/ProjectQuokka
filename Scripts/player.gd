extends CharacterBody3D

@export var top_speed : float = 5
@export var jump_velocity : float = 4.5
@export var interact_probe_range : float = 1000

@export_range(0, 100, 1, "or_less", "or_greater", "radians_as_degrees") var yaw_speed = 7.5
@export_range(0, 100, 1, "or_less", "or_greater", "radians_as_degrees") var pitch_speed = 7.5

@export var acceleration : float = 20
@export var deceleration : float = 60

func calculate_ground_velocity(delta: float) -> Vector3:
	var ground_velocity = velocity * Vector3(1,0,1)
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir : Vector2 = Input.get_vector("MoveLeft", "MoveRight", "MoveForward", "MoveBack")
	if input_dir:
		var direction : Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		ground_velocity.x += direction.x * acceleration * delta
		ground_velocity.x = clamp(ground_velocity.x, -top_speed, top_speed)

		ground_velocity.z += direction.z * acceleration * delta
		ground_velocity.z = clamp(ground_velocity.z, -top_speed, top_speed)
	elif ground_velocity:
		var ground_velocity_len = ground_velocity.length()
		var ground_velocity_dir = ground_velocity / ground_velocity_len
		var deceleration_mag = min(ground_velocity_len, deceleration * delta)
		
		var delta_velocity = -ground_velocity_dir * deceleration_mag;
		ground_velocity += delta_velocity
		
	return ground_velocity;

func update_velocity(on_floor: bool, delta: float) -> void:
	if on_floor:
		var new_ground_velocity = calculate_ground_velocity(delta)
		velocity.x = new_ground_velocity.x
		velocity.z = new_ground_velocity.z
	
	if not on_floor:
		# Add the gravity.
		velocity += get_gravity() * delta
	elif Input.is_action_just_pressed("Jump"):
		# Handle jump.
		velocity.y = jump_velocity

func update_orientation(delta: float) -> void:
		var input_dir : Vector2 = Input.get_vector("LookLeft", "LookRight", "LookDown", "LookUp")
		
		var delta_yaw : float = -input_dir.x * yaw_speed * delta;
		var player_euler : Vector3 = transform.basis.get_euler(EULER_ORDER_XYZ)
		player_euler.y += delta_yaw
		transform.basis = transform.basis.from_euler(player_euler, EULER_ORDER_XYZ)
		
		var camera_euler : Vector3 = $Camera.transform.basis.get_euler(EULER_ORDER_XYZ)
		var delta_pitch : float = input_dir.y * pitch_speed * delta;
		
		camera_euler.x += delta_pitch;
		camera_euler.x = clamp(camera_euler.x, deg_to_rad(-75), deg_to_rad(75))
		$Camera.transform.basis = Basis.from_euler(camera_euler)

func resolve_collisions():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider();
		if collider is RigidBody3D:
			var rigidBody = collider as RigidBody3D
			var targetMass = rigidBody.mass
			var impulse: Vector3 = (-collision.get_normal() * velocity.length()) / targetMass;
			rigidBody.apply_impulse(impulse);

func try_interact():
	var space_state : PhysicsDirectSpaceState3D = get_world_3d().direct_space_state

	var ray_start : Vector3 = $Camera.global_transform.origin
	var ray_dir : Vector3 = $Camera.global_transform.basis.z;
	var ray_end : Vector3 = ray_start + (ray_dir * interact_probe_range)


	# use global coordinates, not local to node
	var query = PhysicsRayQueryParameters3D.create(ray_start, ray_end)
	var result = space_state.intersect_ray(query)

	print("raycast res" + str(result));

func _physics_process(delta: float) -> void:
	var on_floor : bool = is_on_floor()
	
	update_velocity(on_floor, delta)
	update_orientation(delta)

	move_and_slide()
	
	resolve_collisions()
	
	if Input.is_action_just_released("Interact"):
		try_interact()
