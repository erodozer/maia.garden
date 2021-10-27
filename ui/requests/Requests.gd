extends Control

onready var game_state = get_tree().get_nodes_in_group("game_state").front()

onready var tween = get_node("Tween")
onready var requirements = get_node("VBoxContainer/Panel/Requirements")
onready var submit_button = get_node("VBoxContainer/Buttons/Submit")
onready var buttons = get_node("VBoxContainer/Buttons")

signal end(submit)

func _ready():
	set_process_input(false)

func open(request):
	# build the hint
	var text = "[center]%s[/center]" % request.prompt()
	for i in request.get_requirements():
		text += "\n[b]%s[/b]" % i.hint
	text += "\n"
	requirements.bbcode_text = text
	requirements.visible = true
	requirements.rect_position.y = -999
	
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
	requirements.visible = false
	
	return submit
		
func _input(event):
	if event.is_action_pressed("ui_accept"):
		emit_signal("end", submit_button.pressed)

	if event.is_action_pressed("ui_cancel"):
		emit_signal("end", false)
