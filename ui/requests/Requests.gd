extends Control

onready var tween = get_node("Tween")
onready var requirements = get_node("VBoxContainer/Panel/Requirements")
onready var submit_button = get_node("VBoxContainer/Buttons/Submit")
onready var buttons = get_node("VBoxContainer/Buttons")

signal end(submit)

func _ready():
	set_process_input(false)
	for b in buttons.get_children():
		b.connect("focus_entered", b, "set", ["pressed", true])

func open(request):
	visible = true
	# build the hint
	var text = "[center]%s[/center]" % request.prompt()
	for i in request.get_requirements():
		text += "\n[b]%s[/b]" % i.hint
	text += "\n"
	requirements.bbcode_text = text
	
	# test the requirements
	var has_items = request.requirements_met()
	buttons.visible = has_items
	submit_button.pressed = has_items
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
	return has_items and submit
		
func _input(event):
	if event.is_action_pressed("ui_accept"):
		emit_signal("end", submit_button.pressed)

	if event.is_action_pressed("ui_cancel"):
		emit_signal("end", false)
