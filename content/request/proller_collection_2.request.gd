extends "../request.gd"

func get_owner():
	return "proller"

func get_requirements():
	return [
		{
			"hint": "20 Clover",
			"id": "clover",
			"amount": 20,
		},
		{
			"hint": "20 Clover Seeds",
			"id": "seed_clover",
			"amount": 20,
		}
	]

func can_accept():
	return GameState.flag("request:proller_collection_1:complete")

func accept():
	.accept()
	var dialogue = get_tree().get_nodes_in_group("dialogue").front()
	yield(dialogue.open([
		"[wave amp=20 freq=2]There is someone in this forest[/wave]",
		"[wave amp=20 freq=2]They possess...a curious plant[/wave]",
		"[wave amp=20 freq=2]It is said to bring...luck[/wave]",
		"[wave amp=20 freq=2]I need you...your garden[/wave]",
		"[wave amp=20 freq=2]The seeds and the plant[/wave]",
		"[wave amp=20 freq=2]Would make a fine addition[/wave]",
	]), "completed")

func complete():
	.complete()
	var dialogue = get_tree().get_nodes_in_group("dialogue").front()
	yield(dialogue.open([
		"[wave amp=20 freq=2]hmm...[/wave]",
		"[wave amp=20 freq=2]hmmmmm...[/wave]",
		"[wave amp=20 freq=2]hmmmmmmmmmm...[/wave]",
		"[wave amp=20 freq=2]yes...I feel it...[/wave]",
		"[wave amp=20 freq=2]My collection...is lucky[/wave]",
		"[wave amp=20 freq=2]I am satisfied...[/wave]",
		"[wave amp=20 freq=2]Maia...I have this[/wave]",
		"[wave amp=20 freq=2]you may have it[/wave]",
		"[You got a bigger Backpack]",
	]), "completed")
	GameState.toggle_flag("bag_expansion:level_2")
