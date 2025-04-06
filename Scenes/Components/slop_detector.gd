extends Area3D

@export var on_slop : Callable
signal slop_touched(slop : SlopChunk)

func is_slop(node : Node3D) -> bool:
	return node is SlopChunk

func get_slop_inside() -> Array[Node3D]:
	return get_overlapping_bodies().filter(is_slop)

func slop_entered(body : Node3D):
	if body is SlopChunk:
		emit_signal("slop_touched", body)
