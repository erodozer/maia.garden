extends StaticBody2D

onready var game_state = get_tree().get_nodes_in_group("game_state").front()

onready var choices = get_node("CanvasLayer/Choices")
onready var karaoke = get_node("CanvasLayer/Karaoke")

signal choice(index)

func hint():
	return "Stream"

func interact():
	# do not stream if already have streamed
	if game_state and game_state.has_streamed:
		return
	
	var idx = yield(choices.pick(), "completed")

	if idx == -1:
		return
	if idx == 0:
		if game_state:
			game_state.konpeto += int(lerp(50, 80, randf()))
		return
	
	# start karaoke
	var earnings = yield(karaoke.play(), "completed")
	if game_state:
		game_state.konpeto += earnings
