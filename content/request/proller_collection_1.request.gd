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
			"amount": 5,
		},
		{
			"hint": "Flowers",
			"type": "flower",
			"amount": 15,
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
	yield(get_tree().create_timer(1.0), "timeout")
	yield(dialogue.open([
		"[Tiny Maia outfit unlocked]",
	]), "completed")
	GameState.toggle_flag("outfit.tiny")
