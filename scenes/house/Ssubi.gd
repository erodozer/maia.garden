extends StaticBody2D

const godash = preload("res://addons/godash/godash.gd")

onready var dialogue = get_node("Dialogue")

const PHRASES = [
	"[shake rate=30 level=8]SKREEEEEECH[/shake]",
	"[shake rate=30 level=8]SKREEEEEECH[/shake]",
	"[shake rate=30 level=8]SKREEEEEECH[/shake]",
	"I love you",
	"HELLO",
	"bewbewbew"
]

func hint():
	return "Talk to Ssubi"
	
func interact():
	dialogue.begin()
	dialogue.text(godash.rand_choice(PHRASES))
	yield(dialogue.exec(), "completed")
