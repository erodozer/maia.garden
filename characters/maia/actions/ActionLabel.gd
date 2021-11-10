extends PanelContainer

onready var label = get_node("HBoxContainer/Label")

var interactable = false

func _on_Maia_can_interact(npc):
	visible = false
	if not npc:
		interactable = false
		return
	yield(get_tree(), "idle_frame")
	var text = null
	if npc.has_method("hint"):
		text = npc.hint()
	
	if not text:
		return
		
	label.text = text
	
	$HBoxContainer.rect_size = Vector2(0,0)
	$HBoxContainer.queue_sort()
	
	rect_size = Vector2(0, 0)
	queue_sort()
	
	call_deferred("set_visible", true)
	interactable = true
	
func _on_Maia_interact_start():
	visible = false

func _on_Maia_interact_end():
	call_deferred("set_visible", interactable)
	
