extends Control

onready var tween = get_node("Tween")
onready var prompt = get_node("VBoxContainer/Panel/VBoxContainer/Label")
onready var requirements = get_node("VBoxContainer/Panel/VBoxContainer/Requirements")
onready var submit_button = get_node("VBoxContainer/Buttons/Submit")
onready var buttons = get_node("VBoxContainer/Buttons")

signal end(submit)

func _ready():
	set_process_input(false)

func open(request):
	for b in buttons.get_children():
		b.pressed = false
	visible = true
	# build the hint
	prompt.text = request.prompt()
	var text = "\n[b][table=2]"
	for i in request.get_requirements():
		text += "[cell]%dx[/cell][cell]%s[/cell]\n" % [i.amount, i.hint]
	text += "[/table][/b]"
	requirements.bbcode_text = text
	
	# test the requirements
	var has_items = request.requirements_met()
	buttons.visible = has_items
	if has_items:
		submit_button.grab_focus()
		
	yield(get_tree(), "idle_frame")
	tween.interpolate_property(self, "rect_position:y", -150, 0, .3)
	tween.start()
	yield(tween, "tween_all_completed")
	set_process_input(true)
	var submit = yield(self, "end")
	set_process_input(false)
	tween.interpolate_property(self, "rect_position:y", 0, -150, .3)
	tween.start()
	yield(tween, "tween_all_completed")
	visible = false
	for b in buttons.get_children():
		b.release_focus()
	return has_items and submit
		
func _input(event):
	if event.is_action_pressed("ui_accept"):
		if not buttons.visible:
			emit_signal("end", false)

	if event.is_action_pressed("ui_cancel"):
		emit_signal("end", false)


func _on_Submit_pressed():
	emit_signal("end", true)


func _on_Cancel_pressed():
	emit_signal("end", false)
