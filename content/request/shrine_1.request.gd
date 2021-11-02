extends "../request.gd"

func get_owner():
	return "chie"
	
func get_id():
	return "shrine_1"

func get_requirements():
	return [
		{
			"hint": "1000 Konpeito",
			"id": "konpeito",
			"amount": 1000
		}
	]
	
func can_accept():
	return GameState.flag("introduce.chie")

func accept():
	.accept()
	var dialogue = get_tree().get_nodes_in_group("dialogue").front()
	yield(dialogue.open([
		"Maia, would you lend an ear",
		"The shrine is short on funds",
		"and it's nearly falling apart",
		"If you can spare some",
		"it would go a long way",
	]), "completed")

func complete():
	.complete()
	var dialogue = get_tree().get_nodes_in_group("dialogue").front()
	yield(dialogue.open([
		"This means so much",
		"I can't thank you enough",
		"But maybe I can lift your spirits",
		"[Gardening has become easier]"
	]), "completed")
	
	GameState.toggle_flag("garden_efficiency")
	
