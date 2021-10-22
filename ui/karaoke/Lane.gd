extends Area2D

export var input_key = "ui_left"

var notes = []

signal hit
signal miss

func _input(event):
	if event.is_action_pressed(input_key):
		var note = notes.front()
		if note:
			emit_signal("hit")
			note.queue_free()

func _on_area_entered(area):
	notes.append(area)

func _on_area_exited(area):
	var idx = notes.find(area)
	notes.remove(idx)
	
	if area.is_queued_for_deletion():
		return
	
	emit_signal("miss")
