extends Node

onready var scene_manager = get_tree().get_nodes_in_group("scene_manager").front()

func _ready():
	scene_manager.change_scene("garden")
