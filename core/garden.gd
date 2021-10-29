extends Node

const godash = preload("res://addons/godash/godash.gd")
const Fortunes = preload("res://core/fortune.gd").Fortunes

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
	GameState.emit_signal("stat", "garden.plant", {
		"plant": plant
	})
	return plant
	
func kill(cell):
	if not (cell in plots):
		return false
		
	var plant = plots[cell]
	plots.erase(cell)
	GameState.emit_signal("stat", "garden.kill", {
		"plant": plant
	})
	return plant

func _on_calendar_advance(_day):
	for p in plots.values():
		# only mature watered flowers
		if p.watered:
			p.age += 1
		
		p.watered = false

func _on_Fortune_changed(fortune):
	# kill off some plants randomly
	if fortune == Fortunes.BAD_LUCK_DEAD_PLANTS:
		var amount = randi() % 6
		for i in range(amount):
			var cell = godash.rand_choice(plots.keys())
			if cell:
				kill(cell)
	
	# instantly mature a random amount of plants
	if fortune == Fortunes.GOOD_LUCK_PLANT:
		var amount = randi() % 6
		for i in range(amount):
			var plant = godash.rand_choice(plots.values())
			if plant:
				var age = plant.ref.mature
				plant.age = age
