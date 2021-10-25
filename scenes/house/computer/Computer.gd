extends StaticBody2D

onready var game_state = get_tree().get_nodes_in_group("game_state").front()

onready var choices = get_node("CanvasLayer/Choices")
onready var karaoke = get_node("CanvasLayer/Karaoke")
onready var dialogue = get_node("CanvasLayer/Dialogue")

signal choice(index)

func hint():
	return "Stream"

func interact():
	# do not stream if already have streamed
	if not game_state:
		return
		
	if game_state.has_streamed:
		yield(dialogue.open([
			"I've already streamed today"
		]), "completed")
		return
	
	if game_state.stamina < 25:
		yield(dialogue.open([
			"I don't have the energy...",
			"Streaming requires at least 25 stamina",
		]), "completed")
		return
	
	var idx = yield(choices.pick(), "completed")

	if idx == -1:
		return
	if idx == 0:
		if game_state:
			game_state.konpeto += int(lerp(50, 80, randf()))
			game_state.stamina -= 25
			game_state.has_streamed = true
		return
	
	# start karaoke
	var earnings = yield(karaoke.play(), "completed")
	if game_state:
		game_state.konpeto += earnings
		game_state.stamina -= 40
		game_state.has_streamed = true
	
