extends StaticBody2D

onready var game_state = get_tree().get_nodes_in_group("game_state").front()

func hint():
	return "Open Drawer"

func interact():
	var ui = get_node("CanvasLayer/Anchor")
	var outfits = get_node("CanvasLayer/Anchor/Control/MarginContainer/ItemList")
	var tween = get_node("CanvasLayer/Tween")
	
	tween.interpolate_property(ui, "rect_position:y", 200, 75, .3)
	tween.start()
	yield(tween, "tween_all_completed")
	outfits.grab_focus()
	outfits.grab_click_focus()
	var selected = yield(outfits, "item_activated")
	if game_state:
		match selected:
			0:
				game_state.outfit = "default"
			1:
				game_state.outfit = "hat"
			2:
				game_state.outfit = "tiny"
	tween.interpolate_property(ui, "rect_position:y", 75, 200, .3)
	tween.start()
	yield(tween, "tween_all_completed")
	
