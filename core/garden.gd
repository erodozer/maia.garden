extends Node

var plots = {}

func plant(seed_tool, cell):
	# do not allow planting where there is already a plant
	if cell in plots:
		return null

	var flower = seed_tool.ref.flower
	if not flower:
		return null

	var planted = GameState.inventory.insert_item({
		"id": seed_tool.id,
		"amount": -1
	})
	
	if not planted:
		return null
	
	var plant = {
		"ref": flower,
		"age": 0,
		"watered": false,
		"cell": cell,
	}
	plots[cell] = plant
	GameState.total_flowers_planted += 1
	GameState.emit_signal("stat", "garden.plant", {
		"plant": plant
	})
	return plant

func _on_calendar_advance(_day):
	for p in plots.values():
		# only mature watered flowers
		if p.watered:
			p.age += 1
		
		p.watered = false
