extends Node2D

signal exit

export(String, "home", "forest") var return_location = "forest"

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		emit_signal("exit")

func _on_Map_exit():
	SceneManager.change_scene("garden", {"location": return_location})

func _on_Maia_interact_start():
	get_node("CanvasLayer/HUD").visible = false
	set_process_input(false)

func _on_Maia_interact_end():
	get_node("CanvasLayer/HUD").visible = true
	set_process_input(true)
