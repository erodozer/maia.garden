extends "res://characters/npc/npc.gd"

onready var dialogue = get_tree().get_nodes_in_group("dialogue").front()

func hint():
	return "Talk to Proller"
	
func interact():
	GameState.toggle_flag("introduce.proller.complete")
	yield(dialogue.open([
		"[wave amp=20 freq=2]Maia...[/wave]",
		"[wave amp=20 freq=2]You have something...I desire?[/wave]",
	]), "completed")
	
	yield(check_requests(), "complete")
	
