extends YSort

enum Direction { Left, Up, Down, Right }
const dirtex = [
	90,
	180,
	0,
	-90
]

export(Direction) var direction = Direction.Left

func _on_Karaoke_add_note(note):
	if note.get_meta("direction") != direction:
		return
	add_child(note)
	note.rotation_degrees = dirtex[direction]
	
func _on_Karaoke_end():
	for c in get_children():
		c.queue_free()
