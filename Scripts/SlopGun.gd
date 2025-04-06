class_name SlopGun
extends Node3D

@export var slop_exit_speed : float = 75.0
@export_range(0, 90, 0.001, "radians_as_degrees") var horizontal_spread_cone : float
@export_range(0, 90, 0.001, "radians_as_degrees") var vertical_spread_cone : float

var chunk_prefab : PackedScene = preload("uid://0itkq5xr37bp") #SlopCunk.tcsn 

func _ready() -> void:
	# Setup recoil animation, driven by damped_trigger_strength
	$RecoilSlidePlayer.play("SlopGunPushback")
	$RecoilSlidePlayer.speed_scale = 0

func _physics_process(delta: float) -> void:
	#todo - spring damping on trigger strength
	var trigger_strength : float = Input.get_action_strength("Shoot")
	$RecoilSlidePlayer.seek(trigger_strength, true)

func fire(deltaTime: float) -> void:
	var chunk : SlopChunk = chunk_prefab.instantiate()
	get_tree().root.add_child(chunk)
	var horizontal_angle = (randf() * horizontal_spread_cone * 2) - horizontal_spread_cone
	var vertical_angle = (randf() * vertical_spread_cone * 2) - vertical_spread_cone
	
	var spread_matrix = transform.basis.from_euler(Vector3(horizontal_angle, vertical_angle, 0))
	chunk.global_transform.origin = $GunModel/SlopEmitter.global_transform.origin
	chunk.global_transform.basis = $GunModel/SlopEmitter.global_transform.basis * spread_matrix;
	chunk.linear_velocity = -chunk.global_basis.z * slop_exit_speed
