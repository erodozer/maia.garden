extends Node2D

onready var seed_tool = get_tree().get_nodes_in_group("seed_tool").front()

onready var sprite = get_node("Anchor/Sprite")
onready var water_sprite = get_node("Watered")

var plant = null setget set_plant
var cell = 0

var planting_stamina_cost = 5
var watering_stamina_cost = 2

func _ready():
	if GameState.flag("garden_efficiency"):
		planting_stamina_cost = 3
		watering_stamina_cost = 1
		
	if not plant:
		return
	set_plant(plant)
	
func sow(cell):
	if GameState.stamina < planting_stamina_cost:
		return null
	
	var plant = GameState.garden.plant(seed_tool.current_tool, cell)
	
	if plant:
		GameState.stamina -= planting_stamina_cost  # planting costs some stamina
	
	return plant
	
func harvest(plant):
	# reaping costs no stamina
	GameState.inventory.insert_item({
		"id": plant.ref.id,
		"ref": plant.ref,
		"amount": 1,
	})
	
func water(plant):
	var watered = GameState.perform_action(watering_stamina_cost)
	if watered:
		plant.watered = true
		
func set_plant(p):
	plant = p
	
	if not p:
		water_sprite.visible = false
		sprite.visible = false
		return
	
	if plant.age == 0:
		sprite.texture = preload("res://scenes/garden/soil/seed.tres")
	elif plant.age >= plant.ref.mature:
		sprite.texture = plant.ref.mature_sprite
	else:
		sprite.texture = plant.ref.young_sprite
	
	sprite.visible = true	
	water_sprite.visible = plant.watered

func hint():
	if not seed_tool.current_tool.ref.effect:
		return null
	if seed_tool.current_tool.ref.effect.type != "flower":
		return null
	
	if not plant:
		return "Plant (%s)" % seed_tool.current_tool.ref.effect.name
	
	if plant.age >= plant.ref.mature:
		return "Pick (%s)" % [plant.ref.name]
	
	return "Water (%s)" % [plant.ref.name]

func interact():
	if not plant:
		var result = sow(cell)
		if result:
			self.plant = result
		return
		
	if plant.age >= plant.ref.mature:
		harvest(plant)
		set_plant(null)
		return
	if not plant.watered:
		water(plant)
		set_plant(plant)
