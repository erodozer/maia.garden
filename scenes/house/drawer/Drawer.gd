extends StaticBody2D

const Outfits = [
	"default",
	"hat",
	"tiny",
]

func hint():
	return "Open Drawer"

func interact():
	var ui = get_node("CanvasLayer/Anchor")
	var outfits = get_node("CanvasLayer/Anchor/Control/MarginContainer/ItemList")
	var tween = get_node("CanvasLayer/Tween")
	
	for outfit in Outfits:
		var unlock_key = "outfit.%s" % outfit
		if unlock_key in GameState.flags and GameState.flags[unlock_key]:
			outfits.add_item(
				outfit.capitalize(),
				load("res://characters/maia/outfits/%s/icon.tres" % outfit)
			)
		else:
			outfits.add_item(
				"[Locked]",
				load("res://characters/maia/outfits/%s/locked.tres" % outfit),
				false
			)
	
	tween.interpolate_property(ui, "rect_position:y", 200, 75, .3)
	tween.start()
	yield(tween, "tween_all_completed")
	outfits.grab_focus()
	outfits.grab_click_focus()
	var selected = yield(outfits, "item_activated")
	match selected:
		0:
			GameState.outfit = "default"
		1:
			GameState.outfit = "hat"
		2:
			GameState.outfit = "tiny"
	tween.interpolate_property(ui, "rect_position:y", 75, 200, .3)
	tween.start()
	yield(tween, "tween_all_completed")
	outfits.clear()
