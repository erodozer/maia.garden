extends Node2D

"""
Manages interactive tilemap state

"""

const PlantScene = preload("./soil/Plant.tscn")

onready var player = get_node("Maia")

func _setup(params):
	if not params:
		return

	match params.location:
		"forest":
			player.position = Vector2(0, 192)
		_:
			player.position = Vector2(0, 0)
