extends ScrollContainer

const ItemRecord = preload("./FishRecord.tscn")

onready var pond_list = get_node("Content/Pond")
onready var river_list = get_node("Content/River")

func build():
	for i in Content.Items:
		if i.type != "fish":
			continue
		
		var row = ItemRecord.instance()
		match i.location:
			"river":
				river_list.add_child(row)
			_:
				pond_list.add_child(row)
				
		var fishing_record = GameState.fishing.records[i.id]
		if fishing_record.size <= 0:
			row.get_node("Label").text = "???"
			row.get_node("Size").text = "N/A"
			row.get_node("Rare").texture = null
			continue
		
		row.get_node("Label").text = i.name
		row.get_node("Size").text = "%.02fin" % fishing_record.size
		if not GameState.fishing.is_rare(i, fishing_record.size):
			row.get_node("Rare").texture = null
		
func destroy():
	for i in pond_list.get_children():
		i.queue_free()
	for i in river_list.get_children():
		i.queue_free()
