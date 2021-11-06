extends Node2D

const Mail = []

onready var mail = get_node("CanvasLayer/Mailbox") as Control
onready var bubble = get_node("Bubble")

func _ready():
	show_bubble()
		
func show_bubble():
	var new_messages = false
	for m in GameState.mail.inbox.values():
		if m.unread:
			new_messages = true
	bubble.visible = new_messages
	
func can_interact():
	return len(GameState.mail.inbox) > 0

func interact():
	yield(mail.open(), "completed")
	show_bubble()
	
func hint():
	return "Check Mail"

