extends Node2D

"""
Manages interactive tilemap state

"""

onready var player = get_node("Maia")

func _setup(params):
	if not params:
		return

	match params.location:
		"forest":
			player.position = Vector2(0, 192)
		_:
			player.position = Vector2(0, 0)

func _on_Maia_interact_start():
	set_process_input(false)

func _on_Maia_interact_end():
	set_process_input(true)
