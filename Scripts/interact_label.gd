extends Label3D

@onready var player_node = get_tree().get_nodes_in_group("Player")[0]  
@export var interact_distance : float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	var parent_pos_xz : Vector3 = get_parent_node_3d().transform.origin * Vector3(1,0,1)
	var player_pos_xz : Vector3 = player_node.transform.origin * Vector3(1,0,1)

	var dist_sqr = (player_pos_xz - parent_pos_xz).length_squared()

	var in_range = dist_sqr < interact_distance * interact_distance
	if in_range:
		self.visible = true
	else:
		self.visible = false
