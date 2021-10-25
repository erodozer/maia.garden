extends StaticBody2D

onready var game_state = get_tree().get_nodes_in_group("game_state").front()
onready var dialogue = get_node("CanvasLayer/Dialogue")
onready var requests = get_node("Requests")

func hint():
	return "Talk to Proller"
	
func interact():
	yield(dialogue.open([
		"[wave amp=20 freq=2]Maia...[/wave]",
		"[wave amp=20 freq=2]You have something...I desire?[/wave]",
	]), "completed")
	yield(requests.open([
		"1 River Fish",
		"4 Tulips"
	]), "completed")
	
	if game_state:
		game_state.toggle_flag("introduce.proller.complete")
