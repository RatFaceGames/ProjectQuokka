extends Label3D

@onready var player_node = get_tree().get_nodes_in_group("Player")[0]  
@onready var camera_node = player_node.get_node("Camera")
@onready var boom_length : float = (transform.origin).length()

@export var interact_distance : float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func orient_label():
	var pivot_pos : Vector3 = get_parent_node_3d().global_transform.origin
	var camera_pos : Vector3 = camera_node.global_transform.origin
	
	var offset = (camera_pos - pivot_pos).normalized() * boom_length
	
	global_transform.origin = pivot_pos + offset

	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	orient_label()
