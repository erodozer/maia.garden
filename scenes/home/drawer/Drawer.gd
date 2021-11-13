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
	var outfits = get_node("CanvasLayer/Anchor/Control/ItemList")
	var tween = get_node("CanvasLayer/Tween")
	
	outfits.clear()
	
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
	
	tween.interpolate_property(ui, "rect_position:y", 150, 0, .2)
	tween.start()
	yield(tween, "tween_all_completed")
	outfits.grab_focus()
	outfits.grab_click_focus()
	outfits.select(0)
	var selected = yield(outfits, "item_activated")
	match selected:
		0:
			GameState.player.outfit = "default"
		1:
			GameState.player.outfit = "hat"
		2:
			GameState.player.outfit = "tiny"
	tween.interpolate_property(ui, "rect_position:y", 0, 150, .2)
	tween.start()
	yield(tween, "tween_all_completed")
	outfits.clear()
