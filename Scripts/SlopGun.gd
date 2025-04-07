class_name SlopGun
extends Node3D

@export var slop_per_second : float = 120
@export var slop_exit_speed : float = 75.0
@export_range(0, 90, 0.001, "radians_as_degrees") var horizontal_spread_cone : float
@export_range(0, 90, 0.001, "radians_as_degrees") var vertical_spread_cone : float

var chunk_prefab : PackedScene = preload("uid://0itkq5xr37bp") #SlopCunk.tcsn 
var leftover_slop : float = 0

func _ready() -> void:
	# Setup recoil animation, driven by damped_trigger_strength
	$RecoilSlidePlayer.play("RecoilSlide")
	$RecoilSlidePlayer.speed_scale = 0
	$slopgun/AnimationPlayer.play("HandleAction_003")
	$slopgun/AnimationPlayer.speed_scale = 0

func fire(deltaTime: float, strength : float) -> void:
	$RecoilSlidePlayer.seek(strength, true)
	$slopgun/AnimationPlayer.seek(strength, true)
	
	var numToSpawn : float = slop_per_second * deltaTime * strength
	leftover_slop = leftover_slop + numToSpawn - int(numToSpawn)
	
	var finalNumToSpawn = int(numToSpawn)
	while leftover_slop >= 1.0:
		finalNumToSpawn = finalNumToSpawn + 1
		leftover_slop = leftover_slop - 1
	
	print(finalNumToSpawn)
	for i in range( finalNumToSpawn ):
		var chunk : SlopChunk = chunk_prefab.instantiate()
		get_tree().root.add_child(chunk)
		var horizontal_angle = (randf() * horizontal_spread_cone * 2) - horizontal_spread_cone
		var vertical_angle = (randf() * vertical_spread_cone * 2) - vertical_spread_cone
		var spread_matrix = Basis.from_euler(Vector3(horizontal_angle, vertical_angle, 0))
		chunk.global_transform.origin = $slopgun/SlopEmitter.global_transform.origin
		chunk.global_transform.basis = $slopgun/SlopEmitter.global_transform.basis * spread_matrix;
		chunk.linear_velocity = -chunk.global_basis.z * slop_exit_speed
