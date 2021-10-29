extends "res://characters/npc/npc.gd"

onready var dialogue = get_tree().get_nodes_in_group("dialogue").front()

func hint():
	return "Talk to Chie"
	
func interact():
	var choices = []
	var text = [
		"Hello Maia!",
	]
	if GameState.konpeto > 10:
		text.append(
			"Would you like to know about tomorrow?"
		)
		choices = ["Fortune", "No Thanks"]
		
	if can_talk():
		choices.push_front("Talk")
	
	var choice = yield(dialogue.open(text, choices), "completed")
	
	if choice == "Talk":
		yield(check_requests(), "completed")
		return
		
	if choice == "Fortune":
		var fortune = GameState.get_fortune()
		
		yield(fortune(), "completed")
		return
	
