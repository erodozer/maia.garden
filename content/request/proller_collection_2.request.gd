extends "../request.gd"

# state variables
var talked_to_clover = false

func get_owner():
	return "proller"

func get_id():
	return "proller_1"

func get_requirements():
	return [
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
	]

func prompt():
	return "Proller wants to add the following to their collection"
	
func can_accept():
	return GameState.flag("request:proller_collection_1:complete")

func accept():
	.accept()
	var dialogue = get_tree().get_nodes_in_group("dialogue").front()
	yield(dialogue.open([
		"Hey Maia, could you help me?",
		"My cats deserve something nice",
		"Will you visit the flower shop",
		"They should have Catgrass",
		"Thank you~",
	]), "completed")

func complete():
	.complete()
	var dialogue = get_tree().get_nodes_in_group("dialogue").front()
	yield(dialogue.open([
		"This is perfect! Thank you Maia~",
	]), "completed")
