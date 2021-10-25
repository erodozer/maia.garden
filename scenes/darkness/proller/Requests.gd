extends CanvasLayer

onready var tween = get_node("Control/Panel/Tween")
onready var panel = get_node("Control/Panel")
onready var requirements = get_node("Control/Panel/MarginContainer/Requirements")

signal read

func _ready():
	set_process_input(false)

func open(list):
	var text = "[center]Proller wants to add the following to their collection[/center]\n"
	for i in list:
		text += "\n[b]%s[/b]" % i
	requirements.bbcode_text = text
	requirements.visible = true
	requirements.rect_position.y = -999
	yield(get_tree(), "idle_frame")
	tween.interpolate_property(panel, "rect_position:y", -panel.rect_size.y - 4, 4, .2)
	tween.start()
	yield(tween, "tween_all_completed")
	set_process_input(true)
	yield(self, "read")
	set_process_input(false)
	tween.interpolate_property(panel, "rect_position:y", 4, -panel.rect_size.y - 4, .2)
	tween.start()
	yield(tween, "tween_all_completed")
	requirements.visible = false
	
func _input(event):
	if event.is_action_pressed("ui_accept"):
		emit_signal("read")
