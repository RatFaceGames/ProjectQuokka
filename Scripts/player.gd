extends CharacterBody3D

@export var top_speed : float = 5
@export var jump_velocity : float = 4.5

@export_range(0, 100, 1, "or_less", "or_greater", "radians_as_degrees") var yaw_speed = 7.5
@export_range(0, 100, 1, "or_less", "or_greater", "radians_as_degrees") var pitch_speed = 7.5

@export var acceleration : float = 20

@export var ground_drag_coeficcient : float = 10
@export var air_drag_coeficcient : float = 0;

func update_velocity(on_floor : bool, delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir : Vector2 = Input.get_vector("MoveLeft", "MoveRight", "MoveForward", "MoveBack")
	if input_dir:
		var direction : Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		velocity.x += direction.x * acceleration * delta
		velocity.x = clamp(velocity.x, -top_speed, top_speed)

		velocity.z += direction.z * acceleration * delta
		velocity.z = clamp(velocity.z, -top_speed, top_speed)
	elif velocity:
		var drag_coeficcient : float = ground_drag_coeficcient if on_floor else air_drag_coeficcient
		
		var vel_len_sqr : float = velocity.length_squared();
		var vel_dir : Vector3 = velocity / vel_len_sqr;
		var drag_acceleration : Vector3 = 0.5 * vel_len_sqr * drag_coeficcient * -vel_dir;
		velocity = velocity + drag_acceleration * delta

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
		$Camera.transform.basis = $Camera.transform.basis.from_euler(camera_euler)

func _physics_process(delta: float) -> void:
	var on_floor : bool = is_on_floor()
	
	update_velocity(on_floor, delta)
	update_orientation(delta)

	move_and_slide()
