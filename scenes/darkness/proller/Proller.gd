extends StaticBody2D

onready var game_state = get_tree().get_nodes_in_group("game_state").front()
onready var dialogue = get_node("CanvasLayer/Dialogue")
onready var requests = get_node("CanvasLayer/Requests")

func hint():
	return "Talk to Proller"
	
func interact():
	yield(dialogue.open([
		"[wave amp=20 freq=2]Maia...[/wave]",
		"[wave amp=20 freq=2]You have something...I desire?[/wave]",
	]), "completed")
	
	if not game_state:
		return
		
	var submitted = false
	if not game_state.flag("request.proller_1.complete"):
		submitted = yield(requests.open(
			[
				{
					"hint": "1 River Fish",
					"type": "fish",
					"category": "river",
					"amount": 1,
				},
				{
					"hint": "3 Tulips",
					"id": "tulip",
					"amount": 4,
				}
			], 
			"Proller wants to add the following to their collection"
		), "completed")
	elif not game_state.flag("request.proller_2.complete"):
		submitted = yield(requests.open(
			[
				{
					"hint": "20 Clover",
					"id": "clover",
					"amount": 20,
				},
				{
					"hint": "20 Clover Seeds",
					"id": "seed:clover",
					"amount": 20,
				}
			], 
			"Proller wants to add the following to their collection"
		), "completed")
	
	game_state.toggle_flag("introduce.proller.complete")
