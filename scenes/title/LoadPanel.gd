extends Control

signal end

onready var list = get_node("PanelContainer/ItemList")

func _ready():
	set_process_input(false)

func open():
	build()
	list.select(0)
	visible = true
	list.grab_focus()
	set_process_input(true)
	yield(self, "end")
	set_process_input(false)
	visible = false
	
func build():
	list.clear()
	
	for s in ["auto", "00", "01", "02"]:
		var header = GameState.load_headers(s)
		if header:
			var d = OS.get_datetime_from_unix_time(header.updatedAt)
			list.add_item(
				"%s - %d/%d/%d %02d:%02d" % [s, d.day, d.month, d.year, d.hour, d.minute]
			)
		else:
			list.add_item(
				"%s - [Empty]" % [s]
			)
		var c = list.get_item_count() - 1
		list.set_item_metadata(c, s)
		list.set_item_tooltip_enabled(c, false)
		
	list.add_item("Delete Save Data")
	list.set_item_metadata(list.get_item_count() - 1, "delete")
	list.set_item_tooltip_enabled(list.get_item_count() - 1, false)
	
func _on_ItemList_item_activated(index):
	var slot = list.get_item_metadata(index)
	if slot == "delete":
		GameState.delete_game()
		build()
	else:
		emit_signal("end")
		GameState.load_game(slot)
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		emit_signal("end")
