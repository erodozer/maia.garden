extends Node

onready var scene_manager = get_tree().get_nodes_in_group("scene_manager").front()

func _on_Map_exit():
	if scene_manager:
		scene_manager.change_scene("res://scenes/garden/Garden.tscn", {"location": "home"})
