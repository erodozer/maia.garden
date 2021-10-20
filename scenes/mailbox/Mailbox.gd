extends Node2D

onready var tween = get_node("Tween") as Tween
onready var gui = get_node("CanvasLayer/Mailbox") as Control
onready var inbox = get_node("CanvasLayer/Mailbox/Inbox/Container/MarginContainer/ScrollContainer/ItemList")
onready var letter = get_node("CanvasLayer/Mailbox/Letter")
signal done
signal close_letter

var current_date = 0
var open_letter = null

const mail = [
	{
		"date": "10/19/21",
		"sender": "Chie",
		"message": """Daily Fortune Telling
---
Good Luck!

The spirits are in your favor today, your radiant flowers are sure to yield lots of konpeto
""",
		"outro": "Chie",
	},
	{
		"date": "10/19/21",
		"sender": "Ero",
		"message": """This is a test message
If you see this in the final version I forgot to remove it
""",
		"outro": "Ero",
	},
	{
		"date": "10/19/21",
		"sender": "Vogon",
		"message": """A sweet Happy Birfday to the sweetest little fairy!
Thanks for a whole year of streams and then a whole year of birthdays!
The Garden wishes you the absolute best on your special day!
""",
		"outro": "Vogon out",
	}
]

func _ready():
	set_process_input(false)
	populate()

func interact():
	tween.interpolate_property(gui, "rect_position", Vector2(-200, 0), Vector2(0, 0), .2)
	tween.start()
	yield(tween, "tween_all_completed")
	set_process_input(true)
	inbox.grab_focus()
	inbox.grab_click_focus()
	yield(self, "done")
	set_process_input(false)
	tween.interpolate_property(gui, "rect_position", Vector2(0, 0), Vector2(-200, 3), .2)
	tween.start()
	yield(tween, "tween_all_completed")
	inbox.unselect_all()
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		close()
		
func populate():
	inbox.unselect_all()
	inbox.clear()
	for m in mail:
		inbox.add_item(
			"%s - %s" % [m.date, m.sender]
		)
	
func close():
	if open_letter:
		open_letter = null
		emit_signal("close_letter")
	else:
		emit_signal("done")

func _on_ItemList_item_activated(index):
	open_letter = mail[index]
	var text = letter.get_node("RichTextLabel")
	text.bbcode_text = "%s\n----\n%s" % [open_letter.message, open_letter.outro]
	
	tween.stop_all()
	tween.interpolate_property(letter, "rect_position", Vector2(25, 170), Vector2(25, 30), .2)
	tween.start()
	yield(tween, "tween_all_completed")
	text.grab_focus()
	text.grab_click_focus()
	yield(self, "close_letter")
	tween.stop_all()
	tween.interpolate_property(letter, "rect_position", Vector2(25, 30), Vector2(25, 170), .2)
	tween.start()
	yield(tween, "tween_all_completed")
	inbox.grab_focus()
	inbox.grab_click_focus()

func _on_Mailbox_gui_input(event: InputEvent):
	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		close()
		gui.accept_event()
