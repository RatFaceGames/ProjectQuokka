class_name SlopChunk
extends RigidBody3D

@export var total_lifespan : float = 10.0

@onready var remaining_lifespan : float = total_lifespan

func _process(delta: float) -> void:
	remaining_lifespan -= delta
	if(remaining_lifespan <= 0):
		queue_free()
