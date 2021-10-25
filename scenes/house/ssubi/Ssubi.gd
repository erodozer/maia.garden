extends StaticBody2D

const godash = preload("res://addons/godash/godash.gd")

onready var dialogue = get_node("CanvasLayer/Dialogue")

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
	yield(dialogue.open([
		godash.rand_choice(PHRASES)
	]), "completed")
