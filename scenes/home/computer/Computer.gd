extends StaticBody2D

const Fortunes = preload("res://core/fortune.gd").Fortunes

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
		
	var payout = 0
	var boost = 1.0
	if idx == 0:
		GameState.emit_signal("stat", "streamed", {
			"type": "chat"
		})
		yield(get_tree().create_timer(0.3), "timeout")
		payout = int(lerp(50, 80, randf()))
		GameState.player.perform_action(25)
		GameState.emit_signal("stat", "streamed", {
			"type": "chat"
		})
	elif idx == 1:
		# start karaoke
		payout = yield(karaoke.play(), "completed")
		if payout < 0:  # cancelled selecting a song
			return
		GameState.player.perform_action(40)
		GameState.emit_signal("stat", "streamed", {
			"type": "karaoke"
		})
	
	# good fortune streaming bonus
	if GameState.fortune.current_fortune == Fortunes.GOOD_LUCK_STREAM_BONUS:
		boost += 0.5
	# boost stream payout when tiny
	if GameState.player.outfit == "tiny":
		boost += 0.2
	GameState.player.balance += payout * boost
	GameState.player.has_streamed = true
	
