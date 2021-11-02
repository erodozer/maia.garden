extends Node

onready var load_list = get_node("CanvasLayer/LoadPanel")

func _ready():
	match OS.get_name():
		"HTML5":
			get_node("CanvasLayer/TitleButtons/VBoxContainer/Exit/Button").queue_free()
			
	get_node("CanvasLayer/TitleButtons/VBoxContainer/NewGame/Button").grab_focus()

func _on_newgame_toggled(button_pressed):
	if not button_pressed:
		return
		
	GameState.reset_game()
	SceneManager.change_scene("garden", ["Home"])

func _on_loadgame_toggled(button_pressed):
	if not button_pressed:
		return
		
	yield(load_list.open(), "completed")
	get_node("CanvasLayer/TitleButtons/VBoxContainer/LoadGame/Button").pressed = false
	get_node("CanvasLayer/TitleButtons/VBoxContainer/LoadGame/Button").grab_focus()
	

func _on_exit_toggled(button_pressed):
	if not button_pressed:
		return
		
	get_tree().quit()
