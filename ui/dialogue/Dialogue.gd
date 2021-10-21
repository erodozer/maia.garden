extends CanvasLayer

onready var label = get_node("Control/Panel/MarginContainer/Label")
onready var tween = get_node("Tween")
onready var anim = get_node("AnimationPlayer")

signal next

var lines = []

func _ready():
	set_process_input(false)

func _input(event):
	if event.is_action_released("ui_accept"):
		emit_signal("next")

func begin():
	lines = []

func text(line):
	lines.append(line)
	
func exec():
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
	
	set_process_input(false)
	anim.play("close")
	yield(anim, "animation_finished")
	
