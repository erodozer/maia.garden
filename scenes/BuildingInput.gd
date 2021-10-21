extends Node2D

onready var scene_manager = get_tree().get_nodes_in_group("scene_manager").front()

func _unhandled_input(event):
	if event.is_action_released("ui_cancel"):
		if scene_manager:
			scene_manager.change_scene("res://scenes/garden/Garden.tscn")
