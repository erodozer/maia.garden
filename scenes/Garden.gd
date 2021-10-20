extends Node2D

"""
Manages interactive tilemap state

"""

const PlantScene = preload("./Plant.tscn")

onready var plants = get_node("Objects")
onready var player = get_node("Maia")

func _on_Maia_perform_action(interactable):
	if interactable is Vector2:
		var plant = PlantScene.instance()
		plants.add_child(plant)
		plant.global_position = interactable
	elif interactable is Node and interactable.is_in_group("npc"):
		player.set_physics_process(false)
		yield(interactable.interact(), "completed")
		player.set_physics_process(true)
	
