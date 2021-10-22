extends Node2D

signal exit

func _unhandled_input(event):
	if event.is_action_released("ui_cancel"):
		emit_signal("exit")

func _on_Maia_interact_start():
	get_node("CanvasLayer/Control/ExitControl").visible = false

func _on_Maia_interact_end():
	get_node("CanvasLayer/Control/ExitControl").visible = true
