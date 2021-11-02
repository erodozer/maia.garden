extends Node

signal exit

onready var player = get_tree().get_nodes_in_group("player").front()
export(String, "home", "forest") var return_location = "forest"

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		emit_signal("exit")

func _on_Map_exit():
	SceneManager.change_scene("garden", {"location": return_location})

func _on_Maia_interact_start():
	set_process_input(false)

func _on_Maia_interact_end():
	set_process_input(true)
