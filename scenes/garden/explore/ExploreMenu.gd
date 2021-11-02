extends StaticBody2D

onready var tween = get_node("CanvasLayer/Tween")
onready var container = get_node("CanvasLayer/Menu")
onready var menu = get_node("CanvasLayer/Menu/ItemList")

signal end(scene)

func _ready():
	set_process_input(false)

func interact():
	if GameState.flag("introduce.chie"):
		menu.add_item("Shrine", null, true)
		menu.set_item_metadata(0, "shrine")
	else:
		menu.add_item("???", null, true)
	
	if GameState.flag("introduce.clover"):
		menu.add_item("Flower Shop", null, true)
		menu.set_item_metadata(1, "flower_shop")
	else:
		menu.add_item("???", null, true)
	
	if GameState.flag("introduce.yuuki"):
		menu.add_item("Cafe", null, true)
		menu.set_item_metadata(2, "cafe")
	else:
		menu.add_item("???", null, true)
	
	if GameState.flag("introduce.tazzle"):
		menu.add_item("Riverside Campsite", null, true)
		menu.set_item_metadata(3, "river")
	else:
		menu.add_item("???", null, true)
	
	if GameState.flag("introduce.proller"):
		menu.add_item("Darkness", null, true)
		menu.set_item_metadata(4, "darkness")
	else:
		menu.add_item("???", null, true)

	for i in range(menu.get_item_count()):
		menu.set_item_tooltip_enabled(i, false)
		
	tween.interpolate_property(container, "rect_position:y", -150, 75 - container.rect_size.y / 2, .3)
	tween.start()
	yield(tween, "tween_all_completed")
	menu.grab_focus()
	menu.grab_click_focus()
	set_process_input(true)
	var goto_scene = yield(self, "end")
	set_process_input(false)
	tween.interpolate_property(container, "rect_position:y", 75 - container.rect_size.y / 2, -150, .3)
	tween.start()
	yield(tween, "tween_all_completed")
		
	menu.clear()
	
	if goto_scene:
		SceneManager.change_scene(goto_scene)

func hint():
	return "Explore the Forest"

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		emit_signal("end")

func _on_ItemList_item_activated(index):
	var goto_scene = menu.get_item_metadata(index)
	if goto_scene:
		emit_signal("end", menu.get_item_metadata(index))
