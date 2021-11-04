extends "../request.gd"

func get_owner():
	return "yuuki"
	
func get_id():
	return "cafe_2"

func get_requirements():
	return [
		{
			"hint": "Wheat",
			"id": "wheat",
			"amount": 10
		}
	]
	
func can_accept():
	return GameState.flag("unlocked_vegetables")

func accept():
	.accept()
	var dialogue = get_tree().get_nodes_in_group("dialogue").front()
	yield(dialogue.open([
		"Oh Maia...",
		"As much as I like my new catfe",
		"it's lacking something.",
		"There's no bread!",
		"What's a catfe without bread",
		"And its delicious smell.",
		"I was talking to Clover",
		"She said you grew wheat!",
		"Could you grow some for me?",
		"Bread with fresh ingredients",
		"I'm so excited!"
	]), "completed")

func complete():
	.complete()
	var dialogue = get_tree().get_nodes_in_group("dialogue").front()
	yield(dialogue.open([
		"Oh this is just amazing!",
		"I can make flour with this",
		"And with that delicious bread!",
		"Thank you so much Maia",
	]), "completed")
