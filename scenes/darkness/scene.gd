extends "res://scenes/Building.gd"

func _setup(_params):
	if not GameState.flag("introduce.proller.complete"):
		get_node("Proller").introduction()
			
func _on_Exit_body_entered(body):
	if not GameState.flag("introduce.proller.complete"):
		return 

	._on_Exit_body_entered(body)
