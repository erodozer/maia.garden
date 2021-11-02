extends Control

onready var panel = get_node("VBoxContainer/Control/CenterContainer/Panel")
onready var label = get_node("VBoxContainer/Control/CenterContainer/Panel/Label")
onready var tween = get_node("Tween")
onready var choice_buttons = get_node("VBoxContainer/MarginContainer/Choices")

signal next
signal choice(option)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		emit_signal("next")

func open(lines, choices = []):
	visible = true
	set_process_input(false)
	label.percent_visible = 0
	tween.remove_all()
	tween.interpolate_property(panel, "rect_min_size:x", 0, 180, .2)
	tween.start()
	yield(tween, "tween_all_completed")
	set_process_input(true)
	
	for line in lines:
		label.percent_visible = 0
		label.bbcode_text = line
		tween.remove_all()
		tween.interpolate_property(label, "percent_visible", 0, 1, 
			len(line) * (1.0 / 45.0)
		)
		tween.start()
		yield(tween, "tween_all_completed")
		yield(self, "next")
	
	set_process_input(false)
	yield(get_tree(), "idle_frame")
	var selected = null if len(choices) == 0 else choices.front()
	if len(choices) > 1:
		for c in choices:
			var b = Button.new()
			b.toggle_mode = true
			b.text = c
			b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			b.focus_mode = Control.FOCUS_ALL
			b.action_mode = BaseButton.ACTION_MODE_BUTTON_PRESS
			b.connect("toggled", self, "on_choice_selected", [b])
			b.pressed = false
			choice_buttons.add_child(b)
		var first_choice = choice_buttons.get_child(0)
		first_choice.grab_focus()
		yield(get_tree(), "idle_frame")
		selected = yield(self, "choice")
		
		for c in choice_buttons.get_children():
			c.queue_free()
	
	tween.remove_all()
	tween.interpolate_property(panel, "rect_min_size:x", 180, 0, .2)
	tween.start()
	yield(tween, "tween_all_completed")
	visible = false
	
	return selected
	
func on_choice_selected(pressed, choice):
	if not pressed:
		return
		
	emit_signal("choice", choice.text)
