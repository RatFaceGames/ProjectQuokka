extends Node3D

@export var EngageRange : float = 15.0
@export var EngageClose : float = 2.0
@export var EngageMid : float = 5.0
@export var EngageFar : float = 10.0

@export var DisengageRange : float = 20


var Player: Node3D
var LeashTransform: Transform3D

func DistanceToPlayer() -> float:
	return (Player.transform.origin - self.transform.origin).length()

func RootState() -> void:
	while true:
		print("Goblin Root")
		if(DistanceToPlayer() < EngageRange):
			await ApproachState()
			await LeashState()
			
		await get_tree().process_frame

func ApproachState() -> void:
	while true:
		if(DistanceToPlayer() > DisengageRange):
			break
			
		print("Goblin approach")
		await get_tree().process_frame

func LeashState() -> void:
	while(true):
		pass

func _ready() -> void:
	Player = get_tree().get_nodes_in_group("Player").front()
	LeashTransform = self.transform
	RootState()

func _process(delta: float) -> void:
	pass
