extends Node2D

"""
Manages interactive tilemap state

"""

const Plant = preload("./soil/Plant.tscn")

onready var player = get_tree().get_nodes_in_group("player").front()

onready var highlight = get_node("Highlight")

var selected = null
var plots = []

func _setup(params):
	if not params:
		return

	match params.location:
		"forest":
			player.position = Vector2(0, 192)
		_:
			player.position = Vector2(0, 0)
		
func _ready():
	var soil
	if GameState.flag("garden_boost_2"):
		soil = get_node("Plots/Level3")
	elif GameState.flag("garden_boost_1"):
		soil = get_node("Plots/Level2")
	else:
		soil = get_node("Plots/Level1")
	soil.visible = true
	
	for c in soil.get_used_cells():
		var xy = soil.map_to_world(c)
		var p = Plant.instance()
		p.cell = c
		p.global_position = soil.to_global(xy)
		get_node("Plants").add_child(p)
		if c in GameState.garden.plots:
			p.plant = GameState.garden.plots[c]
		plots.append(p)

func _input(event):
	if event.is_action_pressed("debug_advance"):
		for p in GameState.garden.plots:
			GameState.garden.plots[p].watered = true
		GameState.calendar.advance_day()
	if event.is_action_pressed("debug_money"):
		GameState.konpeto += 100

func _on_Maia_interact_start():
	set_process_input(false)

func _on_Maia_interact_end():
	set_process_input(true)

func _on_Maia_can_interact(npc):
	if npc in plots:
		highlight.global_position = npc.global_position
		highlight.visible = true
	else:
		highlight.visible = false
