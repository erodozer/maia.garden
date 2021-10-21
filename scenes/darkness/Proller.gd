extends StaticBody2D

onready var dialogue = get_node("Dialogue")
onready var requests = get_node("Requests")

func hint():
	return "Talk to Proller"
	
func interact():
	dialogue.begin()
	dialogue.text(
		"[wave amp=20 freq=2]Maia...[/wave]"
	)
	dialogue.text(
		"[wave amp=20 freq=2]You have something...I desire?[/wave]"
	)
	yield(dialogue.exec(), "completed")
	yield(requests.open([
		"1 River Fish",
		"4 Tulips"
	]), "completed")
	
