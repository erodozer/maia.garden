extends ScrollContainer

const ItemRecord = preload("./ItemRecord.tscn")

onready var grid = get_node("GridContainer")

const SORT_TYPES = {
	"tool": -100,
	"flower": 0,
	"cafe": -500,
	"fish": 100,
}

func sort_by_type_and_weight(a, b):
	var a_weight = a.ref.sort_weight + SORT_TYPES[a.ref.type]
	var b_weight = b.ref.sort_weight + SORT_TYPES[b.ref.type]
	return a_weight < b_weight

func build():
	var inv = GameState.inventory.data.duplicate()
	inv.sort_custom(self, "sort_by_type_and_weight")
	
	for i in inv:
		if i.amount <= 0:
			continue
		var record = ItemRecord.instance()
		grid.add_child(record)
		var ref = i.ref
		record.get_node("Details/Icon").texture = i.icon
		record.get_node("Details/ItemName").text = ref.name
		if i.ref.stack > 1:
			record.get_node("Details/Count").text = "%d" % i.amount
		else:
			record.get_node("Details/Count").visible = false

func destroy():
	for i in grid.get_children():
		i.queue_free()
