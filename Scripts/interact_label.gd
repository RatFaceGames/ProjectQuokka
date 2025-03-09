extends Label3D
@export var label_pivot_path : NodePath
@export var boom_length : float = 1.0
@export var interact_behavior : GDScript

@onready var player_node : Node3D = get_tree().get_nodes_in_group("Player")[0]   
@onready var camera_node = player_node.get_node("Camera")

var label_pivot : Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label_pivot = get_node(label_pivot_path)

	if !label_pivot:
		label_pivot = get_parent()
	
func orient_label():
	var pivot_pos : Vector3 = label_pivot.global_transform.origin
	var camera_pos : Vector3 = camera_node.global_transform.origin
	
	var boom_offset = (camera_pos - pivot_pos).normalized() * boom_length
	
	global_transform.origin = pivot_pos + boom_offset

	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	orient_label()
