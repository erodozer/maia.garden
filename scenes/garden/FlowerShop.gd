extends StaticBody2D

onready var scene_manager = get_tree().get_nodes_in_group("scene_manager").front()

func interact():
	if not scene_manager:
		return
	
	scene_manager.change_scene("res://scenes/flower_shop/FlowerShop.tscn")

func hint():
	return "Go to Flower Shop"
