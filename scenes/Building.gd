extends Node

onready var player = get_tree().get_nodes_in_group("player").front()
export(String) var return_location = "Forest"

func _on_Maia_interact_start():
	set_process_input(false)

func _on_Maia_interact_end():
	set_process_input(true)

func _on_Exit_body_entered(_body):
	SceneManager.change_scene("garden", [return_location])
