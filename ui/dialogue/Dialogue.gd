extends Node

onready var panel = get_node("VBoxContainer/Control/CenterContainer/Panel")
onready var label = get_node("VBoxContainer/Control/CenterContainer/Panel/Label")
onready var tween = get_node("Tween")
onready var choice_buttons = get_node("VBoxContainer/MarginContainer/Choices")

signal next

func _ready():
	set_process_input(false)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		emit_signal("next")

func open(lines, choices = []):
	label.percent_visible = 0
	self.visible = true
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
		
	var selected = null if len(choices) == 0 else choices.front()
	if len(choices) > 1:
		var group = ButtonGroup.new()
		for c in choices:
			var b = Button.new()
			b.toggle_mode = true
			b.group = group
			b.text = c
			b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			b.focus_mode = Control.FOCUS_ALL
			b.pressed = false
			b.connect("focus_entered", b, "set", ["pressed", true])
			choice_buttons.add_child(b)
		var first_choice = group.get_buttons().front()
		first_choice.pressed = true
		first_choice.grab_focus()
		yield(self, "next")
		selected = choices[group.get_buttons().find(group.get_pressed_button())]
		
		for c in choice_buttons.get_children():
			c.queue_free()
	
	set_process_input(false)
	tween.remove_all()
	tween.interpolate_property(panel, "rect_min_size:x", 180, 0, .2)
	tween.start()
	yield(tween, "tween_all_completed")
	self.visible = false
	return selected
