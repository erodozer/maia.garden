extends Node2D

signal exit

func _unhandled_input(event):
	if event.is_action_released("ui_cancel"):
		emit_signal("exit")
