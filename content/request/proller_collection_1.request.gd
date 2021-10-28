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
	]
	
func can_accept():
	return true

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
