extends "res://characters/npc/npc.gd"

onready var dialogue = get_tree().get_nodes_in_group("dialogue").front()
onready var fortune = get_tree().get_nodes_in_group("fortune").front()

const FORTUNE_FEE = 10

func hint():
	return "Talk to Chie"
	
func interact():
	var choices = []
	var text = [
		"Hello Maia!",
		"Thanks for stopping by",
	]
	if GameState.player.balance > FORTUNE_FEE:
		text.append(
			"Want to know about tomorrow?"
		)
		choices = ["Fortune", "No Thanks"]
		
	if can_talk():
		choices.push_front("Talk")
	
	var choice = yield(dialogue.open(text, choices), "completed")
	
	if choice == "Talk":
		yield(check_requests(), "completed")
		return
		
	if choice == "Fortune":
		GameState.player.balance -= FORTUNE_FEE
		var f = GameState.fortune.get_new_fortune()
		yield(fortune.open(f), "completed")
		return
	
