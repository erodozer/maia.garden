extends Control

onready var tween = get_node("Tween")
onready var container = get_node("Menu")
onready var menu = get_node("Menu/ItemList")

signal end(scene)

func _ready():
	set_process_input(false)

func open():
	visible = true

	var waypoints = get_tree().get_nodes_in_group("waypoint")	
	
	for w in waypoints:
		if GameState.flag(w.flag):
			menu.add_item(w.name, null, true)
			menu.set_item_metadata(menu.get_item_count() - 1, w)
		else:
			menu.add_item("???", null, true)

	for i in range(menu.get_item_count()):
		menu.set_item_tooltip_enabled(i, false)
		
	yield(get_tree(), "idle_frame")
		
	tween.interpolate_property(container, "rect_position:y", -150, 75 - container.rect_size.y / 2, .3)
	tween.start()
	yield(tween, "tween_all_completed")
	menu.grab_focus()
	menu.grab_click_focus()
	set_process_input(true)
	var waypoint = yield(self, "end")
	set_process_input(false)
	tween.interpolate_property(container, "rect_position:y", 75 - container.rect_size.y / 2, -150, .3)
	tween.start()
	yield(tween, "tween_all_completed")
		
	menu.clear()
	
	visible = false
	
	return waypoint

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		emit_signal("end")

func _on_ItemList_item_activated(index):
	var goto_waypoint = menu.get_item_metadata(index)
	if goto_waypoint:
		emit_signal("end", goto_waypoint)
