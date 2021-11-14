extends StaticBody2D

const Outfits = [
	"default",
	"hat",
	"tiny",
]

signal end

func _ready():
	set_process_input(false)

func hint():
	return "Open Drawer"

func interact():
	var ui = get_node("CanvasLayer/Anchor")
	var outfits = get_node("CanvasLayer/Anchor/Control/ItemList")
	var tween = get_node("CanvasLayer/Tween")
	
	outfits.clear()
	
	for outfit in Outfits:
		var unlock_key = "outfit.%s" % outfit
		if unlock_key in GameState.flags and GameState.flag(unlock_key):
			outfits.add_item(
				outfit.capitalize(),
				load("res://characters/maia/outfits/%s/icon.tres" % outfit)
			)
		else:
			outfits.add_item(
				"[Locked]",
				load("res://characters/maia/outfits/%s/locked.tres" % outfit)
			)
	
	tween.interpolate_property(ui, "rect_position:y", 150, 0, .2)
	tween.start()
	yield(tween, "tween_all_completed")
	outfits.grab_focus()
	outfits.grab_click_focus()
	outfits.select(0)
	set_process_input(true)
	yield(self, "end")
	set_process_input(false)
	tween.interpolate_property(ui, "rect_position:y", 0, 150, .2)
	tween.start()
	yield(tween, "tween_all_completed")
	outfits.clear()

func _on_ItemList_item_activated(index):
	match index:
		0:
			GameState.player.outfit = "default"
		1:
			if not GameState.flag("outfit.hat"):
				return
			GameState.player.outfit = "hat"
		2:
			if not GameState.flag("outfit.tiny"):
				return
			GameState.player.outfit = "tiny"
	emit_signal("end")
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		emit_signal("end")
	
