extends ScrollContainer

const Content = preload("res://content/content.gd")
const ItemRecord = preload("./ItemRecord.tscn")

onready var game_state = get_tree().get_nodes_in_group("game_state").front()

onready var grid = get_node("GridContainer")

func build():
	if not game_state:
		return
		
	for i in game_state.inventory.data:
		if i.amount <= 0:
			continue
		var record = ItemRecord.instance()
		grid.add_child(record)
		record.get_node("Details/Icon").texture = i.ref.icon
		record.get_node("Details/ItemName").text = i.ref.name
		record.get_node("Details/Count").text = "%d" % i.amount

func destroy():
	for i in grid.get_children():
		i.queue_free()
