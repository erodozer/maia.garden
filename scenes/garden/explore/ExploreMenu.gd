extends StaticBody2D

onready var scene_manager = get_tree().get_nodes_in_group("scene_manager").front()
onready var anim = get_node("CanvasLayer/AnimationPlayer")
onready var menu = get_node("CanvasLayer/Control/Anchor/PanelContainer/MarginContainer/ItemList")

signal end(scene)

func _ready():
	set_process_input(false)

func interact():
	anim.play("show")
	yield(anim, "animation_finished")
	menu.grab_focus()
	menu.grab_click_focus()
	set_process_input(true)
	var goto_scene = yield(self, "end")
	set_process_input(false)
	anim.play_backwards("show")
	yield(anim, "animation_finished")
	
	if not scene_manager:
		return
		
	if goto_scene:
		scene_manager.change_scene(goto_scene)

func hint():
	return "Explore the Forest"

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		emit_signal("end")

func _on_ItemList_item_activated(index):
	match index:
		0:
			emit_signal("end", "res://scenes/flower_shop/FlowerShop.tscn")
		1:
			pass
		2:
			emit_signal("end", "res://scenes/darkness/Darkness.tscn")
		_:
			pass
