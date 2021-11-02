extends "res://scenes/Building.gd"

func _setup(_params):
	if not GameState.flag("introduce.proller.complete"):
		get_node("Proller").introduction()
			
func _input(event):
	if not GameState.flag("introduce.proller.complete"):
		return 

	._input(event)

