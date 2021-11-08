extends StaticBody2D

onready var dialogue = get_tree().get_nodes_in_group("dialogue").front()

func _ready():
	if not GameState.calendar.is_maia_day():
		queue_free()
		
func hint():
	return "Talk to Clover"

func interact():
	yield(
		dialogue.open([
			"Good morning, Maia!",
			"Come with me into the forest",
		], ["Okay!", "Um...", "Why not"]),
		"completed"
	)
	
	yield(Bgm.fadeout(0.5), "completed")
	SceneManager.change_scene("birthday")
	
