extends StaticBody2D

onready var choices = get_node("CanvasLayer/Choices")
onready var karaoke = get_node("CanvasLayer/Karaoke")
onready var dialogue = get_node("CanvasLayer/Dialogue")

func hint():
	return "Stream"

func can_interact():
	return not GameState.player.has_streamed and GameState.player.can_perform_action(25)

func interact():
	var idx = yield(choices.pick(), "completed")

	if idx == -1:
		return
	if idx == 0:
		GameState.player.has_streamed = true
		GameState.emit_signal("stat", "streamed", {
			"type": "chat"
		})
		yield(get_tree().create_timer(0.3), "timeout")
		GameState.player.balance += int(lerp(50, 80, randf()))
		GameState.player.perform_action(25)
		return
	
	# start karaoke
	var earnings = yield(karaoke.play(), "completed")
	if earnings < 0:
		return
	GameState.player.balance += earnings
	GameState.player.perform_action(40)
	GameState.player.has_streamed = true
	GameState.emit_signal("stat", "streamed", {
		"type": "karaoke"
	})
