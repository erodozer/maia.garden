extends StaticBody2D

onready var dialogue = get_tree().get_nodes_in_group("dialogue").front()

func _ready():
	if not GameState.calendar.is_maia_day():
		queue_free()
		
func hint():
	return "Talk to Chie"

func interact():
	yield(
		dialogue.open([
			"Good morning, Maia!",
			"I have something to show you",
			"will you follow me?",
		], ["Okay!", "Um...", "Why not"]),
		"completed"
	)
	yield(
		dialogue.open([
			"Great!",
			"It's something you'll love!",
			"Right this way~",
			"Oh, and also",
			"Happy Birthday!",
		]),
		"completed"
	)
	
	yield(Bgm.fadeout(0.5), "completed")
	SceneManager.change_scene("birthday")
	
