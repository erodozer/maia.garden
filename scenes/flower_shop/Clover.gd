extends StaticBody2D

onready var dialogue = get_node("Dialogue")

func hint():
	return "Talk to Clover"

func interact():
	dialogue.begin()
	dialogue.text(
		"Hi Maia!  What can I do for you?"
	)
	yield(dialogue.exec(), "completed")
