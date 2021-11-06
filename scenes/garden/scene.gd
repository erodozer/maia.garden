extends Node

"""
Manages interactive tilemap state

"""

const godash = preload("res://addons/godash/godash.gd")

onready var player = get_tree().get_nodes_in_group("player").front()
onready var portals = get_tree().get_nodes_in_group("portals").front()

func _ready():
	Bgm.change_song(
		load(godash.rand_choice(
			godash.enumerate_dir("res://scenes/garden/bgm/", "ogg")
		))
	)

func _setup(params):
	if not params:
		return
	
	var portal = portals.get_node(params[0])
	if not portal:
		portal = portals.get_node("Home")
	player.position = portal.position
			
func _input(event):
	if event.is_action_pressed("debug_advance"):
		for p in GameState.garden.plots:
			GameState.garden.plots[p].watered = true
		GameState.calendar.advance_day()
	if event.is_action_pressed("debug_money"):
		GameState.player.balance += 100

func _on_Maia_interact_start():
	set_process_input(false)

func _on_Maia_interact_end():
	set_process_input(true)
