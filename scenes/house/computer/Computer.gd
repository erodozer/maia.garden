extends StaticBody2D

onready var choices = get_node("CanvasLayer/Choices")
onready var karaoke = get_node("CanvasLayer/Karaoke")
onready var dialogue = get_node("CanvasLayer/Dialogue")

signal choice(index)

func hint():
	return "Stream"

func interact():
	# do not stream if already have streamed		
	if GameState.has_streamed:
		yield(dialogue.open([
			"I've already streamed today",
		]), "completed")
		return
	
	if GameState.stamina < 25:
		yield(dialogue.open([
			"I don't have the energy...",
		]), "completed")
		return
	
	var idx = yield(choices.pick(), "completed")

	if idx == -1:
		return
	if idx == 0:
		GameState.konpeto += int(lerp(50, 80, randf()))
		GameState.stamina -= 25
		GameState.has_streamed = true
		GameState.emit_signal("stat", "streamed", {
			"type": "chat"
		})
		return
	
	# start karaoke
	var earnings = yield(karaoke.play(), "completed")
	GameState.konpeto += earnings
	GameState.stamina -= 40
	GameState.has_streamed = true
	GameState.emit_signal("stat", "streamed", {
		"type": "karaoke"
	})
