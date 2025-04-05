class_name SlopGun
extends Node3D

var chunk_prefab : PackedScene = preload("uid://0itkq5xr37bp") #SlopCunk.tcsn 

@export var slop_exit_speed : float = 75.0
@export_range(0, 90, 0.001, "radians_as_degrees") var horizontal_spread_cone : float = 2
@export_range(0, 90, 0.001, "radians_as_degrees") var vertical_spread_cone : float = 2

func fire(deltaTime: float):
	var chunk : SlopChunk = chunk_prefab.instantiate();
	get_tree().root.add_child(chunk);
	
	var horizontal_angle = (randf() * horizontal_spread_cone * 2) - horizontal_spread_cone
	var vertical_angle = (randf() * vertical_spread_cone * 2) - vertical_spread_cone
	
	var spread_matrix = transform.basis.from_euler(Vector3(horizontal_angle, vertical_angle, 0))
	chunk.global_transform.origin = $SlopEmitter.global_transform.origin
	chunk.global_transform.basis = chunk.global_transform.basis * spread_matrix;
	
	chunk.linear_velocity = -chunk.global_basis.z * slop_exit_speed
