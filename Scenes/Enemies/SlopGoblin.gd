extends Node3D

@export var MinRange : float = 10.0
@export var MiaxRange : float = 5.0

func _process(delta: float) -> void:
	var player : Node3D = get_tree().get_nodes_in_group("Player").front();
	pass
