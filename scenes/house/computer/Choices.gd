extends Control

onready var game_state = get_tree().get_nodes_in_group("game_state").front()

signal choice

func _ready():
	set_process_input(false)

func _input(event):
	if event.is_action_pressed("ui_left"):
		if game_state and game_state.stamina >= 25:
			emit_signal("choice", 0)
	if event.is_action_pressed("ui_right"):
		if game_state and game_state.stamina >= 40:
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
