extends "res://characters/npc/npc.gd"

onready var dialogue = get_tree().get_nodes_in_group("dialogue").front()

func hint():
	return "Talk to Chie"
	
func interact():
	return
	
