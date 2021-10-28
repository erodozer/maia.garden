extends "res://scenes/Building.gd"

func _ready():
	if not GameState.flag("introduce.proller.complete"):
		get_node("CanvasLayer/Control/ExitControl").visible = false
			
func _input(event):
	if not GameState.flag("introduce.proller.complete"):
		return 

	._input(event)

func _on_Maia_interact_end():
	._on_Maia_interact_end()
	
	if not GameState.flag("introduce.proller.complete"):
		get_node("CanvasLayer/Control/ExitControl").visible = false
