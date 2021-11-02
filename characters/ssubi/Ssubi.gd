extends "res://characters/npc/npc.gd"

const godash = preload("res://addons/godash/godash.gd")

onready var dialogue = get_tree().get_nodes_in_group("dialogue").front()
onready var Game = get_node("CanvasLayer/Game")

func hint():
	return "Talk to Ssubi"
	
func can_talk():
	if not GameState.flag("ssubi.phrase_1"):
		return GameState.stats["talked_to_ssubi"].value > 2
	if not GameState.flag("ssubi.phrase_2"):
		return GameState.stats["talked_to_ssubi"].value > 5
	if not GameState.flag("ssubi.phrase_3"):
		return GameState.stats["talked_to_ssubi"].value > 9
	if not GameState.flag("ssubi.phrase_4"):
		return GameState.stats["talked_to_ssubi"].value > 15
	if not GameState.flag("ssubi.phrase_5"):
		return GameState.stats["talked_to_ssubi"].value > 23
	return false
	
func get_phrase():
	var phrases = [
		"[shake rate=30 level=8]SKREEEEEECH[/shake]",
		"[shake rate=30 level=8]SKREEEEEECH[/shake]",
	]
	
	if GameState.flag("ssubi.phrase_1"):
		phrases.append("HELLO")
	if GameState.flag("ssubi.phrase_2"):
		phrases.append("I love you")
	if GameState.flag("ssubi.phrase_3"):
		phrases.append("bewbewbew")
	if GameState.flag("ssubi.phrase_4"):
		phrases.append("NOM")
	if GameState.flag("ssubi.phrase_5"):
		phrases.append("")
	return phrases
	
func interact():
	var text = [
		godash.rand_choice(get_phrase())
	]
	var choices = []
	if can_talk():
		text.append("(Ssubi is looking at you)")
		text.append("(Teach Ssubi a new phrase?)")
		choices = ["Yes", "Not now"]
	else:
		GameState.emit_signal("stat", "npc.interact", {
			"id": "ssubi"
		})
		
	var choice = yield(dialogue.open(text, choices), "completed")
	
	if choice == "Yes":
		var difficulty = 1
		if not GameState.flag("ssubi.phrase_5"):
			difficulty = 5
		if not GameState.flag("ssubi.phrase_4"):
			difficulty = 4
		if not GameState.flag("ssubi.phrase_3"):
			difficulty = 3
		if not GameState.flag("ssubi.phrase_2"):
			difficulty = 2
		if not GameState.flag("ssubi.phrase_1"):
			difficulty = 1
		
		var won = yield(Game.start(difficulty), "completed")
		
		if won:
			GameState.toggle_flag("ssubi.phrase_%d" % difficulty)
			yield(dialogue.open([
				"[Ssubi learned a new phrase!]",
				get_phrase()[-1],
			]), "completed")
		else:
			yield(dialogue.open([
				"(That didn't go too well...)",
			]), "completed")
