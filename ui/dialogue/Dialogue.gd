extends Node

onready var label = get_node("VBoxContainer/Control/Panel/MarginContainer/Label")
onready var tween = get_node("Tween")
onready var anim = get_node("AnimationPlayer")
onready var choice_buttons = get_node("VBoxContainer/MarginContainer/Choices")

signal next

func _ready():
	set_process_input(false)

func _input(event):
	if event.is_action_released("ui_accept"):
		emit_signal("next")

func open(lines, choices = []):
	label.percent_visible = 0
	anim.play("talk")
	yield(anim, "animation_finished")
	set_process_input(true)
	
	for line in lines:
		label.percent_visible = 0
		label.bbcode_text = line
		tween.stop_all()
		tween.interpolate_property(label, "percent_visible", 0, 1, 
			len(line) * (1.0 / 45.0)
		)
		tween.start()
		yield(self, "next")
		
	var selected = -1
	if len(choices) > 0:
		var group = ButtonGroup.new()
		for c in choices:
			var b = Button.new()
			b.toggle_mode = true
			b.group = group
			b.text = c
			b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			b.connect("focus_entered", b, "set", ["pressed", true])
			choice_buttons.add_child(b)
		var first_choice = group.get_buttons().front()
		first_choice.pressed = true
		first_choice.grab_focus()
		yield(self, "next")
		selected = group.get_buttons().find(group.get_pressed_button())
		
		for c in choice_buttons.get_children():
			c.queue_free()
	
	set_process_input(false)
	anim.play("close")
	yield(anim, "animation_finished")
	
	return selected
