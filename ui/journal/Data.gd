extends ScrollContainer

onready var list = get_node("ItemList") as ItemList

func build():
	for s in ["00", "01", "02"]:
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
		var idx = list.get_item_count() - 1
		list.set_item_metadata(idx, s)
		list.set_item_tooltip_enabled(idx, false)
		
	list.add_item("Exit to Title")
	list.select(0)

func destroy():
	list.clear()

func _on_ItemList_item_activated(index):
	if index == 3:
		get_tree().paused = true
		yield(Bgm.fadeout(0.3), "completed")
		SceneManager.change_scene("title")
		return

	var slot = list.get_item_metadata(index)
	GameState.save_game(slot)
	
	destroy()
	yield(get_tree(), "idle_frame")
	build()

func _on_Data_focus_entered():
	list.grab_focus()
	list.grab_click_focus()
