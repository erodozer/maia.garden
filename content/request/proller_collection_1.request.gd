extends "../request.gd"

# state variables
var talked_to_clover = false

func get_owner():
	return "proller"

func get_id():
	return "proller_collection_1"

func get_requirements():
	return [
		{
			"hint": "Fish",
			"type": "fish",
			"amount": 3,
		},
		{
			"hint": "Flowers",
			"id": "flower",
			"amount": 3,
		}
	]
	
func can_accept():
	return GameState.flag('introduce.proller')

func complete():
	.complete()
	var dialogue = get_tree().get_nodes_in_group("dialogue").front()
	yield(dialogue.open([
		"[wave amp=20 freq=2]A fine addition...thank you[/wave]",
		"[wave amp=20 freq=2]In return...a favor[/wave]",
	]), "completed")
	yield(get_tree().create_timer(2.0), "timeout")
	yield(dialogue.open([
		"[You can now change into Tiny Maia]",
	]), "completed")
	GameState.toggle_flag("outfit.tiny")
