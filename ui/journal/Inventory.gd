extends ScrollContainer

const ItemRecord = preload("./ItemRecord.tscn")

onready var grid = get_node("GridContainer")

func build():		
	for i in GameState.inventory.data:
		if i.amount <= 0:
			continue
		var record = ItemRecord.instance()
		grid.add_child(record)
		record.get_node("Details/Icon").texture = i.ref.icon
		record.get_node("Details/ItemName").text = i.ref.name
		if i.amount > 1:
			record.get_node("Details/Count").text = "%d" % i.amount
		else:
			record.get_node("Details/Count").visible = false

func destroy():
	for i in grid.get_children():
		i.queue_free()
