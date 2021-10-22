extends YSort

enum Direction { Left, Up, Down, Right }
const dirtex = [
	preload("res://ui/karaoke/left.png"),
	preload("res://ui/karaoke/up.png"),
	preload("res://ui/karaoke/down.png"),
	preload("res://ui/karaoke/right.png")
]

export(Direction) var direction = Direction.Left

func _on_Karaoke_add_note(note):
	if note.get_meta("direction") != direction:
		return
	add_child(note)
	note.get_node("Sprite").texture = dirtex[direction]
	
func _on_Karaoke_end():
	for c in get_children():
		c.queue_free()
