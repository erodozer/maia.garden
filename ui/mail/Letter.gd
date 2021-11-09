extends RichTextLabel

func _gui_input(event):
	if event.is_action_pressed("ui_down"):
		accept_event()
		get_v_scroll().value += event.get_action_strength("ui_down") * 12
	if event.is_action_pressed("ui_up"):
		accept_event()
		get_v_scroll().value -= event.get_action_strength("ui_up") * 12
