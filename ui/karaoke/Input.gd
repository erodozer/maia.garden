extends Area2D

enum Direction {
	Left,
	Up,
	Down,
	Right,
}

const DirToInput = {
	Direction.Left: "ui_left",
	Direction.Up: "ui_up",
	Direction.Down: "ui_down",
	Direction.Right: "ui_right",
}
const DirToAngle = {
	Direction.Left: 90,
	Direction.Up: 180,
	Direction.Down: 0,
	Direction.Right: -90,
}

export(Direction) var input_key = Direction.Left

onready var anim = get_node("AnimationPlayer")

const explosion = preload("res://ui/karaoke/HitExplosion.tscn")
var notes = []

signal hit
signal miss

func _ready():
	set_process_input(false)
	get_node("Sprite").rotation_degrees = DirToAngle[input_key]

func _input(event):
	if event.is_action_pressed(DirToInput[input_key]):
		anim.play("tap")
		if notes.empty():
			return
		var note = notes.front()
		if note:
			emit_signal("hit")
			note.queue_free()
			var e = explosion.instance()
			e.emitting = true
			add_child(e)

func _on_area_entered(area):
	notes.append(area)

func _on_area_exited(area):
	var idx = notes.find(area)
	notes.remove(idx)
	
	if area.is_queued_for_deletion():
		return
	
	area.get_node("Miss").visible = true
	area.get_node("Sprite").visible = false
	
	emit_signal("miss")

func _on_Karaoke_start():
	set_process_input(true)

func _on_Karaoke_end():
	set_process_input(false)
