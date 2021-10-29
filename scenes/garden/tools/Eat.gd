extends StaticBody2D

onready var seed_tool = get_tree().get_nodes_in_group("seed_tool").front()

func hint():
	if not seed_tool.current_tool.ref.effect:
		return null
		
	if seed_tool.current_tool.ref.effect.type == "cafe":
		return "Eat (%s)" % seed_tool.current_tool.ref.name
	
	return null

func interact():
	pass

func _on_Seeds_change_tool(new_tool):
	collision_layer = 4 if new_tool.ref.effect and new_tool.ref.effect.type == "cafe" else 0
