extends "../request.gd"

func get_owner():
	return "yuuki"
	
func get_id():
	return "cafe_2"

func get_requirements():
	return [
		{
			"hint": "10 Wheat",
			"id": "Wheat",
			"amount": 10
		}
	]
	
func can_accept():
	return GameState.flag("request:flower_1:completed")

func accept():
	.accept()
	var dialogue = get_tree().get_nodes_in_group("dialogue").front()
	yield(dialogue.open([
		"Oh Maia...",
		"As much as I like my new catfe",
		"it's lacking something.",
		"There's no bread!",
		"What's a catfe without bread",
		"Warm fresh bread",
		"And its delicious smell.",
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

func can_talk_to_clover():
	return not GameState.flag("unlocked_catgrass" % key())

func talk_to_clover():
	var dialogue = get_tree().get_nodes_in_group("dialogue").front()
	yield(dialogue.open([
		"Oh Yuuki asked you to stop by?",
		"Sadly I don't have any catgrass",
		"However, I do have some seeds",
		"You can grow it in your garden",
		"The quality will be just as good",
		"[Got 5 Catgrass Seeds]",
		"Feel free to buy more if you need"
	]), "completed")
	
	var catgrass = Content.get_item_reference("seed_catgrass")
	GameState.inventory.insert_item({
		"id": catgrass.id,
		"ref": catgrass,
		"amount": 5
	})
	GameState.toggle_flag("unlocked_catgrass")  # allow purchasing catgrass
