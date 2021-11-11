extends Node

"""
Manages interactive tilemap state

"""

const godash = preload("res://addons/godash/godash.gd")

onready var player = get_tree().get_nodes_in_group("player").front()
onready var portals = get_tree().get_nodes_in_group("portals").front()

const BGMS = [
	preload("res://scenes/garden/bgm/ontama_rpg_itemshop.ogg"),
	preload("res://scenes/garden/bgm/PerituneMaterial_Laid_Back3_Retro_loop.ogg"),
	preload("res://scenes/garden/bgm/Æ⌐é╠Äxôx.ogg"),
]

func _start():
	if GameState.flag("introduce.proller") and not GameState.flag("introduce.proller.complete"):
		SceneManager.change_scene("darkness")
		return

	var garden_bgm
	if "garden_bgm" in GameState.temp:
		garden_bgm = GameState.temp.garden_bgm
	else:
		garden_bgm = godash.rand_choice(BGMS)
		GameState.temp["garden_bgm"] = garden_bgm
	Bgm.change_song(garden_bgm)

func _setup(params):
	if GameState.flag("introduce.proller") and not GameState.flag("introduce.proller.complete"):
		get_node("CanvasLayer/Fader").fade_in(0)
		return

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
