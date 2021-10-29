extends "res://scenes/Building.gd"

func _setup(_params):
	if not GameState.flag("introduce.proller.complete"):
		get_node("CanvasLayer/HUD/ExitControl").visible = false
		get_node("Proller").introduction()
			
func _input(event):
	if not GameState.flag("introduce.proller.complete"):
		return 

	._input(event)

func _on_Maia_interact_end():
	._on_Maia_interact_end()
	
	if GameState.flag("introduce.proller.complete"):
		get_node("CanvasLayer/HUD/ExitControl").visible = true
