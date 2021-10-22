extends HBoxContainer

onready var label = get_node("Label")

func _on_Maia_can_interact(npc):
	if not npc:
		visible = false
		return
	
	visible = true
	var text = null
	if npc.has_method("hint"):
		text = npc.hint()
	
	if not text:
		label.text = "Interact"
	else:
		label.text = text

func _on_Maia_interact_start():
	visible = false

func _on_Maia_interact_end():
	visible = true
