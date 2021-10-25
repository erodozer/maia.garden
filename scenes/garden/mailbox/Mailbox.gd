extends Node2D

const Mail = []

onready var game_state = get_tree().get_nodes_in_group("game_state").front()

onready var tween = get_node("Tween") as Tween
onready var gui = get_node("CanvasLayer/Mailbox") as Control
onready var inbox = get_node("CanvasLayer/Mailbox/Inbox/Container/MarginContainer/ScrollContainer/ItemList") as ItemList
onready var letter = get_node("CanvasLayer/Mailbox/Letter")
onready var bubble = get_node("Bubble")

signal done
signal close_letter

var current_date = 0
var open_letter = null

func _ready():
	set_process_input(false)
	
	if not game_state:
		return
		
	show_bubble()
		
func show_bubble():
	var new_messages = false
	for m in game_state.inbox.values():
		if m.unread:
			new_messages = true
	bubble.visible = new_messages

func interact():
	if not game_state:
		return
		
	for m in game_state.inbox.values():
		var date = OS.get_datetime_from_unix_time(m.delivered)
		var idx = inbox.get_item_count()
		inbox.add_item(
			"%d/%d - %s%s" % [
				date.month,
				date.day,
				m.ref.sender,
				"*" if m.unread else ""
			]
		)
		inbox.set_item_metadata(idx, m)
	inbox.select(0)
	
	tween.interpolate_property(gui, "rect_position", Vector2(-200, 0), Vector2(0, 0), .2)
	tween.start()
	yield(tween, "tween_all_completed")
	inbox.grab_focus()
	inbox.grab_click_focus()
	inbox.unselect_all()
	set_process_input(true)
	yield(self, "done")
	show_bubble()
	set_process_input(false)
	tween.interpolate_property(gui, "rect_position", Vector2(0, 0), Vector2(-200, 3), .2)
	tween.start()
	yield(tween, "tween_all_completed")
	inbox.unselect_all()
	tween.stop_all()
	
	inbox.unselect_all()
	inbox.clear()
	
func hint():
	return "Check Mail"
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		close()
	
func close():
	if open_letter:
		open_letter = null
		emit_signal("close_letter")
	else:
		emit_signal("done")

func _on_ItemList_item_activated(index):
	open_letter = inbox.get_item_metadata(index)
	open_letter.unread = false
	var date = OS.get_datetime_from_unix_time(open_letter.delivered)
	inbox.set_item_text(
		index, 
		"%d/%d - %s%s" % [
			date.month,
			date.day,
			open_letter.ref.sender,
			""
		]
	)
	var text = letter.get_node("RichTextLabel")
	text.bbcode_text = "%s\n----\n%s" % [open_letter.ref.message, open_letter.ref.outro]
	text.scroll_to_line(0)
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
