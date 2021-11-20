extends StaticBody2D

const Outfits = {
	"default": {
		"text": "Your favorite fairy dress",
	},
	"hat": {
		"text": "Man I Love Fishing (makes fishing easier)",
	},
	"tiny": {
		"text": "Tiny Redeem (+20% Stream Payout bonus)"
	}
}

signal end

onready var outfits = get_node("CanvasLayer/Anchor/Control/ItemList")

func _ready():
	set_process_input(false)

func hint():
	return "Open Drawer"

func interact():
	var ui = get_node("CanvasLayer/Anchor")
	var tween = get_node("CanvasLayer/Tween")
	
	outfits.clear()
	
	for outfit in Outfits:
		var unlock_key = "outfit.%s" % outfit
		if unlock_key in GameState.flags and GameState.flag(unlock_key):
			outfits.add_item(
				outfit.capitalize(),
				load("res://characters/maia/outfits/%s/icon.tres" % outfit)
			)
			outfits.set_item_metadata(outfits.get_item_count() - 1, Outfits[outfit])
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
	get_node("Select").play()
	emit_signal("end")
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		emit_signal("end")

func _on_ItemList_item_selected(index):
	get_node("Cursor").play()
	var panel = get_node("CanvasLayer/Anchor/Description")
	var description = panel.get_node("Label")
	var meta = outfits.get_item_metadata(index)
	if meta:
		description.text = meta.text
		panel.visible = true
	else:
		panel.visible = false
		
