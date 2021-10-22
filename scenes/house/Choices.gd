extends Control

signal choice
func _ready():
	set_process_input(false)

func _input(event):
	if event.is_action_pressed("ui_left"):
		emit_signal("choice", 0)
	if event.is_action_pressed("ui_right"):
		emit_signal("choice", 1)
	if event.is_action_pressed("ui_cancel"):
		emit_signal("choice", -1)

func pick():
	visible = true
	set_process_input(true)
	var idx = yield(self, "choice")
	set_process_input(false)
	visible = false
	return idx
