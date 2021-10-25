extends Node2D

onready var scene_manager = get_tree().get_nodes_in_group("scene_manager").front()
onready var game_state = get_tree().get_nodes_in_group("game_state").front()

signal exit

export(String, "home", "forest") var return_location = "forest"

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		emit_signal("exit")

func _on_Map_exit():
	if scene_manager:
		scene_manager.change_scene("garden", {"location": return_location})

func _on_Maia_interact_start():
	get_node("CanvasLayer/Control/ExitControl").visible = false
	set_process_input(false)

func _on_Maia_interact_end():
	get_node("CanvasLayer/Control/ExitControl").visible = true
	set_process_input(true)
