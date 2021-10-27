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

func _input(event):
	if event.is_action_pressed("ui_select"):
		set_process_input(false)
		yield(get_node("CanvasLayer/Journal").open(), "completed")
		set_process_input(true)

func _on_Maia_interact_start():
	set_process_input(false)

func _on_Maia_interact_end():
	set_process_input(true)
