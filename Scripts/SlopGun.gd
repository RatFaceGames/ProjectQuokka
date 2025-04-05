class_name SlopGun
extends Node3D

var chunk_prefab : PackedScene = preload("uid://0itkq5xr37bp") #SlopCunk.tcsn 

func fire(deltaTime: float):
	var chunk = chunk_prefab.instantiate();
	get_tree().root.add_child(chunk);
