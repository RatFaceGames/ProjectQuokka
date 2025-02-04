extends CharacterBody3D

@export var top_speed : float = 5
@export var jump_velocity : float = 4.5

@export var acceleration : float = 20
@export var ground_drag_coeficcient : float = 10
@export var air_drag_coeficcient : float = 0;

func _physics_process(delta: float) -> void:
	# Add the gravity.
	var on_floor : bool = is_on_floor()
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("MoveLeft", "MoveRight", "MoveForward", "MoveBack")
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

	move_and_slide()
