extends Control

onready var tween = get_node("Tween") as Tween
onready var inbox = get_node("Inbox/Container/MarginContainer/ScrollContainer/ItemList") as ItemList
onready var letter = get_node("Letter")

signal done
signal close_letter

var opened = false
var current_date = 0
var open_letter = null

func _ready():
	set_process_input(false)

func sort_mail(a, b):
	if b.delivered < a.delivered:
		return true
	return false

func open():
	var mail = GameState.mail.inbox.values()
	mail.sort_custom(self, "sort_mail")
	for m in mail:
		var date = OS.get_datetime_from_unix_time(m.delivered)
		var idx = inbox.get_item_count()
		inbox.add_item(
			"%02d/%02d - %s%s" % [
				date.month,
				date.day,
				m.ref.sender,
				"*" if m.unread else ""
			]
		)
		inbox.set_item_metadata(idx, m)
		inbox.set_item_tooltip_enabled(idx, false)
	if inbox.get_item_count() <= 0:
		return
	yield(get_tree(), "idle_frame")
	inbox.select(0)
	visible = true
	tween.interpolate_property(self, "rect_position", Vector2(-200, 0), Vector2(0, 0), .2)
	tween.start()
	yield(tween, "tween_all_completed")
	inbox.grab_focus()
	inbox.grab_click_focus()
	inbox.unselect_all()
	opened = true
	set_process_input(true)
	yield(self, "done")
	set_process_input(false)
	opened = false
	tween.interpolate_property(self, "rect_position", Vector2(0, 0), Vector2(-200, 3), .2)
	tween.start()
	yield(tween, "tween_all_completed")
	tween.remove_all()
	inbox.release_focus()
	inbox.unselect_all()
	inbox.clear()
	visible = false

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
	if open_letter.ref.onDelivery:
		GameState.toggle_flag(open_letter.ref.onDelivery)

	var date = OS.get_datetime_from_unix_time(open_letter.delivered)
	inbox.set_item_text(
		index, 
		"%02d/%02d - %s%s" % [
			date.month,
			date.day,
			open_letter.ref.sender,
			""
		]
	)
	var text = letter.get_node("RichTextLabel")
	text.bbcode_text = "%s\n----\n%s" % [open_letter.ref.message, open_letter.ref.outro if open_letter.ref.outro else open_letter.ref.sender]
	text.scroll_to_line(0)
	tween.stop_all()
	tween.interpolate_property(letter, "rect_position", Vector2(25, 170), Vector2(25, 30), .2)
	tween.start()
	get_node("OpenLetter").play()
	yield(tween, "tween_all_completed")
	text.grab_focus()
	text.grab_click_focus()
	yield(self, "close_letter")
	tween.stop_all()
	tween.interpolate_property(letter, "rect_position", Vector2(25, 30), Vector2(25, 170), .2)
	tween.start()
	get_node("CloseLetter").play()
	yield(tween, "tween_all_completed")
	inbox.grab_focus()
	inbox.grab_click_focus()


func _on_ItemList_item_selected(_index):
	if not opened:
		return
		
	get_node("Cursor").play()
	
