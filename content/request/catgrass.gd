extends "../request.gd"

# state variables
var talked_to_clover = false

func get_owner():
	return "yuuki"

func get_id():
	return "catgrass"

func get_requirements():
	return [
		{
			"hint": "5 Catgrass",
			"id": "catgrass",
			"amount": 5
		}
	]

func prompt():
	return "Yuuki is in need of supplies for the Catfe"
	
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

func can_talk_to_clover():
	return not game_state.flag("%s:talked_to_clover" % key())

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
	game_state.inventory.insert_item({
		"id": catgrass.id,
		"ref": catgrass,
		"amount": 5
	})
	game_state.toggle_flag("unlocked_catgrass")  # allow purchasing catgrass
	
	return true
