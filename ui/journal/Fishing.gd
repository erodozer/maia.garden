extends ScrollContainer

const ItemRecord = preload("./FishRecord.tscn")

onready var game_state = get_tree().get_nodes_in_group("game_state").front()
onready var Content = get_tree().get_nodes_in_group("content").front()

onready var pond_list = get_node("Content/Pond")
onready var river_list = get_node("Content/River")

func build():
	if not game_state:
		return
		
	for i in Content.Items:
		if i.type != "fish":
			continue
		
		var row = ItemRecord.instance()
		match i.location:
			"pond":
				pond_list.add_child(row)
			"river":
				river_list.add_child(row)
				
		var fishing_record = game_state.fishing_records[i.id]
		if fishing_record.size <= 0:
			row.get_node("Label").text = "???"
			row.get_node("Size").text = "N/A"
		else:
			row.get_node("Label").text = i.name
			row.get_node("Size").text = "%.02fin" % fishing_record.size
		
func destroy():
	for i in pond_list.get_children():
		i.queue_free()
	for i in river_list.get_children():
		i.queue_free()
